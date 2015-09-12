module Counter(clk, reset, DAT_O, STB, ACK);

    input clk;
    input reset;
    input STB;
    output ACK;
    output [31: 0] DAT_O;

    reg [31: 0] cnt, timer;

    assign ACK = STB;

    initial begin
        cnt = 0;
        timer = 0;
    end
    
    always @(posedge clk) begin
        if (cnt == 1000000) begin
            cnt <= 0;
            timer <= timer + 1;
        end else begin
            cnt <= cnt + 1;
            timer <= timer;
        end
    end

    assign DAT_O = timer;

endmodule
