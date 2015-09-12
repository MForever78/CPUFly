module Vga_dev(clk, reset, hsync, vsync, color, VGA_R, VGA_G, VGA_B, x_ptr, y_ptr);
// VGA 640*480 60Hz

    input clk;
    input reset;
    input [7: 0] color;
    output vsync, hsync;
    output [2: 0] VGA_R, VGA_G;
    output [1: 0] VGA_B;

    output [9: 0] x_ptr, y_ptr;

    reg [9: 0] x_cnt, y_cnt;
    reg [1: 0] cnt = 0;
    wire [7: 0] color;

    always @(posedge clk or posedge reset) begin
        if (reset) cnt <= 0;
        else cnt <= cnt + 1;
    end

    parameter
        HPIXELS = 10'd800,
        VLINES = 10'd521,
        HBP = 10'd144,
        HFP = 10'd784,
        VBP = 10'd31,
        VFP = 10'd511;

    initial begin
        x_cnt = 0;
        y_cnt = 0;
    end

    always @(posedge cnt[1]) begin
        if (x_cnt == HPIXELS - 1)
            x_cnt <= 0;
        else
            x_cnt <= x_cnt + 1;
    end

    always @(posedge cnt[1]) begin
        if (x_cnt == HPIXELS - 1) begin
            if (y_cnt == VLINES - 1)
                y_cnt <= 0;
            else y_cnt <= y_cnt + 1;
        end else
            y_cnt <= y_cnt;
    end

    assign valid = (x_cnt > HBP) && (x_cnt < HFP) && (y_cnt > VBP) && (y_cnt < VFP);

    assign hsync = (x_cnt >= 10'd96) ? 1'b1 : 1'b0;
    assign vsync = (y_cnt >= 10'd2) ? 1'b1 : 1'b0;

    assign x_ptr = x_cnt - HBP;
    assign y_ptr = y_cnt - VBP;

    assign VGA_R = valid ? color[7: 5] : 0;
    assign VGA_G = valid ? color[4: 2] : 0;
    assign VGA_B = valid ? color[1: 0] : 0;

endmodule
