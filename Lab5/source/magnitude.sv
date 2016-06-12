// $Id: $
// File name:   magnitude.sv
// Created:     2/16/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: This block converts negative to positive twos compliment.
`timescale 1ns/10ps
module magnitude
(
  input wire [16:0] in,
  output wire [15:0] out
);
reg [15:0] temp;
always_comb begin
  if ( in[16] == 1 ) begin
    temp = ~in;
    temp = temp+1;
  end
  else begin
    temp = in;
  end
end
assign out = temp[15:0];
endmodule
