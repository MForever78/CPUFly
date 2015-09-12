`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:22:03 09/12/2015
// Design Name:   Counter
// Module Name:   Z:/share/ISE/CPUFly/tests/Counter_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Counter_test;

	// Inputs
	reg clk;
	reg reset;
	reg STB;

	// Outputs
	wire [31:0] DAT_O;
	wire ACK;

	// Instantiate the Unit Under Test (UUT)
	Counter uut (
		.clk(clk), 
		.reset(reset), 
		.DAT_O(DAT_O), 
		.STB(STB), 
		.ACK(ACK)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		STB = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here 

	end
    
    always begin
        #1 clk = ~clk;
    end
      
endmodule

