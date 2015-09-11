module Top(clk, reset, Segment, AN);
    input clk;
    input reset;
    output [7: 0] Segment;
    output [3: 0] AN;

    // ========
    // Wishbone IO
    // ========

    // Master
    wire CPU_STB, CPU_ACK, CPU_WE;
    wire [31: 0] CPU_Data_I, CPU_Data_O, CPU_Addr;

    // Slave
    wire [16: 0] slave_ACK, slave_STB, slave_WE;
    wire [31: 0] slave_DAT_I, slave_ADDR;
    wire [511: 0] slave_DAT_O;

    // Slave members
    wire Keyboard_ACK, VGA_ACK, seven_seg_ACK, Ram_ACK;
    wire [31: 0] Keyboard_DAT_O, VGA_DAT_O, seven_seg_DAT_O, Ram_DAT_O;

    wire Ram_STB = slave_STB[0];
    wire seven_seg_STB = slave_STB[1];
    wire VGA_STB = slave_STB[2];
    wire Keyboard_STB = slave_STB[3];

    // ========
    // Instruction Memory
    // 32 bit * 32768
    // ========

    wire [31: 0] pc;
    wire [31: 0] inst;

    Instruction_Memory (
        .a(pc),
        .spo(inst)
    );

    CPU (
        .clk(clk),
        .reset(rest),
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

    assign slave_ACK = {11'b0, Keyboard_ACK, VGA_ACK, seven_seg_ACK, Ram_ACK};
    assign slave_DAT_O = {352'b0, Keyboard_DAT_O, VGA_DAT_O, seven_seg_DAT_O, Ram_DAT_O};

    WB_intercon (
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

    // ========
    // Ram
    // 32 bit * 16384
    // ========

    Ram (
        .clka(clk),
        .addra(slave_ADDR),
        .dina(slave_DAT_I),
        .wea(slave_WE),
        .douta(Ram_DAT_O)
    );

    Seven_seg (
        .clk(clk),
        .DAT_I(slave_DAT_I),
        .DAT_O(seven_seg_DAT_O),
        .STB(seven_seg_STB),
        .ACK(seven_seg_ACK),
        .WE(slave_WE),
        .Segment(Segment),
        .AN(AN)
    );

endmodule
