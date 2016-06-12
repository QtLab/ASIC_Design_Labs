// $Id: $
// File name:   decode.sv
// Created:     2/25/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: decoder for nrz
// ,.

module decode

(
  input wire clk,
  input wire n_rst,
  input wire d_plus,
  input wire shift_enable,
  input wire eop,
  output wire d_orig
);
/*
reg dps, previous_dps, next_data, mux;
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst ==0) begin
    previous_dps <= 1'b1;
    dps          <= 1'b1;
  end
  else begin
    dps          <= next_data;
    previous_dps <= mux;
  end
end //end ff
always_comb begin
  if (shift_enable) begin
    if (eop) begin
      mux = 1'b1; next_data = 1'b1;
    end
    else begin mux = d_plus;   next_data = ~( previous_dps ^ data_plus); end
  else   next_data = ~( previous_dps ^ data_plus);
  
  end

end
assign d_orig = dps;
*/
reg dps;
reg previous_dps;
reg mux;
reg next_data;
// REGISTERS
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst ==0) begin
    previous_dps <= 1'b1;
    dps          <= 1'b1;
  end
  else begin
    dps          <= next_data;
    previous_dps <= mux;
  end
end //end ff
// NEXT_STATE LOGIC

always_comb begin
  mux = previous_dps;
  next_data = d_plus;
  if (shift_enable) begin
    if (eop) begin mux = 1'b1; next_data = 1; end
    else           mux = d_plus; 
  end
end //end always

//OUTPUT LOGIC
assign d_orig = ~( previous_dps ^ dps);

endmodule
