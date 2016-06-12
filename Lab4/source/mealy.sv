// $Id: $
// File name:   mealy.sv
// Created:     2/8/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Mealy FSM for 1101 detection!.
`timescale 1ns / 10ps
module mealy
(
  input wire clk,
  input wire n_rst,
  input wire i,
  output reg o = 0
);
//reg next_o;
typedef enum bit [1:0] {STATE_11, STATE_00, STATE_01, STATE_10} stateType;
stateType state;
stateType next_state;

// STATE REGISTER SETTINGS
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 0)
    state <= STATE_00;
  else
    state <= next_state;
end 
// NEXT STATE LOGIC
always_comb begin
  next_state = state;
  case (state)
    STATE_00: begin
      if ( i == 1 )
        next_state = STATE_01;
    end
    STATE_01: begin
      if ( i == 1 )
        next_state = STATE_11;
      else
        next_state = STATE_00;
    end
    STATE_11: begin
      if ( i == 0 )
        next_state = STATE_10;
    end
    STATE_10: begin // PRE-DETECTION
      if ( i == 1 )
        next_state = STATE_01;
      else 
        next_state = STATE_00;
    end
  endcase // end next_state case structure
end //end always_comb output

always_comb begin
  o = 0;
  if (state == STATE_10) begin
    if (i == 1)
      o = 1;
  end
end

 
endmodule
