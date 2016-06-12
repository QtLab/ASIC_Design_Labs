// $Id: $
// File name:   sensor_b.sv
// Created:     1/22/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Behavior type Sensor.

module sensor_b
(
input wire [3:0] sensors,
output reg error
);

reg and1;
reg and2;
reg or1;

always_comb
 begin
and1 = sensors[3] & sensors[1];
and2 = sensors[2] & sensors[1];
or1 = and1 | and2;
error = or1 | sensors[0];
end

endmodule