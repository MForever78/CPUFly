`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:23:42 09/12/2015
// Design Name:   Seven_seg
// Module Name:   Z:/share/ISE/CPUFly/tests/Seven_seg_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Seven_seg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Seven_seg_test;

	// Inputs
	reg clk;
	reg reset;
	reg [31: 0] DAT_I;
	reg STB;
	reg WE;

	// Outputs
	wire [31:0] DAT_O;
	wire ACK;
	wire [7:0] Segment;
	wire [3:0] AN;
	wire [15: 0] debug_data_hold;

	// Instantiate the Unit Under Test (UUT)
	Seven_seg uut (
		.clk(clk), 
		.reset(reset), 
		.DAT_I(DAT_I), 
		.STB(STB), 
		.DAT_O(DAT_O), 
		.ACK(ACK), 
		.WE(WE), 
		.Segment(Segment), 
		.AN(AN), 
		.debug_data_hold(debug_data_hold)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		DAT_I = 0;
		STB = 0;
		WE = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        reset = 0;
        #50 DAT_I = 32'h00001234;
        STB = 1;
        #50 STB = 0;

	end

    always begin
        #25 clk = ~clk;
    end
      
endmodule

