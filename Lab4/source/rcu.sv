// $Id: $
// File name:   rcu.sv
// Created:     2/11/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: This is the Register control UNIT #state machine!.
`timescale 1ns / 10ps

module rcu
(
  input wire clk,
  input wire n_rst,
  input wire start_bit_detected,
  input wire packet_done,
  input wire framing_error,
  output reg sbc_clear,
  output reg sbc_enable,
  output reg load_buffer,
  output reg enable_timer
);
typedef enum bit [2:0] {IDLE, START, PACK, STOP, FRAME, STORE} stateType;
stateType state;
stateType next_state;

always_ff @ (posedge clk) begin
  if (n_rst ==0)
    state <= IDLE;
  else
    state <= next_state;    
end // done with always_ff

always_comb begin
  next_state   = state;
  sbc_clear    = 0;
  sbc_enable   = 0;
  enable_timer = 0;
  load_buffer  = 0;

  case(state)
///////////////////
    IDLE: begin
      if (start_bit_detected)
        next_state = START;
    end  
///////////////////
    START: begin
      sbc_clear  = 1;
      next_state = PACK;
    end
//////////////////
    PACK: begin
      sbc_clear    = 0;
      enable_timer = 1;
      if (packet_done)
        next_state = STOP;
    end
///////////////////
    STOP: begin
      enable_timer = 0;
      sbc_enable   = 1;
      next_state   = FRAME;
    end
///////////////////
    FRAME: begin
      sbc_enable   = 0;
      if (framing_error)
        next_state = IDLE;
      else 
        next_state = STORE;
    end
///////////////////
    STORE: begin
      load_buffer = 1;
      next_state  = IDLE; 
    end
  endcase
end //always

endmodule

