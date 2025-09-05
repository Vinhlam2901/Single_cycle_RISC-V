module and_32bit (
  input       [31:0] rs1_i,
  input       [31:0] rs2_i,
  output wire [31:0] rd_o
);
    assign rd_o[0]  = rs1_i[0]  & rs2_i[0];
    assign rd_o[1]  = rs1_i[1]  & rs2_i[1];
    assign rd_o[2]  = rs1_i[2]  & rs2_i[2];
    assign rd_o[3]  = rs1_i[3]  & rs2_i[3];
    assign rd_o[4]  = rs1_i[4]  & rs2_i[4];
    assign rd_o[5]  = rs1_i[5]  & rs2_i[5];
    assign rd_o[6]  = rs1_i[6]  & rs2_i[6];
    assign rd_o[7]  = rs1_i[7]  & rs2_i[7];
    assign rd_o[8]  = rs1_i[8]  & rs2_i[8];
    assign rd_o[9]  = rs1_i[9]  & rs2_i[9];
    assign rd_o[10] = rs1_i[10] & rs2_i[10];
    assign rd_o[11] = rs1_i[11] & rs2_i[11];
    assign rd_o[12] = rs1_i[12] & rs2_i[12];
    assign rd_o[13] = rs1_i[13] & rs2_i[13];
    assign rd_o[14] = rs1_i[14] & rs2_i[14];
    assign rd_o[15] = rs1_i[15] & rs2_i[15];
    assign rd_o[16] = rs1_i[16] & rs2_i[16];
    assign rd_o[17] = rs1_i[17] & rs2_i[17];
    assign rd_o[18] = rs1_i[18] & rs2_i[18];
    assign rd_o[19] = rs1_i[19] & rs2_i[19];
    assign rd_o[20] = rs1_i[20] & rs2_i[20];
    assign rd_o[21] = rs1_i[21] & rs2_i[21];
    assign rd_o[22] = rs1_i[22] & rs2_i[22];
    assign rd_o[23] = rs1_i[23] & rs2_i[23];
    assign rd_o[24] = rs1_i[24] & rs2_i[24];
    assign rd_o[25] = rs1_i[25] & rs2_i[25];
    assign rd_o[26] = rs1_i[26] & rs2_i[26];
    assign rd_o[27] = rs1_i[27] & rs2_i[27];
    assign rd_o[28] = rs1_i[28] & rs2_i[28];
    assign rd_o[29] = rs1_i[29] & rs2_i[29];
    assign rd_o[30] = rs1_i[30] & rs2_i[30];
    assign rd_o[31] = rs1_i[31] & rs2_i[31];

endmodule
