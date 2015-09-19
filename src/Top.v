module Top(clk, reset, Segment, AN, VGA_R, VGA_G, VGA_B, hsync, vsync, kbd_clk, kbd_data, LED);
    input clk;
    input reset;
    input kbd_clk;
    input kbd_data;
    output [7: 0] Segment;
    output [3: 0] AN;
    output [2: 0] VGA_R, VGA_G;
    output [1: 0] VGA_B;
    output hsync, vsync;
    output [7: 0] LED;
    
    // slow clock down
    reg [5: 0] cnt = 0;
    always @(posedge clk) begin
        cnt <= cnt + 1;
    end
    
    wire sclk = cnt[5];

    // ===========
    // Wishbone IO
    // ===========

    // Master
    wire CPU_STB, CPU_ACK, CPU_WE;
    wire [31: 0] CPU_Data_I, CPU_Data_O, CPU_Addr;

    // Slave
    wire [16: 0] slave_ACK, slave_STB, slave_WE;
    wire [31: 0] slave_DAT_I, slave_ADDR;
    wire [511: 0] slave_DAT_O;

    // Slave members
    wire Keyboard_ACK, VGA_ACK, seven_seg_ACK, Ram_ACK, Counter_ACK;
    wire [31: 0] Keyboard_DAT_O, VGA_DAT_O, seven_seg_DAT_O, Ram_DAT_O, Counter_DAT_O;

    wire Ram_STB = slave_STB[1];
    wire seven_seg_STB = slave_STB[0];
    wire VGA_STB = slave_STB[2];
    wire Keyboard_STB = slave_STB[3];
    wire Counter_STB = slave_STB[4];

    // ==================
    // Instruction Memory
    // 32 bit * 16384
    // ==================

    wire [31: 0] pc;
    wire [31: 0] inst;

    Instruction_Memory im(
        .a(pc >> 2),
        .spo(inst)
    );

    CPU cpu(
        .clk(sclk),
        .reset(reset),
        .inst(inst),
        .Data_I(CPU_Data_I),
        .pc(pc),
        .Addr(CPU_Addr),
        .Data_O(CPU_Data_O),
        .WE(CPU_WE),
        .ACK(CPU_ACK),
        .STB(CPU_STB)
    );

    // Device signal address defination:
    // 0: Ram
    // 1: Seven seg
    // 2: VGA
    // 3: Keyboard
    // 4: Counter

    assign slave_ACK = {10'b0,Counter_ACK, Keyboard_ACK, VGA_ACK, Ram_ACK, seven_seg_ACK};
    assign slave_DAT_O = {320'b0, Counter_DAT_O, Keyboard_DAT_O, VGA_DAT_O, Ram_DAT_O, seven_seg_DAT_O};

    WB_intercon intercon(
        .master_STB(CPU_STB),
        .master_DAT_I(CPU_Data_O),
        .master_DAT_O(CPU_Data_I),
        .master_ACK(CPU_ACK),
        .master_WE(CPU_WE),
        .master_ADDR(CPU_Addr),
        .slave_STB(slave_STB),
        .slave_ACK(slave_ACK),
        .slave_WE(slave_WE),
        .slave_DAT_O(slave_DAT_I),
        .slave_DAT_I(slave_DAT_O),
        .slave_ADDR(slave_ADDR)
    );

    // ==============
    // Ram
    // 32 bit * 16384
    // ==============
    
    Ram_driver ram_driver(
        .clk(sclk),
        .Ram_STB(Ram_STB),
        .Ram_ACK(Ram_ACK)
    );

    Ram ram(
        .clka(clk),
        .addra(slave_ADDR >> 2),
        .dina(slave_DAT_I),
        .wea(slave_WE & Ram_STB),
        .douta(Ram_DAT_O)
    );
    

    Seven_seg seven_seg(
        .clk(clk),
        .reset(reset),
        //.DAT_I(slave_DAT_I),
        .DAT_I(pc),
        .DAT_O(seven_seg_DAT_O),
        //.STB(seven_seg_STB),
        .STB(1),
        .ACK(seven_seg_ACK),
        .WE(slave_WE),
        .Segment(Segment),
        .AN(AN)
    );

    Counter counter(
        .clk(clk),
        .reset(reset),
        .DAT_O(Counter_DAT_O),
        .STB(Counter_STB),
        .ACK(Counter_ACK)
    );

    // ===
    // VGA
    // ===

    wire [9: 0] x_ptr, y_ptr;
    wire [7: 0] color;

    Video_card video_card(
        .clk(sclk),
        .reset(reset),
        .x_ptr(x_ptr),
        .y_ptr(y_ptr),
        .color(color),
        .DAT_I(slave_DAT_I),
        .DAT_O(VGA_DAT_O),
        .WE(slave_WE),
        .STB(VGA_STB),
        .ACK(VGA_ACK),
        .ADDR(slave_ADDR >> 2)
    );

    Vga_dev vga_dev(
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .color(color),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .x_ptr(x_ptr),
        .y_ptr(y_ptr)
    );

    // ==========
    // Keyboard
    // ==========

    wire [7: 0] Keyboard_Data;
    wire Keyboard_ready_pulse;

    Keyboard_driver keyboard_driver(
        .clk(clk),
        .reset(reset),
        .ready_pulse(Keyboard_ready_pulse),
        .Keyboard_Data(Keyboard_Data),
        .ACK(Keyboard_ACK),
        .STB(Keyboard_STB),
        .DAT_O(Keyboard_DAT_O)
    );

    Keyboard_dev keyboard(
        .clk(clk),
        .reset(reset),
        .kbd_clk(kbd_clk),
        .kbd_data(kbd_data),
        .Keyboard_Data(Keyboard_Data),
        .ready_pulse(Keyboard_ready_pulse)
    );
    
    assign LED = Keyboard_Data;

endmodule
