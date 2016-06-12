// $Id: $
// File name:   controller.sv
// Created:     2/16/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The controller moore machine for the Filter.
`timescale 1ns/10ps
module controller
(
  input wire clk,
  input wire n_reset,
  input wire dr,
  input wire lc,
  input wire overflow,
  output reg cnt_up,
  output reg clear,
  output wire modwait,
  output reg [2:0] op,
  output reg [3:0] src1,
  output reg [3:0] src2,
  output reg [3:0] dest,
  output reg err
);
// ERR in a flip-flop????

typedef enum bit [4:0] { IDLE, LC0, CLR0, LC1, CLR1, LC2, CLR2, LC3, CLR3,STORE, ZERO, SORT1, SORT2, SORT3, SORT4, MUL1, ADD1, MUL2, SUB1, MUL3, ADD2, MUL4, SUB2, EIDLE} stateType;
stateType state;
stateType next_state;

reg next_modwait = 0;
reg now_modwait = 0;
reg next_err = 0;
// REGISTERS
always_ff @ (posedge clk, negedge n_reset) begin
  if (n_reset ==0) begin
    now_modwait <= 0;
    state       <= IDLE;
    err         <= 0;
  end
  else begin
    now_modwait <= next_modwait;
    state       <= next_state;
    err         <= next_err;
  end
end // end always_ff

// COMB LOGIC
always_comb begin
  next_state   = state;
  next_modwait = 1;
  next_err     = err;
  op           = 0;
  clear        = 0;
  cnt_up       = 0;
  src1         = 0;
  src2         = 0;
  dest         = 0;
// NEXT STATE LOGIC
  case(state)
  LC0:   begin
    clear = 1;
    dest  = 4'd9;
    op    = 3'd3; // reg9 = F0
    next_state = CLR0;
  end
  CLR0:  if(lc)next_state = LC1;
  LC1:   begin
    dest  = 4'd8;
    op    = 3'd3; // reg8 = F1
    next_state = CLR1;
  end
  CLR1:  if(lc) next_state = LC2;
  LC2:   begin
    dest  = 4'd7;
    op    = 3'd3; // reg7 = F2
    next_state = CLR2;
  end
  CLR2:  if(lc) next_state = LC3;
  LC3:   begin
    dest  = 4'd6;
    op    = 3'd3; // reg6 = F3
    next_state = IDLE;
  end

  IDLE:  begin
    if (lc)      begin next_state = LC0; end
    else if (dr) begin next_state = STORE; end      
  end

  EIDLE: begin
    if (dr) next_state = STORE;
    else    next_state = EIDLE;
  end


  STORE: begin
    if (dr) begin         next_state = ZERO; end
    else    begin         next_state = EIDLE; end
    dest  = 4'd5;
    op    = 3'd2; // load sample
  end

  ZERO:  begin
    next_state = SORT1;
    dest   = 4'd0;
    src1   = 4'd0;
    src2   = 4'd0;
    op     = 3'd5; // reg0=reg0-reg0
    cnt_up = 1;
  end

  SORT1: begin
    next_state = SORT2;
    dest = 4'd1;
    src1 = 4'd2;
    op   = 3'd1; // reg1=reg2
  end

  SORT2: begin
    next_state = SORT3;
    dest = 4'd2;
    src1 = 4'd3;
    op   = 3'd1; // reg2=reg3
  end

  SORT3: begin
    next_state = SORT4;
    dest = 4'd3;
    src1 = 4'd4;
    op   = 3'd1; // reg3=reg4
  end

  SORT4: begin
    next_state = MUL1;
    dest = 4'd4;
    src1 = 4'd5;
    op   = 3'd1; // reg4=reg5
  end

  MUL1:  begin
    dest = 4'd10;
    src1 = 4'd1;
    src2 = 4'd6;
    op   = 3'd6; // reg10 = reg1 * reg6
    if (overflow) next_state = EIDLE;
    else          next_state = ADD1;
  end

  ADD1:  begin
    dest = 4'd0;
    src1 = 4'd0;
    src2 = 4'd10;
    op   = 3'd4; // reg0 = reg0 + reg10  
    if (overflow) next_state = EIDLE;
    else          next_state = MUL2;
  end  

  MUL2:  begin
    dest = 4'd11;
    src1 = 4'd2;
    src2 = 4'd7;
    op   = 3'd6; // reg11 = reg2 * reg7
    if (overflow) next_state = EIDLE;
    else          next_state = SUB1; 
  end

  SUB1:  begin
    dest = 4'd0;
    src1 = 4'd0;
    src2 = 4'd11;
    op   = 3'd5; // reg0 = reg0 - reg11  
    if (overflow) next_state = EIDLE;
    else          next_state = MUL3;
  end  

  MUL3:  begin
    dest = 4'd12;
    src1 = 4'd3;
    src2 = 4'd8;
    op   = 3'd6; // reg12 = reg3 * reg8
    if (overflow) next_state = EIDLE;
    else          next_state = ADD2;
  end

  ADD2:  begin
    dest = 4'd0;
    src1 = 4'd0;
    src2 = 4'd12;
    op   = 3'd4; // reg0 = reg0 + reg12  
    if (overflow) next_state = EIDLE;
    else          next_state = MUL4;
  end  

  MUL4:  begin
    dest = 4'd13;
    src1 = 4'd4;
    src2 = 4'd9;
    op   = 3'd6; // reg13 = reg4 * reg9
    if (overflow) next_state = EIDLE;
    else          next_state = SUB2;
  end

  SUB2:  begin
    dest = 4'd0;
    src1 = 4'd0;
    src2 = 4'd13;
    op   = 3'd5; // reg0 = reg0 - reg13  
    if (overflow) next_state = EIDLE;
    else          next_state = IDLE;
  end  
  endcase


// MODWAIT + ERR LOGIC
  case(next_state)
    IDLE:        next_modwait = 0;
    CLR0:        next_modwait = 0;
    CLR1:        next_modwait = 0;
    CLR2:        next_modwait = 0;
//    CLR3:        next_modwait = 0;
    EIDLE: begin next_modwait = 0; next_err = 1; end
    STORE:                         next_err = 0;
  endcase



end //END ALWAYS_COMB

assign modwait = now_modwait;


endmodule
