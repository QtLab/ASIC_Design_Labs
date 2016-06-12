// $Id: $
// File name:   tb_rx_fifo.sv
// Created:     2/25/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: the tb for the fifo,, goodluck!
`timescale 1ns / 10ps
module tb_rx_fifo();

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
        reg tb_r_enable;
        reg tb_w_enable;
        reg [7:0] tb_w_data;
	reg [7:0] tb_r_data;
        reg tb_empty;
	reg tb_full;
	reg [7:0] tb_expected_r_data;
        reg tb_expected_empty;
	reg tb_expected_full;


	generate
	// DUT portmaps
		rx_fifo DUT
		(
	 .n_rst(tb_n_rst),
         .r_enable(tb_r_enable),
         .w_enable(tb_w_enable),
         .w_data(tb_w_data),
	 .r_data(tb_r_data),
         .empty(tb_empty),
	 .full(tb_full)
		);
	endgenerate
	
	clocking cb @(posedge tb_clk);
 		// 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
		default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
		output #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
		output r_enable = tb_r_enable;
                output w_enable = tb_w_enable;
		output w_data   = tb_w_data;
		output r_data   = tb_r_data;                       
		input empty = tb_empty;
		input full = tb_full;
	endclocking



endmodule

