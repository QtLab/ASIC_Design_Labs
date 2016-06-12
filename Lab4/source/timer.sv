// $Id: $
// File name:   timer.sv
// Created:     2/10/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The timing block for the UART LAB4.
// ./
`timescale 1ns / 10ps
module timer
(
  input wire clk,
  input wire n_rst,
  input wire enable_timer,
  output reg shift_strobe,
  output reg packet_done
);

wire [3:0] ten; wire [3:0] nine;
assign ten = 4'd10; assign nine = 4'd9;

flex_counter TENCOUNT (
              .clk(clk),
              .n_rst(n_rst), 
              .clear(packet_done),
              .count_enable(enable_timer),
              .rollover_val(ten),//(4'd10),
              .rollover_flag(shift_strobe)
             ); 
flex_counter NINECOUNT (
              .clk(clk), 
              .n_rst(n_rst), 
              .clear(packet_done),
              .count_enable(shift_strobe),
              .rollover_val(nine),//(4'd9),
              .rollover_flag(packet_done)
             );
endmodule
