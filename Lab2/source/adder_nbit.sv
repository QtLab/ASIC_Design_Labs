// $Id: $
// File name:   adder_nbit.sv
// Created:     1/27/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Nbit adder.

`timescale 1ns / 100ps

module adder_nbit
#(
parameter BIT_WIDTH = 4
)
(
input wire[(BIT_WIDTH-1):0] a,
input wire[(BIT_WIDTH-1):0] b,
input wire carry_in,
output wire[(BIT_WIDTH-1):0] sum,
output wire overflow
);
wire [(BIT_WIDTH):0] carrys;
genvar i;

assign carrys[0] = carry_in;
generate
for(i=0; i <=(BIT_WIDTH-1); i=i+1)
begin 
adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), 
            .sum(sum[i]), .carry_out(carrys[i+1])  );
end
endgenerate
assign overflow = carrys[BIT_WIDTH];


generate
for(i=0; i <=(BIT_WIDTH-1); i=i+1)
begin
  always @ (a[i])
  begin
    assert((a[i] == 1'b1) || (a[i] == 1'b0))
    else $error("Input 'a' of component is not a digital logic value");
  end

  always @ (b[i])
  begin
    assert((b[i] == 1'b1) || (b[i] == 1'b0))
    else $error("Input 'b' of component is not a digital logic value");
  end
end
endgenerate






endmodule