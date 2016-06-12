// $Id: $
// File name:   edge_detect.sv
// Created:     2/25/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: detector of edges
`timescale 1ns / 10ps
module edge_detect

(
  input wire clk,
  input wire n_rst,
  input wire d_plus,
  output wire d_edge
);

//reg dpss;
reg last_dps=1;
reg dpss=1;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst ==0) begin
    last_dps <= 1;
    dpss     <= 1;    
  end
  else begin
    last_dps <= dpss;
    dpss     <= d_plus;       
  end
end //end ff

xor(d_edge, dpss, last_dps);

endmodule


