// $Id: $
// File name:   usb_receiver.sv
// Created:     2/29/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: USB RECEIVER top level sv

module usb_receiver
(
  input wire clk,
  input wire n_rst,
  input wire d_plus,
  input wire d_minus,
  input wire r_enable,
  output wire [7:0]r_data,
  output wire empty,
  output wire full,
  output wire rcving,
  output wire r_error
);

wire d_minus_sync, d_plus_sync, d_edge, eop, d_orig, shift_enable, byte_received, w_enable;
wire [7:0] rcv_data;

sync_high DPS(
 		.clk(clk),
		.n_rst(n_rst),
		.async_in(d_plus),
		.sync_out(d_plus_sync)
             );
sync_low DMS(
 		.clk(clk),
		.n_rst(n_rst),
		.async_in(d_minus),
		.sync_out(d_minus_sync)
             );

edge_detect ED (
		.clk(clk),
		.n_rst(n_rst),
		.d_plus(d_plus_sync),
		.d_edge(d_edge)
		);
eop_detect EOP (
		.d_plus(d_plus_sync),
		.d_minus(d_minus_sync),
		.eop(eop)
		);
decode DECODE  (
		.clk(clk),
		.n_rst(n_rst),
		.d_plus(d_plus_sync),
		.shift_enable(shift_enable),
		.eop(eop),
		.d_orig(d_orig)
		);
timer TIMER   (
		.clk(clk),
		.n_rst(n_rst),
		.d_edge(d_edge),
		.rcving(rcving),
		.shift_enable(shift_enable),
		.byte_received(byte_received)
		);
shift_register S(
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(shift_enable),
		.d_orig(d_orig),
		.rcv_data(rcv_data)
		);

rx_fifo     FIFO(
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(r_enable),
		.w_enable(w_enable),
		.w_data(rcv_data),
		.r_data(r_data),
		.empty(empty),
		.full(full)
		);
rcu      THERCU(
		.clk(clk),
		.n_rst(n_rst),
		.d_edge(d_edge),
		.eop(eop),
		.shift_enable(shift_enable),
		.rcv_data(rcv_data),
		.byte_received(byte_received),
		.rcving(rcving),
		.w_enable(w_enable),
		.r_error(r_error)
		);

endmodule
