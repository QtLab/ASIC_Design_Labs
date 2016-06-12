// $Id: $
// File name:   rcu.sv
// Created:     2/29/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The Register control unit for the USB

module rcu 
(
  input wire clk,
  input wire n_rst,
  input wire d_edge,
  input wire eop,
  input wire shift_enable,
  input wire [7:0] rcv_data,
  input wire byte_received,
  output wire rcving,
  output wire w_enable,
  output wire r_error
);


typedef enum bit [3:0] { IDLE, SYNC_RECEIVE, SYNC_CHECK, BYTE_CHECK, RECEIVING, WRITE, DONE,
                         SYNC_ERR, SYNC_ERR2, EOP_ERR, EIDLE} stateType;

stateType state;
stateType next_state;
reg next_rcving;
reg next_w_enable;
reg next_r_error;
reg now_rcving;
reg now_w_enable;
reg now_r_error;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst ==0) begin
    state    <= IDLE;
    now_rcving   <= 0;
    now_r_error  <= 0;
    now_w_enable <= 0; 
  end 
  else begin
    state        <= next_state;
    now_rcving   <= next_rcving;
    now_r_error  <= next_r_error;
    now_w_enable <= next_w_enable;
  end
end //end ff

always_comb begin
  next_rcving   = 1;
  next_w_enable = 0;
  next_r_error  = 0;
  next_state = state;
  case(state)
    IDLE: begin
      if(d_edge) begin next_state = SYNC_RECEIVE;          end 
      else      begin next_rcving = 0;                    end
    end
    SYNC_RECEIVE: begin
      if (byte_received) begin next_state = SYNC_CHECK;   end
    end
    SYNC_CHECK: begin
      if (rcv_data ==  8'd128) begin next_state   = BYTE_CHECK; end // mactches-> goto bytecheck
      else                     begin next_state = SYNC_ERR; next_r_error = 1; end // set r_err
    end
    SYNC_ERR: begin
      next_r_error = 1;
      if (shift_enable) begin 
        if(eop) begin next_state = SYNC_ERR2; next_rcving = 0; end //if shift-eop -> syncErr2, rcv->0
      end 
    end
    SYNC_ERR2: begin
      next_r_error = 1;
      next_rcving = 0;
      if (d_edge) begin next_state = EIDLE; end
    end
    EIDLE: begin
      if (d_edge) begin next_state  = SYNC_RECEIVE;        end
      else       begin next_rcving = 0; next_r_error = 1; end
    end
    BYTE_CHECK: begin
      if (shift_enable) begin
        if (eop) begin next_state = DONE; next_rcving = 0; end
        else     begin next_state = RECEIVING;             end
      end
    end
    RECEIVING: begin
      if(shift_enable) begin
        if(eop) begin next_state = EOP_ERR; next_r_error = 1; end
      end
      if (byte_received) begin next_state = WRITE; next_w_enable = 1; end
    end
    EOP_ERR: begin
      next_r_error = 1; 
      if (d_edge) begin next_state = EIDLE; next_rcving = 0; end
    end
    WRITE:  begin next_state = BYTE_CHECK; end
    DONE: begin
      next_rcving = 0;
      if (d_edge) next_state = IDLE;
    end
  endcase
end
assign rcving   = now_rcving;
assign r_error  = now_r_error;
assign w_enable = now_w_enable;


endmodule
        