// $Id: $
// File name:   sensor_s.sv
// Created:     1/22/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: A verilog structural code for sensor detector

module sensor_s
(
 input wire [3:0] sensors,
 output wire error

);
wire int_3and1;
wire int_2and1;
wire largeor;

and A1 (int_3and1, sensors[3], sensors[1]);
and A2 (int_2and1, sensors[2], sensors[1]);
or O1 (largeor, int_3and1, int_2and1);
or O2 (error, largeor, sensors[0]);


endmodule