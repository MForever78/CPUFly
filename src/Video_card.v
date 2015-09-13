module Video_card(clk, reset, x_ptr, y_ptr, color, DAT_I, STB, ACK, ADDR);
    input clk, reset;
    input [9: 0] x_ptr, y_ptr;
    input [31: 0] DAT_I;
    input STB;
    input [31: 0] ADDR;
    output reg ACK;
    output [7: 0] color;

    wire [9: 0] x_offset, y_offset;
    wire [7: 0] ASCii;
    wire [11: 0] baseAddr;
    wire [11: 0] font_Addr;
    wire [7: 0] font_DAT;
    wire is_text;
    wire [15: 0] DAT;
    wire [11: 0] Addr;
    wire [9: 0] x, y;

    reg [15: 0] mem [0: 4799];

    initial begin
        mem[0] = 16'h004d;
        mem[1] = 16'h0046;
        mem[2] = 16'h006f;
        mem[3] = 16'h0072;
        mem[4] = 16'h0065;
        mem[5] = 16'h0076;
        mem[6] = 16'h0065;
        mem[7] = 16'h0072;
        mem[8] = 16'h0037;
        mem[9] = 16'h0038;
    end

    integer i;

    always @(posedge clk) begin
        // CPU wants to write
        if (STB) begin
            mem[ADDR] <= DAT_I;
            ACK <= 1;
        end else begin
            ACK <= 0;
        end
    end

    assign x = x_ptr >> 3;
    assign y = y_ptr >> 4;
    assign Addr = (y * 80) + x;

    assign DAT = mem[Addr];

    assign x_offset = x_ptr - (x << 3);
    assign y_offset = y_ptr - (y << 4);
    assign ASCii = DAT[7: 0];
    assign baseAddr = ASCii << 4;
    assign font_Addr = baseAddr + y_offset;
    assign is_text = font_DAT[8 - x_offset];
    assign color = is_text ? 8'b11111111 : 8'b00000000;

    Font font(
        .a(font_Addr),
        .spo(font_DAT)
    );

endmodule
