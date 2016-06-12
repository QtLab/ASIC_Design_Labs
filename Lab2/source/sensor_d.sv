// $Id: $
// File name:   sensor_d.sv
// Created:     1/22/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Dataflow Sensor

module sensor_d
(
input wire [3:0] sensors,
output wire error
);
wire A1;
wire A2;
wire O1;

assign A1 = sensors[3] & sensors[1];
assign A2 = sensors[2] & sensors[1];
assign O1 = A1 | A2;
assign error = O1 | sensors[0];

endmodule