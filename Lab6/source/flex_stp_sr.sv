// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/2/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: serial to parallel shift register (flexible)
`timescale 1ns / 10ps
module flex_stp_sr
#(
parameter NUM_BITS = 8,
parameter SHIFT_MSB = 0
)
(
input wire clk,
input wire n_rst,
input wire shift_enable,
input wire serial_in,
output reg [NUM_BITS-1:0] parallel_out
); 


integer i;
reg [NUM_BITS-1:0] R;

always @ (posedge clk, negedge n_rst) begin
// ASYNCHRONOUS RESET
if (n_rst == 0) begin
    for (i=0; i < NUM_BITS; i=i+1) begin
        R[i] <= 1;
    end
end
// SHIFTING ENABLED
else if (shift_enable == 1) begin
// INPUT -> LSB
    if (SHIFT_MSB==0) begin
        for (i=0; i < NUM_BITS-1; i=i+1) begin
            R[i] <= R[i+1];
        end
        R[NUM_BITS-1] <= serial_in;   
    end 
// INPUT -> MSB
    else begin
        for (i=NUM_BITS-1; i > 0; i=i-1) begin
            R[i] <= R[i-1];
        end
        R[0] <= serial_in;
    end        
       
end // end large if

end // end always_FF
assign parallel_out = R;

endmodule
