module sra (
  input       [31:0] rs1_data,
  input       [31:0] rs2_data,
  input              br_unsign,
  output wire [31:0] rd_data
);
//chi dich 5 bit thap nhat cua rs2_data
//dich phai msb extend
  wire [31:0] rd_data_unsign, rd_data_sign;
  wire [31:0] s0, s1, s2, s3, s4, s5, s6, s7, s8;
  // dich phai voi msb = 0
  assign s0             = rs2_data[0] ? {1'b0, rs1_data[31:1]} : rs1_data; //dich phai 1 bit hoac 0 dich
  assign s1             = rs2_data[1] ? {2'b0,       s0[31:2]} : s0;       //dich phai 2 bit hoac 0 dich
  assign s2             = rs2_data[2] ? {4'b0,       s1[31:4]} : s1;       //dich phai 4 bit hoac 0 dich
  assign s3             = rs2_data[3] ? {8'b0,       s2[31:8]} : s2;       //dich phai 8 bit hoac 0 dich
  assign rd_data_unsign = rs2_data[4] ? {16'b0,     s3[31:16]} : s3;       //dich phai 16 bit hoac 0 dich
  // dich phai voi msb = 1
  assign s5           = rs2_data[0] ? {rs1_data[31],      rs1_data[31:1]} : rs1_data;
  assign s6           = rs2_data[1] ? {{2{rs1_data[31]}},       s5[31:2]} : s5;
  assign s7           = rs2_data[2] ? {{4{rs1_data[31]}},       s6[31:4]} : s6;
  assign s8           = rs2_data[3] ? {{8{rs1_data[31]}},       s7[31:8]} : s7;
  assign rd_data_sign = rs2_data[4] ? {{16{rs1_data[31]}},     s8[31:16]} : s8;

  assign rd_data = br_unsign ? rd_data_unsign : rd_data_sign;
endmodule
