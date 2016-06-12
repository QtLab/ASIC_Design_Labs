/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Fri Feb 12 13:58:00 2016
/////////////////////////////////////////////////////////////


module stop_bit_chk ( clk, n_rst, sbc_clear, sbc_enable, stop_bit, 
        framing_error );
  input clk, n_rst, sbc_clear, sbc_enable, stop_bit;
  output framing_error;
  wire   n5, n2, n3;

  DFFSR framing_error_reg ( .D(n5), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        framing_error) );
  NOR2X1 U3 ( .A(sbc_clear), .B(n2), .Y(n5) );
  MUX2X1 U4 ( .B(framing_error), .A(n3), .S(sbc_enable), .Y(n2) );
  INVX1 U5 ( .A(stop_bit), .Y(n3) );
endmodule


module start_bit_det ( clk, n_rst, serial_in, start_bit_detected );
  input clk, n_rst, serial_in;
  output start_bit_detected;
  wire   old_sample, new_sample, sync_phase, n4;

  DFFSR sync_phase_reg ( .D(serial_in), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        sync_phase) );
  DFFSR new_sample_reg ( .D(sync_phase), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        new_sample) );
  DFFSR old_sample_reg ( .D(new_sample), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        old_sample) );
  NOR2X1 U6 ( .A(new_sample), .B(n4), .Y(start_bit_detected) );
  INVX1 U7 ( .A(old_sample), .Y(n4) );
endmodule


module flex_stp_sr_NUM_BITS9_SHIFT_MSB0 ( clk, n_rst, shift_enable, serial_in, 
        parallel_out );
  output [8:0] parallel_out;
  input clk, n_rst, shift_enable, serial_in;
  wire   n13, n15, n17, n19, n21, n23, n25, n27, n29, n1, n2, n3, n4, n5, n6,
         n7, n8, n9;

  DFFSR \R_reg[8]  ( .D(n29), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[8]) );
  DFFSR \R_reg[7]  ( .D(n27), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[7]) );
  DFFSR \R_reg[6]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[6]) );
  DFFSR \R_reg[5]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[5]) );
  DFFSR \R_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[4]) );
  DFFSR \R_reg[3]  ( .D(n19), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[3]) );
  DFFSR \R_reg[2]  ( .D(n17), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[2]) );
  DFFSR \R_reg[1]  ( .D(n15), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[1]) );
  DFFSR \R_reg[0]  ( .D(n13), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[0]) );
  INVX1 U2 ( .A(n1), .Y(n29) );
  MUX2X1 U3 ( .B(parallel_out[8]), .A(serial_in), .S(shift_enable), .Y(n1) );
  INVX1 U4 ( .A(n2), .Y(n27) );
  MUX2X1 U5 ( .B(parallel_out[7]), .A(parallel_out[8]), .S(shift_enable), .Y(
        n2) );
  INVX1 U6 ( .A(n3), .Y(n25) );
  MUX2X1 U7 ( .B(parallel_out[6]), .A(parallel_out[7]), .S(shift_enable), .Y(
        n3) );
  INVX1 U8 ( .A(n4), .Y(n23) );
  MUX2X1 U9 ( .B(parallel_out[5]), .A(parallel_out[6]), .S(shift_enable), .Y(
        n4) );
  INVX1 U10 ( .A(n5), .Y(n21) );
  MUX2X1 U11 ( .B(parallel_out[4]), .A(parallel_out[5]), .S(shift_enable), .Y(
        n5) );
  INVX1 U12 ( .A(n6), .Y(n19) );
  MUX2X1 U13 ( .B(parallel_out[3]), .A(parallel_out[4]), .S(shift_enable), .Y(
        n6) );
  INVX1 U14 ( .A(n7), .Y(n17) );
  MUX2X1 U15 ( .B(parallel_out[2]), .A(parallel_out[3]), .S(shift_enable), .Y(
        n7) );
  INVX1 U16 ( .A(n8), .Y(n15) );
  MUX2X1 U17 ( .B(parallel_out[1]), .A(parallel_out[2]), .S(shift_enable), .Y(
        n8) );
  INVX1 U18 ( .A(n9), .Y(n13) );
  MUX2X1 U19 ( .B(parallel_out[0]), .A(parallel_out[1]), .S(shift_enable), .Y(
        n9) );
endmodule


module sr_9bit ( clk, n_rst, shift_strobe, serial_in, packet_data, stop_bit );
  output [7:0] packet_data;
  input clk, n_rst, shift_strobe, serial_in;
  output stop_bit;


  flex_stp_sr_NUM_BITS9_SHIFT_MSB0 SHIFT ( .clk(clk), .n_rst(n_rst), 
        .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out({
        stop_bit, packet_data}) );
endmodule


module rcu ( clk, n_rst, start_bit_detected, packet_done, framing_error, 
        sbc_clear, sbc_enable, load_buffer, enable_timer );
  input clk, n_rst, start_bit_detected, packet_done, framing_error;
  output sbc_clear, sbc_enable, load_buffer, enable_timer;
  wire   n28, n29, n30, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14, n15, n16, n17, n18, n19;
  wire   [2:0] state;

  DFFPOSX1 \state_reg[0]  ( .D(n30), .CLK(clk), .Q(state[0]) );
  DFFPOSX1 \state_reg[1]  ( .D(n29), .CLK(clk), .Q(state[1]) );
  DFFPOSX1 \state_reg[2]  ( .D(n28), .CLK(clk), .Q(state[2]) );
  NOR2X1 U3 ( .A(n1), .B(n2), .Y(enable_timer) );
  NAND2X1 U4 ( .A(n3), .B(n4), .Y(n2) );
  NOR2X1 U5 ( .A(n4), .B(n5), .Y(load_buffer) );
  NAND2X1 U6 ( .A(state[0]), .B(n1), .Y(n5) );
  NAND2X1 U7 ( .A(n6), .B(n7), .Y(n30) );
  MUX2X1 U8 ( .B(n8), .A(n9), .S(n3), .Y(n6) );
  NOR2X1 U9 ( .A(state[2]), .B(n10), .Y(n9) );
  OAI21X1 U10 ( .A(n10), .B(n11), .C(n12), .Y(n29) );
  INVX1 U11 ( .A(sbc_clear), .Y(n11) );
  NOR2X1 U12 ( .A(n13), .B(state[1]), .Y(sbc_clear) );
  OAI21X1 U13 ( .A(n10), .B(n14), .C(n15), .Y(n28) );
  OAI21X1 U14 ( .A(n16), .B(n8), .C(state[2]), .Y(n15) );
  INVX1 U15 ( .A(n12), .Y(n8) );
  NAND3X1 U16 ( .A(state[1]), .B(n13), .C(n_rst), .Y(n12) );
  INVX1 U17 ( .A(n7), .Y(n16) );
  NAND3X1 U18 ( .A(n3), .B(n1), .C(n17), .Y(n7) );
  NOR2X1 U19 ( .A(framing_error), .B(n10), .Y(n17) );
  INVX1 U20 ( .A(sbc_enable), .Y(n14) );
  NOR2X1 U21 ( .A(n13), .B(n1), .Y(sbc_enable) );
  NAND2X1 U22 ( .A(state[0]), .B(n4), .Y(n13) );
  NAND2X1 U23 ( .A(n_rst), .B(n18), .Y(n10) );
  NAND3X1 U24 ( .A(n3), .B(n4), .C(n19), .Y(n18) );
  MUX2X1 U25 ( .B(packet_done), .A(start_bit_detected), .S(n1), .Y(n19) );
  INVX1 U26 ( .A(state[1]), .Y(n1) );
  INVX1 U27 ( .A(state[2]), .Y(n4) );
  INVX1 U28 ( .A(state[0]), .Y(n3) );
endmodule


module flex_counter_1 ( clk, n_rst, clear, count_enable, rollover_val, 
        rollover_flag );
  input [3:0] rollover_val;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   n29, N10, n2, n3, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n26, n27, n28;
  wire   [3:0] count;
  wire   [3:0] next_count;

  DFFSR \count_reg[0]  ( .D(next_count[0]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[0]) );
  DFFSR rollover_flag_reg ( .D(N10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(n29)
         );
  DFFSR \count_reg[1]  ( .D(next_count[1]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[1]) );
  DFFSR \count_reg[2]  ( .D(next_count[2]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[2]) );
  DFFSR \count_reg[3]  ( .D(next_count[3]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[3]) );
  BUFX2 U8 ( .A(n29), .Y(rollover_flag) );
  NOR2X1 U9 ( .A(n2), .B(n3), .Y(N10) );
  NAND2X1 U10 ( .A(n9), .B(n10), .Y(n3) );
  XNOR2X1 U11 ( .A(rollover_val[1]), .B(next_count[1]), .Y(n10) );
  OAI22X1 U12 ( .A(n11), .B(n12), .C(n13), .D(n14), .Y(next_count[1]) );
  XNOR2X1 U13 ( .A(n15), .B(n16), .Y(n13) );
  XNOR2X1 U14 ( .A(rollover_val[2]), .B(next_count[2]), .Y(n9) );
  OAI22X1 U15 ( .A(n11), .B(n17), .C(n18), .D(n14), .Y(next_count[2]) );
  XNOR2X1 U16 ( .A(n19), .B(n20), .Y(n18) );
  NAND2X1 U17 ( .A(n21), .B(n22), .Y(n2) );
  XNOR2X1 U18 ( .A(rollover_val[0]), .B(next_count[0]), .Y(n22) );
  OAI22X1 U19 ( .A(n16), .B(n14), .C(n11), .D(n23), .Y(next_count[0]) );
  XNOR2X1 U20 ( .A(rollover_val[3]), .B(next_count[3]), .Y(n21) );
  OAI22X1 U21 ( .A(n24), .B(n14), .C(n11), .D(n25), .Y(next_count[3]) );
  OR2X1 U22 ( .A(clear), .B(count_enable), .Y(n11) );
  NAND2X1 U23 ( .A(count_enable), .B(n26), .Y(n14) );
  INVX1 U24 ( .A(clear), .Y(n26) );
  XOR2X1 U25 ( .A(n27), .B(n28), .Y(n24) );
  NOR2X1 U26 ( .A(n20), .B(n19), .Y(n28) );
  NAND2X1 U27 ( .A(n16), .B(n15), .Y(n19) );
  NOR2X1 U28 ( .A(n12), .B(rollover_flag), .Y(n15) );
  INVX1 U29 ( .A(count[1]), .Y(n12) );
  NOR2X1 U30 ( .A(n23), .B(rollover_flag), .Y(n16) );
  INVX1 U31 ( .A(count[0]), .Y(n23) );
  OR2X1 U32 ( .A(n17), .B(rollover_flag), .Y(n20) );
  INVX1 U33 ( .A(count[2]), .Y(n17) );
  OR2X1 U34 ( .A(n25), .B(rollover_flag), .Y(n27) );
  INVX1 U35 ( .A(count[3]), .Y(n25) );
endmodule


module flex_counter_0 ( clk, n_rst, clear, count_enable, rollover_val, 
        rollover_flag );
  input [3:0] rollover_val;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   N10, n1, n2, n3, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27;
  wire   [3:0] count;
  wire   [3:0] next_count;

  DFFSR \count_reg[0]  ( .D(next_count[0]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[0]) );
  DFFSR rollover_flag_reg ( .D(N10), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  DFFSR \count_reg[1]  ( .D(next_count[1]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[1]) );
  DFFSR \count_reg[2]  ( .D(next_count[2]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[2]) );
  DFFSR \count_reg[3]  ( .D(next_count[3]), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(count[3]) );
  NOR2X1 U8 ( .A(n1), .B(n2), .Y(N10) );
  NAND2X1 U9 ( .A(n3), .B(n9), .Y(n2) );
  XNOR2X1 U10 ( .A(rollover_val[1]), .B(next_count[1]), .Y(n9) );
  OAI22X1 U11 ( .A(n10), .B(n11), .C(n12), .D(n13), .Y(next_count[1]) );
  XNOR2X1 U12 ( .A(n14), .B(n15), .Y(n12) );
  XNOR2X1 U13 ( .A(rollover_val[2]), .B(next_count[2]), .Y(n3) );
  OAI22X1 U14 ( .A(n10), .B(n16), .C(n17), .D(n13), .Y(next_count[2]) );
  XNOR2X1 U15 ( .A(n18), .B(n19), .Y(n17) );
  NAND2X1 U16 ( .A(n20), .B(n21), .Y(n1) );
  XNOR2X1 U17 ( .A(rollover_val[0]), .B(next_count[0]), .Y(n21) );
  OAI22X1 U18 ( .A(n15), .B(n13), .C(n10), .D(n22), .Y(next_count[0]) );
  XNOR2X1 U19 ( .A(rollover_val[3]), .B(next_count[3]), .Y(n20) );
  OAI22X1 U20 ( .A(n23), .B(n13), .C(n10), .D(n24), .Y(next_count[3]) );
  OR2X1 U21 ( .A(clear), .B(count_enable), .Y(n10) );
  NAND2X1 U22 ( .A(count_enable), .B(n25), .Y(n13) );
  INVX1 U23 ( .A(clear), .Y(n25) );
  XOR2X1 U24 ( .A(n26), .B(n27), .Y(n23) );
  NOR2X1 U25 ( .A(n19), .B(n18), .Y(n27) );
  NAND2X1 U26 ( .A(n15), .B(n14), .Y(n18) );
  NOR2X1 U27 ( .A(n11), .B(rollover_flag), .Y(n14) );
  INVX1 U28 ( .A(count[1]), .Y(n11) );
  NOR2X1 U29 ( .A(n22), .B(rollover_flag), .Y(n15) );
  INVX1 U30 ( .A(count[0]), .Y(n22) );
  OR2X1 U31 ( .A(n16), .B(rollover_flag), .Y(n19) );
  INVX1 U32 ( .A(count[2]), .Y(n16) );
  OR2X1 U33 ( .A(n24), .B(rollover_flag), .Y(n26) );
  INVX1 U34 ( .A(count[3]), .Y(n24) );
endmodule


module timer ( clk, n_rst, enable_timer, shift_strobe, packet_done );
  input clk, n_rst, enable_timer;
  output shift_strobe, packet_done;


  flex_counter_1 TENCOUNT ( .clk(clk), .n_rst(n_rst), .clear(packet_done), 
        .count_enable(enable_timer), .rollover_val({1'b1, 1'b0, 1'b1, 1'b0}), 
        .rollover_flag(shift_strobe) );
  flex_counter_0 NINECOUNT ( .clk(clk), .n_rst(n_rst), .clear(packet_done), 
        .count_enable(shift_strobe), .rollover_val({1'b1, 1'b0, 1'b0, 1'b1}), 
        .rollover_flag(packet_done) );
endmodule


module rx_data_buff ( clk, n_rst, load_buffer, packet_data, data_read, rx_data, 
        data_ready, overrun_error );
  input [7:0] packet_data;
  output [7:0] rx_data;
  input clk, n_rst, load_buffer, data_read;
  output data_ready, overrun_error;
  wire   n30, n31, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n15, n17, n19,
         n21, n23, n25, n27, n29;

  DFFSR \rx_data_reg[7]  ( .D(n15), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[7]) );
  DFFSR \rx_data_reg[6]  ( .D(n17), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[6]) );
  DFFSR \rx_data_reg[5]  ( .D(n19), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[5]) );
  DFFSR \rx_data_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[4]) );
  DFFSR \rx_data_reg[3]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[3]) );
  DFFSR \rx_data_reg[2]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[2]) );
  DFFSR \rx_data_reg[1]  ( .D(n27), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[1]) );
  DFFSR \rx_data_reg[0]  ( .D(n29), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[0]) );
  DFFSR data_ready_reg ( .D(n31), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        data_ready) );
  DFFSR overrun_error_reg ( .D(n30), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        overrun_error) );
  INVX1 U3 ( .A(n1), .Y(n15) );
  MUX2X1 U4 ( .B(rx_data[7]), .A(packet_data[7]), .S(load_buffer), .Y(n1) );
  INVX1 U5 ( .A(n2), .Y(n17) );
  MUX2X1 U6 ( .B(rx_data[6]), .A(packet_data[6]), .S(load_buffer), .Y(n2) );
  INVX1 U7 ( .A(n3), .Y(n19) );
  MUX2X1 U8 ( .B(rx_data[5]), .A(packet_data[5]), .S(load_buffer), .Y(n3) );
  INVX1 U9 ( .A(n4), .Y(n21) );
  MUX2X1 U10 ( .B(rx_data[4]), .A(packet_data[4]), .S(load_buffer), .Y(n4) );
  INVX1 U11 ( .A(n5), .Y(n23) );
  MUX2X1 U12 ( .B(rx_data[3]), .A(packet_data[3]), .S(load_buffer), .Y(n5) );
  INVX1 U13 ( .A(n6), .Y(n25) );
  MUX2X1 U14 ( .B(rx_data[2]), .A(packet_data[2]), .S(load_buffer), .Y(n6) );
  INVX1 U15 ( .A(n7), .Y(n27) );
  MUX2X1 U16 ( .B(rx_data[1]), .A(packet_data[1]), .S(load_buffer), .Y(n7) );
  INVX1 U17 ( .A(n8), .Y(n29) );
  MUX2X1 U18 ( .B(rx_data[0]), .A(packet_data[0]), .S(load_buffer), .Y(n8) );
  OAI21X1 U19 ( .A(data_read), .B(n9), .C(n10), .Y(n31) );
  INVX1 U20 ( .A(load_buffer), .Y(n10) );
  INVX1 U21 ( .A(data_ready), .Y(n9) );
  NOR2X1 U22 ( .A(data_read), .B(n11), .Y(n30) );
  AOI21X1 U23 ( .A(data_ready), .B(load_buffer), .C(overrun_error), .Y(n11) );
endmodule


module rcv_block ( clk, n_rst, serial_in, data_read, rx_data, data_ready, 
        overrun_error, framing_error );
  output [7:0] rx_data;
  input clk, n_rst, serial_in, data_read;
  output data_ready, overrun_error, framing_error;
  wire   sbc_clear, sbc_enable, stop_bit, start_bit_detected, shift_strobe,
         packet_done, load_buffer, enable_timer;
  wire   [7:0] packet_data;

  stop_bit_chk SBC ( .clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), 
        .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(
        framing_error) );
  start_bit_det SBT ( .clk(clk), .n_rst(n_rst), .serial_in(serial_in), 
        .start_bit_detected(start_bit_detected) );
  sr_9bit s9 ( .clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), 
        .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit)
         );
  rcu RCU ( .clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), 
        .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(
        sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), 
        .enable_timer(enable_timer) );
  timer TIM ( .clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), 
        .shift_strobe(shift_strobe), .packet_done(packet_done) );
  rx_data_buff RX ( .clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), 
        .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), 
        .data_ready(data_ready), .overrun_error(overrun_error) );
endmodule

