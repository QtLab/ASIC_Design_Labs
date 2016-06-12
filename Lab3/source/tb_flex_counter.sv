// $Id: $
// File name:   tb_flex_counter.sv
// Created:     2/4/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: testbench for flex counter.
`timescale 1ns / 10ps

module tb_flex_counter();

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
	
	localparam DEFAULT_SIZE = 4;

	tb_flex_counter_DUT #(.SIZE(DEFAULT_SIZE)) flex_counter_default(.tb_clk);
endmodule

module tb_flex_counter_DUT
	#(parameter SIZE = 4, NAME = "default")
	(input wire tb_clk);

	// Default Config Test Variables & constants
	localparam MAX_BIT = (SIZE - 1);
	
	integer tb_test_num;
	reg tb_n_rst;
	reg tb_clear;
	reg tb_count_enable;
        reg tb_rollover_flag;
	reg [MAX_BIT:0] tb_rollover_val;
	reg [MAX_BIT:0] tb_count_out;
        reg tb_expected_rollover_flag;
	reg [MAX_BIT:0] tb_expected_count_out;

	generate
	if(NAME == "default")
	// DUT portmaps
		flex_counter DUT
		(
			.clk(tb_clk),
			.n_rst(tb_n_rst),
			.clear(tb_clear),
			.count_enable(tb_count_enable),
			.rollover_val(tb_rollover_val),
                        .rollover_flag(tb_rollover_flag),
                        .count_out(tb_count_out)
		);
	endgenerate
	
	clocking cb @(posedge tb_clk);
 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output clear = tb_clear,
			count_enable = tb_count_enable,
                       rollover_val=tb_rollover_val;
		input count_out = tb_count_out,
                      rollover_flag = tb_rollover_flag;
	endclocking
	
	// Default Configuration Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_n_rst		= 1'b1;		// Initialize to be inactive
		tb_clear	= 1'b0;		// Initialize to be idle
		tb_count_enable		= 1'b0;		// Initialize to be inactive
		tb_test_num 	= 0;
		tb_expected_rollover_flag = 0;
		tb_expected_count_out = 0;
		
		// Power-on Reset of the DUT
		// Assume we start at negative edge. Immediately assert reset at first negative edge
		// without using clocking block in order to avoid metastable value warnings
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
		cb.count_enable <= 1'b0;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b1111;

		tb_expected_count_out = 0;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect count out value", NAME, tb_test_num);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;
		
		// Test 2: Check for NReset when other inputs asserted
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b0;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b1;
		cb.rollover_val <= 4'b1010;

		tb_expected_count_out = 0;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect count out value", NAME, tb_test_num);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;


		// Test 3: Check for Proper clear when count_enabled
		// Power-on Reset of the DUT (Best case conditions)
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b1;
		cb.rollover_val <= 4'b1111;

		tb_expected_count_out = 0;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect count out value", NAME, tb_test_num);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 4: Check for Proper clear when count_enabled
		// Power-on Reset of the DUT (Best case conditions)
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b1;
		cb.rollover_val <= 4'b1111;

		tb_expected_count_out = 0;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second clock edge
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect count out value", NAME, tb_test_num);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 5: Check for Proper counting
		// Power-on Reset of the DUT (Best case conditions)
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b0111;

		tb_expected_count_out = 4'b0010;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second clock edge
		@cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 6: Testing ROllover!
		// Power-on Reset of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b011;

		tb_expected_count_out = 4'b0011;
		tb_expected_rollover_flag = 1;
		@cb; // Measure slightly before the second clock edge
		@cb;
		@cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 7: Testing ROllover makes count go to 1!
		// Power-on Reset of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b010;

		tb_expected_count_out = 4'b0001;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second 4th edge
		@cb;
		@cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 8: Testing ROllover makes count go to 1!
		// Power-on Reset of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b010;

		tb_expected_count_out = 4'b0001;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second 5th edge
		@cb;
		@cb;
                cb.count_enable<=0;
		@cb;
                @cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;


// Test 9: Testing ROllover makes count go to 1!
		// Power-on Reset of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b010;

		tb_expected_count_out = 4'b0001;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second 5th edge
		@cb;
		@cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 10: EXTRA tests
		// Power-on Reset of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b1111;

		tb_expected_count_out = 4'b1111;
		tb_expected_rollover_flag = 1;
		@cb; // Measure slightly before the second clock edge
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;
		@cb;

		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 11: EXTRA TESTS 1
		//et of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b0101;

		tb_expected_count_out = 4'b0010;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second 5th edge
		@cb;
		@cb;
                cb.count_enable<=0;
		@cb;
                @cb;
		@cb;
		@cb;
  		cb.clear <= 1;
		@cb;
		@cb;
		cb.count_enable<=1;
		@cb;
		@cb;
		@cb;
		@cb;
 		cb.clear<=0;
		@cb;
		@cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

// Test 12: EXTRA TESTS 2
		//et of the DUT (Best case conditions)
                cb.n_rst <= 1'b0;
		@cb;
		cb.n_rst <= 1'b1;
                tb_test_num = tb_test_num + 1;
		cb.n_rst <= 1'b1;
		cb.count_enable <= 1'b1;
                cb.clear <= 1'b0;
		cb.rollover_val <= 4'b1000;

		tb_expected_count_out = 4'b0010;
		tb_expected_rollover_flag = 0;
		@cb; // Measure slightly before the second 5th edge
		@cb;
		@cb;
                cb.count_enable<=0;
		@cb;
                @cb;
		@cb;
		@cb;
  		cb.clear <= 1;
		@cb;
		@cb;
		cb.count_enable<=1;
		@cb;
		@cb;
		@cb;
		@cb;
 		cb.clear<=0;
		@cb;
		@cb;
		@cb;
                cb.n_rst <= 1'b0;
                @cb;
		@cb;
		if (tb_expected_count_out == cb.count_out)
			$info("%s Case %0d:: PASSED Correct cound out value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED %d- incorrect count out value", NAME, tb_test_num, cb.count_out);

		if (tb_expected_rollover_flag == cb.rollover_flag)
			$info("%s Case %0d:: PASSED Correct rollover value", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED - incorrect rollover value", NAME, tb_test_num);
		// De-assert reset for a cycle
		cb.n_rst <= 1'b1;
		@cb;

    end
 /*
		
*/
endmodule
