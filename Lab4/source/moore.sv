// $Id: $
// File name:   moore.sv
// Created:     2/5/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Moore sensor 1101 design.
`timescale 1ns / 10ps
module moore
(
  input wire clk,
  input wire n_rst,
  input wire i,
  output reg o
);

typedef enum bit [2:0] {STATE_011, STATE_000, STATE_001, STATE_101, STATE_110} stateType;
stateType state;
stateType next_state;


// STATE REGISTER SETTINGS
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 0) begin
    state <= STATE_000;
  end
  else begin
    state <= next_state;
  end
end
// NEXT STATE LOGIC
always_comb begin
  next_state = state;
  case (state)
 // STATE_000
    STATE_000: begin
      if ( i == 1 ) begin
        next_state = STATE_001;
      end
      else begin
        next_state = STATE_000;
      end
    end
 // STATE_001
    STATE_001: begin
      if ( i == 1 ) begin
        next_state = STATE_011;
      end
      else begin
        next_state = STATE_000;
      end
    end
 // STATE_011
    STATE_011: begin
      if ( i == 1 ) begin
        next_state = STATE_011;
      end
      else begin
        next_state = STATE_110;
      end
    end
 // STATE_110
    STATE_110: begin
      if ( i == 1 ) begin
        next_state = STATE_101;
      end
      else begin
        next_state = STATE_000;
      end
    end
 // STATE_101 (DETECTION state)
    STATE_101: begin
      if ( i == 1 ) begin
        next_state = STATE_011;
      end
      else begin
        next_state = STATE_000;
      end
    end
  endcase
end // end always_comb

// OUTPUT LOGIC
always_comb begin
  if ( state == STATE_101) begin
    o = 1;
  end
  else begin
    o = 0;
  end
end //end always_comb output




  
endmodule