`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:32:43 09/11/2015
// Design Name:   WB_intercon
// Module Name:   Z:/share/ISE/CPUFly/tests/WB_intercon_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: WB_intercon
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module WB_intercon_test;

	// Inputs
	reg master_STB;
	reg [31:0] master_DAT_I;
	reg master_WE;
	reg [31:0] master_ADDR;
	reg [15:0] slave_ACK;
	reg [511:0] slave_DAT_I;

	// Outputs
	wire [31:0] master_DAT_O;
	wire master_ACK;
	wire [15:0] slave_STB;
	wire slave_WE;
	wire [31:0] slave_DAT_O;
	wire [31:0] slave_ADDR;

	// Instantiate the Unit Under Test (UUT)
	WB_intercon uut (
		.master_STB(master_STB), 
		.master_DAT_I(master_DAT_I), 
		.master_DAT_O(master_DAT_O), 
		.master_ACK(master_ACK), 
		.master_WE(master_WE), 
		.master_ADDR(master_ADDR), 
		.slave_STB(slave_STB), 
		.slave_ACK(slave_ACK), 
		.slave_WE(slave_WE), 
		.slave_DAT_I(slave_DAT_I), 
		.slave_DAT_O(slave_DAT_O), 
		.slave_ADDR(slave_ADDR)
	);

	initial begin
		// Initialize Inputs
		master_STB = 0;
		master_DAT_I = 0;
		master_WE = 0;
		master_ADDR = 0;
		slave_ACK = 0;
		slave_DAT_I = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        
        master_STB = 1;
        master_DAT_I = 16'h2333;
        master_WE = 1;
        master_ADDR = 32'h10000000;
        slave_ACK = 1;
        slave_DAT_I = 32'h00002333;
	end
      
endmodule

