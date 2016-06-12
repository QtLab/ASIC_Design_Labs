// $Id: $
// File name:   flex_pts_sr
// Created:     2/3/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: parallel to serial outputtin..yes!.
// 

`timescale 1ns / 10ps
module flex_pts_sr
#(
parameter NUM_BITS = 4,
parameter SHIFT_MSB = 1
)
(
input wire clk,
input wire n_rst,
input wire shift_enable,
input wire load_enable,
input wire [NUM_BITS-1:0] parallel_in,
output wire serial_out
); 

reg out = 1'b1;
reg enable;

integer i;
reg [NUM_BITS-1:0] R;

always @ (posedge clk, negedge n_rst) begin
// ASYNCHRONOUS RESET
if (n_rst == 0) begin
    for (i=0; i < NUM_BITS; i=i+1) begin
        R[i] <= 1;
    end
end
// LOADING ENABLED
else if (load_enable == 1) begin
  R <= parallel_in;
end // end loading if

// SHIFTING ENABLED
else if (shift_enable == 1) begin
// INPUT -> MSB >>
    if (SHIFT_MSB==0) begin
        //out <= R[0];
        for (i=0; i < NUM_BITS-1; i=i+1) begin
            R[i] <= R[i+1];
        end
        R[NUM_BITS-1] <= n_rst;   
    end 
// INPUT -> LSB  <<
    else begin
        //out <= R[NUM_BITS-1];
        for (i=NUM_BITS-1; i > 0; i=i-1) begin
            R[i] <= R[i-1];
        end
        R[0] <= n_rst;
    end        
       
end // end shifting if

//else begin
 
//end

end // end always_FF

always_comb begin
  if (SHIFT_MSB==0) begin
  out = R[0]; 
  end
  else begin
  out = R[NUM_BITS-1];
  end
end 
assign serial_out = out;

//assign parallel_out = R;

endmodule