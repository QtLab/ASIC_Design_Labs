// $Id: $
// File name:   fir_filter.sv
// Created:     2/16/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The Top level module for the FIR filter
`timescale 1ns/10ps
module fir_filter
(
  input wire clk,
  input wire n_reset,
  input wire [15:0] sample_data,
  input wire [15:0] fir_coefficient,
  input wire data_ready,
  input wire load_coeff,
  output wire one_k_samples,
  output wire modwait,
  output wire [15:0] fir_out,
  output wire err
);

wire dr, lc, clear, overflow, out, cnt_up;
wire [3:0] src1, src2, dest;
wire [2:0] op;
wire [16:0] in;
// controller
// magnitude
// counter
// datapath

sync DRSYNC (
                .clk(clk),
                .n_rst(n_reset),
                .async_in(data_ready),
                .sync_out(dr)
                );
sync LCSYNC (
                .clk(clk),
                .n_rst(n_reset),
                .async_in(load_coeff),
                .sync_out(lc)
                );

counter COUNTER (
                 .clk(clk),
                 .n_reset(n_reset),
                 .cnt_up(cnt_up),
                 .clear(clear),
                 .one_k_samples(one_k_samples)
                );

datapath DATAPATH (
		  .clk(clk),
		  .n_reset(n_reset),
                  .op(op),
                  .src1(src1),
                  .src2(src2),
                  .dest(dest),
                  .ext_data1(sample_data),
                  .ext_data2(fir_coefficient),
                  .outreg_data(in),
                  .overflow(overflow)
                  );
magnitude MAG (
                 .in(in),
                 .out(fir_out)
              );

controller CONTROLLER (
                      .clk(clk),
                      .n_reset(n_reset),
                      .dr(dr),
		      .lc(lc),
		      .overflow(overflow),
                      .cnt_up(cnt_up),
                      .clear(clear),
                      .modwait(modwait),
                      .op(op),
                      .src1(src1),
                      .src2(src2),
                      .dest(dest),
                      .err(err)
                      );


endmodule
