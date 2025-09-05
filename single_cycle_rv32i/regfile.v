module regfile (
    input  [4:0]  rs1_addr_i,
    input  [4:0]  rs2_addr_i,
    input  [4:0]  rd_addr_i,
    input  [31:0] rd_data_i,
    input         rd_wren_i,
    input         clk_i,
    output [31:0] rs1_data_o,
    output [31:0] rs2_data_o
);
  integer i;
  wire [31:0] q_o0, q_o1, q_o2, q_o3, q_o4, q_o5, q_o6, q_o7, //tao ra 32 bus q_o cho 32 register
              q_o8, q_o9, q_o10, q_o11, q_o12, q_o13, q_o14, q_o15,
              q_o16, q_o17, q_o18, q_o19, q_o20, q_o21, q_o22, q_o23,
              q_o24, q_o25, q_o26, q_o27, q_o28, q_o29, q_o30, q_o31;
  wire [31:0] data_o;
  reg  [31:0] enb, rst_n;
  assign q_o0 = q_o0; // Register 0 is always zero
  decoder_5to32 d1 (.a_i(rd_addr_i), .out_o(data_o));

  always @(*) begin
    for(i = 0; i < 32; i = i + 1) begin //co the loi o day vi da su dung ngo ra instance cua decoder[i] =
        enb[i] =  {32{rd_wren_i}} & data_o[i];
        rst_n[i] = ~rd_wren_i;
    end
  end
  register_32bit r0  ( .clk_i(clk_i),  .nrst_i(rst_n[0]),  .en_i(enb[0]),  .d_i(q_o0),      .q_o(q_o0) );
  register_32bit r1  ( .clk_i(clk_i),  .nrst_i(rst_n[1]),  .en_i(enb[1]),  .d_i(rd_data_i), .q_o(q_o1) );
  register_32bit r2  ( .clk_i(clk_i),  .nrst_i(rst_n[2]),  .en_i(enb[2]),  .d_i(rd_data_i), .q_o(q_o2) );
  register_32bit r3  ( .clk_i(clk_i),  .nrst_i(rst_n[3]),  .en_i(enb[3]),  .d_i(rd_data_i), .q_o(q_o3) );
  register_32bit r4  ( .clk_i(clk_i),  .nrst_i(rst_n[4]),  .en_i(enb[4]),  .d_i(rd_data_i), .q_o(q_o4) );
  register_32bit r5  ( .clk_i(clk_i),  .nrst_i(rst_n[5]),  .en_i(enb[5]),  .d_i(rd_data_i), .q_o(q_o5) );
  register_32bit r6  ( .clk_i(clk_i),  .nrst_i(rst_n[6]),  .en_i(enb[6]),  .d_i(rd_data_i), .q_o(q_o6) );
  register_32bit r7  ( .clk_i(clk_i),  .nrst_i(rst_n[7]),  .en_i(enb[7]),  .d_i(rd_data_i), .q_o(q_o7) );
  register_32bit r8  ( .clk_i(clk_i),  .nrst_i(rst_n[8]),  .en_i(enb[8]),  .d_i(rd_data_i), .q_o(q_o8) );
  register_32bit r9  ( .clk_i(clk_i),  .nrst_i(rst_n[9]),  .en_i(enb[9]),  .d_i(rd_data_i), .q_o(q_o9) );
  register_32bit r10 ( .clk_i(clk_i),  .nrst_i(rst_n[10]), .en_i(enb[10]), .d_i(rd_data_i), .q_o(q_o10));
  register_32bit r11 ( .clk_i(clk_i),  .nrst_i(rst_n[11]), .en_i(enb[11]), .d_i(rd_data_i), .q_o(q_o11));
  register_32bit r12 ( .clk_i(clk_i),  .nrst_i(rst_n[12]), .en_i(enb[12]), .d_i(rd_data_i), .q_o(q_o12));
  register_32bit r13 ( .clk_i(clk_i),  .nrst_i(rst_n[13]), .en_i(enb[13]), .d_i(rd_data_i), .q_o(q_o13));
  register_32bit r14 ( .clk_i(clk_i),  .nrst_i(rst_n[14]), .en_i(enb[14]), .d_i(rd_data_i), .q_o(q_o14));
  register_32bit r15 ( .clk_i(clk_i),  .nrst_i(rst_n[15]), .en_i(enb[15]), .d_i(rd_data_i), .q_o(q_o15));
  register_32bit r16 ( .clk_i(clk_i),  .nrst_i(rst_n[16]), .en_i(enb[16]), .d_i(rd_data_i), .q_o(q_o16));
  register_32bit r17 ( .clk_i(clk_i),  .nrst_i(rst_n[17]), .en_i(enb[17]), .d_i(rd_data_i), .q_o(q_o17));
  register_32bit r18 ( .clk_i(clk_i),  .nrst_i(rst_n[18]), .en_i(enb[18]), .d_i(rd_data_i), .q_o(q_o18));
  register_32bit r19 ( .clk_i(clk_i),  .nrst_i(rst_n[19]), .en_i(enb[19]), .d_i(rd_data_i), .q_o(q_o19));
  register_32bit r20 ( .clk_i(clk_i),  .nrst_i(rst_n[20]), .en_i(enb[20]), .d_i(rd_data_i), .q_o(q_o20));
  register_32bit r21 ( .clk_i(clk_i),  .nrst_i(rst_n[21]), .en_i(enb[21]), .d_i(rd_data_i), .q_o(q_o21));
  register_32bit r22 ( .clk_i(clk_i),  .nrst_i(rst_n[22]), .en_i(enb[22]), .d_i(rd_data_i), .q_o(q_o22));
  register_32bit r23 ( .clk_i(clk_i),  .nrst_i(rst_n[23]), .en_i(enb[23]), .d_i(rd_data_i), .q_o(q_o23));
  register_32bit r24 ( .clk_i(clk_i),  .nrst_i(rst_n[24]), .en_i(enb[24]), .d_i(rd_data_i), .q_o(q_o24));
  register_32bit r25 ( .clk_i(clk_i),  .nrst_i(rst_n[25]), .en_i(enb[25]), .d_i(rd_data_i), .q_o(q_o25));
  register_32bit r26 ( .clk_i(clk_i),  .nrst_i(rst_n[26]), .en_i(enb[26]), .d_i(rd_data_i), .q_o(q_o26));
  register_32bit r27 ( .clk_i(clk_i),  .nrst_i(rst_n[27]), .en_i(enb[27]), .d_i(rd_data_i), .q_o(q_o27));
  register_32bit r28 ( .clk_i(clk_i),  .nrst_i(rst_n[28]), .en_i(enb[28]), .d_i(rd_data_i), .q_o(q_o28));
  register_32bit r29 ( .clk_i(clk_i),  .nrst_i(rst_n[29]), .en_i(enb[29]), .d_i(rd_data_i), .q_o(q_o29));
  register_32bit r30 ( .clk_i(clk_i),  .nrst_i(rst_n[30]), .en_i(enb[30]), .d_i(rd_data_i), .q_o(q_o30));
  register_32bit r31 ( .clk_i(clk_i),  .nrst_i(rst_n[31]), .en_i(enb[31]), .d_i(rd_data_i), .q_o(q_o31));

  mux_32to1 m1 ( .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
                 .d4(q_o4),  .d5(q_o5),  .d6(q_o6),  .d7(q_o7),
                 .d8(q_o8),  .d9(q_o9),  .d10(q_o10),.d11(q_o11),
                 .d12(q_o12),.d13(q_o13),.d14(q_o14),.d15(q_o15),
                 .d16(q_o16),.d17(q_o17),.d18(q_o18),.d19(q_o19),
                 .d20(q_o20),.d21(q_o21),.d22(q_o22),.d23(q_o23),
                 .d24(q_o24),.d25(q_o25),.d26(q_o26),.d27(q_o27),
                 .d28(q_o28),.d29(q_o29),.d30(q_o30),.d31(q_o31),
                 .s(rs1_addr_i), .y_o(rs1_data_o)
                );
  mux_32to1 m2 ( .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
                 .d4(q_o4),  .d5(q_o5),  .d6(q_o6),  .d7(q_o7),
                 .d8(q_o8),  .d9(q_o9),  .d10(q_o10),.d11(q_o11),
                 .d12(q_o12),.d13(q_o13),.d14(q_o14),.d15(q_o15),
                 .d16(q_o16),.d17(q_o17),.d18(q_o18),.d19(q_o19),
                 .d20(q_o20),.d21(q_o21),.d22(q_o22),.d23(q_o23),
                 .d24(q_o24),.d25(q_o25),.d26(q_o26),.d27(q_o27),
                 .d28(q_o28),.d29(q_o29),.d30(q_o30),.d31(q_o31),
                 .s(rs2_addr_i), .y_o(rs2_data_o)
                 );
endmodule
