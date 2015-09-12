module Counter(clk, reset, DAT_O, STB, ACK);

    input clk;
    input reset;
    input STB;
    output ACK;
    output [31: 0] DAT_O;

    reg [31: 0] cnt, ms, ten_ms;
    reg ms_pulse, ten_ms_pulse, s_pulse;

    assign ACK = STB;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt <= 0;
            ms <= 0;
            ten_ms <= 0;
        end else begin
            if (ten_ms == 10) begin
                ten_ms <= 0;
                s_pulse <= 1;
            end else begin
                if (ms == 10) begin
                    ms <= 0;
                    ten_ms_pulse <= 1;
                    ten_ms <= ten_ms + 1;
                end else begin
                    if (cnt == 1000000) begin
                        cnt <= 0;
                        ms_pulse <= 1;
                        ms <= ms + 1;
                    end else begin
                        cnt <= cnt + 1;
                        ms <= ms;
                        ten_ms <= ten_ms;
                        ms_pulse <= 0;
                        ten_ms_pulse <= 0;
                        s_pulse <= 0;
                    end
                end
            end
        end
    end

    assign DAT_O = {28'b0, s_pulse, ten_ms_pulse, ms_pulse};

endmodule
