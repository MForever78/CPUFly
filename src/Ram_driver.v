module Ram_driver(clk, Ram_STB, Ram_ACK);
    input clk;
    input Ram_STB;
    output reg Ram_ACK;

    reg old_STB;
    always @(posedge clk) begin
        old_STB <= Ram_STB;
        if (old_STB && Ram_STB) Ram_ACK <= 1;
        else Ram_ACK <= 0;
    end
endmodule
