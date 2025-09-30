module register_32bit (
    input              clk_i,
    input              nrst_i,
    input              en_i,
    input       [31:0] d_i,
    output wire [31:0] q_o
); //da hal check va khong co loi
  register_1bit reg0  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[0]), . q_o(q_o[0]));
  register_1bit reg1  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[1]),  .q_o(q_o[1]));
  register_1bit reg2  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[2]),  .q_o(q_o[2]));
  register_1bit reg3  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[3]),  .q_o(q_o[3]));
  register_1bit reg4  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[4]),  .q_o(q_o[4]));
  register_1bit reg5  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[5]),  .q_o(q_o[5]));
  register_1bit reg6  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[6]),  .q_o(q_o[6]));
  register_1bit reg7  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[7]),  .q_o(q_o[7]));
  register_1bit reg8  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[8]),  .q_o(q_o[8]));
  register_1bit reg9  ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i),  .d_i(d_i[9]),  .q_o(q_o[9]));
  register_1bit reg10 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[10]), .q_o(q_o[10]));
  register_1bit reg11 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[11]), .q_o(q_o[11]));
  register_1bit reg12 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[12]), .q_o(q_o[12]));
  register_1bit reg13 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[13]), .q_o(q_o[13]));
  register_1bit reg14 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[14]), .q_o(q_o[14]));
  register_1bit reg15 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[15]), .q_o(q_o[15]));
  register_1bit reg16 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[16]), .q_o(q_o[16]));
  register_1bit reg17 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[17]), .q_o(q_o[17]));
  register_1bit reg18 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[18]), .q_o(q_o[18]));
  register_1bit reg19 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[19]), .q_o(q_o[19]));
  register_1bit reg20 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[20]), .q_o(q_o[20]));
  register_1bit reg21 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[21]), .q_o(q_o[21]));
  register_1bit reg22 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[22]), .q_o(q_o[22]));
  register_1bit reg23 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[23]), .q_o(q_o[23]));
  register_1bit reg24 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[24]), .q_o(q_o[24]));
  register_1bit reg25 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[25]), .q_o(q_o[25]));
  register_1bit reg26 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[26]), .q_o(q_o[26]));
  register_1bit reg27 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[27]), .q_o(q_o[27]));
  register_1bit reg28 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[28]), .q_o(q_o[28]));
  register_1bit reg29 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[29]), .q_o(q_o[29]));
  register_1bit reg30 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[30]), .q_o(q_o[30]));
  register_1bit reg31 ( .clk_i(clk_i), .nrst_i(nrst_i), .en_i(en_i), .d_i(d_i[31]), .q_o(q_o[31]));
endmodule
