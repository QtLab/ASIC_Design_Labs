// $Id: $
// File name:   tb_moore.sv
// Created:     2/8/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Testbench for tb edge state machine.
// 
`timescale 1ns / 10ps
module tb_edge_detect();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
	
	// Shared Test Variables
	reg tb_clk;

	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	// Default Config Test Variables & constants
	
	integer tb_test_num;
	reg tb_n_rst;
        reg tb_d_plus;
        reg tb_expected_d_edge;
	reg tb_d_edge;

	generate
	// DUT portmaps
		edge_detect DUT
		(
			.clk(tb_clk),
			.n_rst(tb_n_rst),
			.d_plus(tb_d_plus),
                        .d_edge(tb_d_edge)
		);
	endgenerate
	
	clocking cb @(posedge tb_clk);
 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output d_plus = tb_d_plus;
		input d_edge = tb_d_edge;
	endclocking
	
	// Default Configuration Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_n_rst		= 1'b1;		// Initialize to be inactive
		tb_test_num 	= 0;
		tb_expected_d_edge = 0;
		tb_d_plus =0;
		
		@(negedge tb_clk);
		tb_n_rst	<= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		@cb;
		cb.n_rst	<= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		@cb;
		@cb;
		
		// Test 1: Check for Proper Reset with no inputs
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;
		cb.d_plus <= 1'b0;
		tb_expected_d_edge = 0;

		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_d_edge == cb.d_edge)
			$info("Case %0d:: PASSED Correct output value", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED - incorrect output value %d", tb_test_num, cb.d_edge);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 2: Check for Proper detection
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;
		cb.d_plus <= 1'b0;
		tb_expected_d_edge = 1;

		@cb; // Measure slightly before the second clock edge
		@cb;
                cb.n_rst <= 0;
                @cb;
		cb.n_rst <= 1'b1;
		@cb;
		@cb;
                cb.d_plus <=0;
                @cb;
                cb.d_plus <=1;
                @cb;
		@cb;
		if (tb_expected_d_edge == cb.d_edge)
			$info("Case %0d:: PASSED Correct output value", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED - incorrect output value %d", tb_test_num, cb.d_edge);
		// De-assert reset for a cycle


// Test 3: Check for Proper detection to 0
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;
		cb.d_plus <= 1'b0;
		tb_expected_d_edge = 1;

		@cb; // Measure slightly before the second clock edge
		@cb;
                cb.n_rst <= 0;
                @cb;
		cb.n_rst <= 1'b1;
		@cb;
		@cb;
                cb.d_plus <=0;
                @cb;
                cb.d_plus <=1;
                @cb;
		@cb;
		cb.d_plus <=0;
		@cb;
		@cb;
		
		if (tb_expected_d_edge == cb.d_edge)
			$info("Case %0d:: PASSED Correct output value", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED - incorrect output value %d", tb_test_num, cb.d_edge);
		// De-assert reset for a cycle

// Test 3: Check for Proper detection to 0
		tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;
		cb.d_plus <= 1'b0;
		tb_expected_d_edge = 0;

		@cb; // Measure slightly before the second clock edge
		@cb;
                cb.n_rst <= 0;
                @cb;
		cb.n_rst <= 1'b1;
		@cb;
		@cb;
                cb.d_plus <=0;
                @cb;
                cb.d_plus <=1;
                @cb;
		@cb;
		cb.d_plus <=0;
		@cb;
		@cb;
		@cb;
		
		if (tb_expected_d_edge == cb.d_edge)
			$info("Case %0d:: PASSED Correct output value", tb_test_num);
		else // Test case failed
			$error("Case %0d:: FAILED - incorrect output value %d", tb_test_num, cb.d_edge);
		// De-assert reset for a cycle
               
	



      end 
endmodule
