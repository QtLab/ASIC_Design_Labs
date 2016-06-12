// $Id: $
// File name:   sync_low.sv
// Created:     1/27/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Reset to Logic Low Flip-flop synchronizer
`timescale 1ns/10ps
module sync
(
input wire clk,
input wire n_rst,
input wire async_in,
output reg sync_out
);
reg Intermediate;

always_ff @ (posedge clk, negedge n_rst)
begin //[: flipone]
 if(1'b0 == n_rst)
   begin
   Intermediate <= 0;
   end
 else
   begin
   Intermediate <= async_in;
   end
end

always_ff @ (posedge clk, negedge n_rst)
begin //[: fliptwo]
 if(1'b0 == n_rst)
  begin
  sync_out <= 0;
  end
 else
  begin
  sync_out <= Intermediate;
  end
end

endmodule
