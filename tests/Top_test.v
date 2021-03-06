`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:52:37 09/12/2015
// Design Name:   Top
// Module Name:   Z:/share/ISE/CPUFly/tests/Top_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Top_test;

	// Inputs
	reg clk;
	reg reset;
    reg kbd_clk, kbd_data;

	// Outputs
	wire [7:0] Segment;
	wire [3:0] AN;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk(clk), 
		.reset(reset), 
		.Segment(Segment), 
        .kbd_clk(kbd_clk),
        .kbd_data(kbd_data),
		.AN(AN)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        reset = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 1;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 1;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 1;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 1;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
        #50 kbd_clk = 1;
        kbd_data = 0;
        #50 kbd_clk = 0;
	end
      
    always begin
        #10 clk = ~clk;
    end
endmodule

