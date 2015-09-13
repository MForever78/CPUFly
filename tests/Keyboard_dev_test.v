`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:54 09/13/2015
// Design Name:   Keyboard_dev
// Module Name:   E:/Seafile/ISE/CPUFly/tests/Keyboard_dev_test.v
// Project Name:  CPUFly
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Keyboard_dev
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Keyboard_dev_test;

	// Inputs
	reg clk;
	reg reset;
	reg kbd_clk;
	reg kbd_data;

	// Outputs
	wire [7:0] Keyboard_Data;
	wire ready_pulse;

	// Instantiate the Unit Under Test (UUT)
	Keyboard_dev uut (
		.clk(clk), 
		.reset(reset), 
		.kbd_clk(kbd_clk), 
		.kbd_data(kbd_data), 
		.Keyboard_Data(Keyboard_Data), 
		.ready_pulse(ready_pulse)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		kbd_clk = 0;
		kbd_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
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

	end

    always begin
        #25 clk = ~clk;
    end
      
endmodule

