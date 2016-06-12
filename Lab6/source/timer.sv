// $Id: $
// File name:   timer.sv
// Created:     2/29/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The timer for shift_enable and byte_received

module timer
(
  input wire clk,
  input wire n_rst,
  input wire d_edge,
  input wire rcving,
  output reg shift_enable,
  output wire byte_received
);

reg [3:0]count;
reg next_shift_enable;
flex_counter SHIFT(

		.clk(clk),
		.n_rst(n_rst),
		.rollover_val(4'd8),
		.clear(d_edge),
		.count_enable(rcving),
		.count_out(count)
		 );

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst==0) shift_enable <= 0;
  else          shift_enable <= next_shift_enable;
end

always_comb begin
 next_shift_enable = 0;
 if (count == 4'd2) next_shift_enable = 1;
end

flex_counter BYTE (
		.clk(clk),
		.n_rst(n_rst),
		.rollover_val(4'd8),
		.clear(~rcving),
		.count_enable(shift_enable),
		.rollover_flag(byte_received)
		 );

endmodule



