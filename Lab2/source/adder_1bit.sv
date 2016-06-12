// $Id: $
// File name:   adder_1bit.sv
// Created:     1/27/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: A 1-bit adder for 2.1 postlab.
`timescale 1ns / 100ps

module adder_1bit
(
input wire a,
input wire b,
input wire carry_in,
//output reg sum,
//output reg carry_out
output wire sum,
output wire carry_out
); 

wire axb;
wire ncin;
wire aandb;
wire ncinaandb;
wire aorb;
wire cinandaorb;

xor X1 (axb, a, b);
xor X2 (sum, carry_in, axb);

not N1 (ncin, carry_in);
and A1 (aandb, a, b);
and A2 (ncinaandb, ncin, aandb);
or O1 (aorb, a, b);
and A3 (cinandaorb, carry_in, aorb);
or O2 (carry_out, ncinaandb, cinandaorb);

always @ (a)
begin
  assert((a == 1'b1) || (a == 1'b0))
  else $error("Input 'a' of component is not a digital logic value");
end

always @ (b)
begin
  assert((b == 1'b1) || (b == 1'b0))
  else $error("Input 'b' of component is not a digital logic value");
end

always @ (a, b, carry_in)
begin
  #(2) assert (((a + b + carry_in) % 2) == sum)
  else $error("Output 's' of first 1 bit adder is not correct");
end



//always_comb
// begin
//sum = carry_in ^ (a ^ b);
//carry_out = ((~carry_in) & b & a) | (carry_in & (b | a));
//end
endmodule