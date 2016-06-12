// $Id: $
// File name:   eop_detect.sv
// Created:     2/25/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: End of packet asynchronous signal
`timescale 1ns / 100ps
module eop_detect
(
  input wire d_plus,
  input wire d_minus,
  output wire eop
);

assign eop = ~(d_plus|d_minus);

endmodule
