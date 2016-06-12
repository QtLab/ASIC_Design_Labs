// $Id: $
// File name:   counter.sv
// Created:     2/16/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: This is the 1K flex counter for samples of data
`timescale 1ns/10ps
module counter
(
  input wire clk,
  input wire n_reset,
  input wire cnt_up,
  input wire clear,
  output wire one_k_samples
);

flex_counter OneKCount 
      (
       .clk(clk),
       .n_rst(n_reset),
       .count_enable(cnt_up),
       .clear(clear),
       .rollover_val(10'd1000),
       .rollover_flag(one_k_samples)
       );                
endmodule
