`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:42:35 09/12/2015
// Design Name:   CPU
// Module Name:   Z:/share/ISE/CPUFly/tests/CPU_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_test;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] inst;
	reg [31:0] Data_I;
	reg ACK;

	// Outputs
	wire [31:0] pc;
	wire [31:0] Addr;
	wire [31:0] Data_O;
	wire WE;
	wire STB;
    wire [31: 0] debug_next_pc;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.clk(clk), 
		.reset(reset), 
		.pc(pc), 
		.inst(inst), 
		.Addr(Addr), 
		.Data_I(Data_I), 
		.Data_O(Data_O), 
		.WE(WE), 
		.ACK(ACK), 
		.STB(STB),
        .debug_next_pc(debug_next_pc)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		inst = 0;
		Data_I = 0;
		ACK = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        reset = 0;
        #50 inst = 32'h00008020;
        #50 inst = 32'h3c101000;
        #50 inst = 32'h20111234;
        #50 inst = 32'hae110000;
            ACK = 1;
        #50 inst = 32'h08100004;
            ACK = 0;
	end

    always begin
        #25 clk = ~clk;
    end
      
endmodule

