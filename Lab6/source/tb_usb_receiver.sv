// $Id: $
// File name:   tb_usb_receiver.sv
// Created:     2/5/2013
// Author:      Vikram
// Lab Section: 05
// Version:     1.0  Initial Design Entry
// Description: starter top level test bench provided for Lab 6

`timescale 1ns / 10ps

module tb_usb_receiver();

	// Define parameters
	parameter CLK_PERIOD				= 10;
	parameter NORM_DATA_PERIOD	= (8 * CLK_PERIOD);
	
	localparam OUTPUT_CHECK_DELAY = (CLK_PERIOD - 0.2);
	localparam WORST_FAST_DATA_PERIOD = (NORM_DATA_PERIOD * 0.965);
	localparam WORST_SLOW_DATA_PERIOD = (NORM_DATA_PERIOD * 1.035);
	
	//  DUT inputs
	reg tb_clk;
	reg tb_n_rst;
	reg tb_d_plus;
	reg tb_d_minus;
	reg tb_r_enable;
	
	// DUT outputs
	wire [7:0] tb_r_data;
	wire tb_full;
	wire tb_r_error;
	wire tb_rcving;
	wire tb_empty;

	
	// Test bench debug signals
	// Overall test case number for reference
	integer tb_test_case;
	// Test case 'inputs' used for test stimulus
	//reg [7:0] tb_test_data;
	reg 			tb_test_stop_bit;
	time 			tb_test_bit_period;
	reg				tb_test_data_read;
	// Test case expected output values for the test case
	reg [7:0] tb_expected_r_data;
	reg tb_expected_r_error;
	reg tb_expected_rcving;
	reg tb_expected_full;
	reg tb_expected_empty;
	
	// DUT portmap
	usb_receiver DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.d_plus(tb_d_plus),
		.d_minus(tb_d_minus),
		.r_data(tb_r_data),
		.full(tb_full),
		.empty(tb_empty),
		.r_enable(tb_r_enable),
		.r_error(tb_r_error),
		.rcving(tb_rcving)
	);
		
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_n_rst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_n_rst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask
	
	task check_outputs;
		input [7:0] expected_r_data;
		input expected_rcving;
		input expected_r_error;
		input expected_empty;
		input expected_full;
	begin
		assert(expected_r_data == tb_r_data)
			$info("Test case %0d: Test data correctly received", tb_test_case);
		else
			$error("Test case %0d: Test data incorrectly received", tb_test_case);
		assert(expected_r_error == tb_r_error)
			$info("Test case %0d: Test r_error correctly received", tb_test_case);
		else
			$error("Test case %0d: Test r_error incorrectly received", tb_test_case);
		assert(expected_rcving == tb_rcving)
			$info("Test case %0d: Test rcving correctly received", tb_test_case);
		else
			$error("Test case %0d: Test rcving incorrectly received", tb_test_case);
		assert(expected_full == tb_full)
			$info("Test case %0d: Test rcving correctly received", tb_test_case);
		else
			$error("Test case %0d: Test rcving incorrectly received", tb_test_case);
		assert(expected_empty == tb_empty)
			$info("Test case %0d: Test rcving correctly received", tb_test_case);
		else
			$error("Test case %0d: Test rcving incorrectly received", tb_test_case);		
	end
	endtask
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end

	initial
	begin : TEST_PROC
		// Initilize all inputs to inactive/idle values
		tb_n_rst			= 1'b1; // Initially inactive
		tb_d_plus	= 1'b1; // Initially idle
		tb_d_minus      = 1'b0;
		tb_r_enable	= 1'b0; // Initially inactive
		
		// Get away from Time = 0
		#0.1; 
		
		// Test case 0: Basic Power on Reset
		tb_test_case = 0;
		
		// Power-on Reset Test case: Simply populate the expected outputs
		// These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
		tb_r_enable = 0;
		tb_test_bit_period	= NORM_DATA_PERIOD;
		
		tb_expected_r_data 			= 8'b0;
		tb_expected_r_error		= 1'b0; 
		tb_expected_empty = 1'b1;
		tb_expected_full				= 1'b0;
		
		// DUT Reset
		reset_dut;
		
		// Check outputs
		check_outputs(tb_expected_r_data, tb_expected_rcving, tb_expected_r_error, 
                              tb_expected_empty, tb_expected_full);

	end

endmodule