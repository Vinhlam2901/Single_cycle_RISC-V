//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Register File// File            : regfile.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 16/9/2025
//===========================================================================================
module regfile (
    input  wire         clk_i,
    input  wire         rst_ni,
    input  wire         enb_i,

    input  wire  [4:0]   rs1_addr_i,
    input  wire  [4:0]   rs2_addr_i,
    input  wire  [4:0]   rd_addr_i,
    input  wire  [31:0]  rd_data_i,
    input  wire          rd_wren_i,

    output reg  [31:0]  rs1_data_o,
    output reg  [31:0]  rs2_data_o
);
//===========================================================================================
// Declaration
// reg  [31:0] regfile [0:31];
  wire [31:0] data_o;
  integer i;
  wire [31:0] q_o0, q_o1, q_o2, q_o3, q_o4, q_o5, q_o6, q_o7, //tao ra 32 bus q_o cho 32 register
              q_o8, q_o9, q_o10, q_o11, q_o12, q_o13, q_o14, q_o15,
              q_o16, q_o17, q_o18, q_o19, q_o20, q_o21, q_o22, q_o23,
              q_o24, q_o25, q_o26, q_o27, q_o28, q_o29, q_o30, q_o31;
  reg  [31:1] enb;
  //===========================================================================================
  decoder_5to32 d1 (.a_i(rd_addr_i), .out_o(data_o));
  assign enb[1]   = rd_wren_i & data_o[1];
  assign enb[2]   = rd_wren_i & data_o[2];
  assign enb[3]   = rd_wren_i & data_o[3];
  assign enb[4]   = rd_wren_i & data_o[4];
  assign enb[5]   = rd_wren_i & data_o[5];
  assign enb[6]   = rd_wren_i & data_o[6];
  assign enb[7]   = rd_wren_i & data_o[7];
  assign enb[8]   = rd_wren_i & data_o[8];
  assign enb[9]   = rd_wren_i & data_o[9];
  assign enb[10]  = rd_wren_i & data_o[10];
  assign enb[11]  = rd_wren_i & data_o[11];
  assign enb[12]  = rd_wren_i & data_o[12];
  assign enb[13]  = rd_wren_i & data_o[13];
  assign enb[14]  = rd_wren_i & data_o[14];
  assign enb[15]  = rd_wren_i & data_o[15];
  assign enb[16]  = rd_wren_i & data_o[16];
  assign enb[17]  = rd_wren_i & data_o[17];
  assign enb[18]  = rd_wren_i & data_o[18];
  assign enb[19]  = rd_wren_i & data_o[19];
  assign enb[20]  = rd_wren_i & data_o[20];
  assign enb[21]  = rd_wren_i & data_o[21];
  assign enb[22]  = rd_wren_i & data_o[22];
  assign enb[23]  = rd_wren_i & data_o[23];
  assign enb[24]  = rd_wren_i & data_o[24];
  assign enb[25]  = rd_wren_i & data_o[25];
  assign enb[26]  = rd_wren_i & data_o[26];
  assign enb[27]  = rd_wren_i & data_o[27];
  assign enb[28]  = rd_wren_i & data_o[28];
  assign enb[29]  = rd_wren_i & data_o[29];
  assign enb[30]  = rd_wren_i & data_o[30];
  assign enb[31]  = rd_wren_i & data_o[31];
  register_32bit r0  (.clk_i(clk_i), .nrst_i(1'b0),   .en_i(1'b1),    .d_i(32'b0),     .q_o(q_o0) );
  register_32bit r1  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[1]),  .d_i(rd_data_i), .q_o(q_o1) );
  register_32bit r2  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[2]),  .d_i(rd_data_i), .q_o(q_o2) );
  register_32bit r3  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[3]),  .d_i(rd_data_i), .q_o(q_o3) );
  register_32bit r4  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[4]),  .d_i(rd_data_i), .q_o(q_o4) );
  register_32bit r5  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[5]),  .d_i(rd_data_i), .q_o(q_o5) );
  register_32bit r6  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[6]),  .d_i(rd_data_i), .q_o(q_o6) );
  register_32bit r7  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[7]),  .d_i(rd_data_i), .q_o(q_o7) );
  register_32bit r8  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[8]),  .d_i(rd_data_i), .q_o(q_o8) );
  register_32bit r9  (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[9]),  .d_i(rd_data_i), .q_o(q_o9) );
  register_32bit r10 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[10]), .d_i(rd_data_i), .q_o(q_o10));
  register_32bit r11 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[11]), .d_i(rd_data_i), .q_o(q_o11));
  register_32bit r12 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[12]), .d_i(rd_data_i), .q_o(q_o12));
  register_32bit r13 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[13]), .d_i(rd_data_i), .q_o(q_o13));
  register_32bit r14 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[14]), .d_i(rd_data_i), .q_o(q_o14));
  register_32bit r15 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[15]), .d_i(rd_data_i), .q_o(q_o15));
  register_32bit r16 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[16]), .d_i(rd_data_i), .q_o(q_o16));
  register_32bit r17 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[17]), .d_i(rd_data_i), .q_o(q_o17));
  register_32bit r18 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[18]), .d_i(rd_data_i), .q_o(q_o18));
  register_32bit r19 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[19]), .d_i(rd_data_i), .q_o(q_o19));
  register_32bit r20 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[20]), .d_i(rd_data_i), .q_o(q_o20));
  register_32bit r21 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[21]), .d_i(rd_data_i), .q_o(q_o21));
  register_32bit r22 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[22]), .d_i(rd_data_i), .q_o(q_o22));
  register_32bit r23 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[23]), .d_i(rd_data_i), .q_o(q_o23));
  register_32bit r24 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[24]), .d_i(rd_data_i), .q_o(q_o24));
  register_32bit r25 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[25]), .d_i(rd_data_i), .q_o(q_o25));
  register_32bit r26 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[26]), .d_i(rd_data_i), .q_o(q_o26));
  register_32bit r27 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[27]), .d_i(rd_data_i), .q_o(q_o27));
  register_32bit r28 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[28]), .d_i(rd_data_i), .q_o(q_o28));
  register_32bit r29 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[29]), .d_i(rd_data_i), .q_o(q_o29));
  register_32bit r30 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[30]), .d_i(rd_data_i), .q_o(q_o30));
  register_32bit r31 (.clk_i(clk_i), .nrst_i(rst_ni), .en_i(enb[31]), .d_i(rd_data_i), .q_o(q_o31));

  mux_32to1 mux_rs1 (
                      .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
                      .d4(q_o4),  .d5(q_o5),  .d6(q_o6),  .d7(q_o7),
                      .d8(q_o8),  .d9(q_o9),  .d10(q_o10),.d11(q_o11),
                      .d12(q_o12),.d13(q_o13),.d14(q_o14),.d15(q_o15),
                      .d16(q_o16),.d17(q_o17),.d18(q_o18),.d19(q_o19),
                      .d20(q_o20),.d21(q_o21),.d22(q_o22),.d23(q_o23),
                      .d24(q_o24),.d25(q_o25),.d26(q_o26),.d27(q_o27),
                      .d28(q_o28),.d29(q_o29),.d30(q_o30),.d31(q_o31),
                      .s(rs1_addr_i), .y_o(rs1_data_o)
                    );
  mux_32to1 mux_rs2 (
                      .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
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


//  always_ff @(posedge clk_i or negedge rst_ni) begin : regfile_32register
//       if (~rst_ni || rd_addr_i == 5'b00000) begin
//             regfile[0] <= 0;
//             regfile[1] <= 0;
//             regfile[2] <= 0;
//             regfile[3] <= 0;
//             regfile[4] <= 0;
//             regfile[5] <= 0;
//             regfile[6] <= 0;
//             regfile[7] <= 0;
//             regfile[8] <= 0;
//             regfile[9] <= 0;
//             regfile[10] <= 0;
//             regfile[11] <= 0;
//             regfile[12] <= 0;
//             regfile[13] <= 0;
//             regfile[14] <= 0;
//             regfile[15] <= 0;
//             regfile[16] <= 0;
//             regfile[17] <= 0;
//             regfile[18] <= 0;
//             regfile[19] <= 0;
//             regfile[20] <= 0;
//             regfile[21] <= 0;
//             regfile[22] <= 0;
//             regfile[23] <= 0;
//             regfile[24] <= 0;
//             regfile[25] <= 0;
//             regfile[26] <= 0;
//             regfile[27] <= 0;
//             regfile[28] <= 0;
//             regfile[29] <= 0;
//             regfile[30] <= 0;
//             regfile[31] <= 0; 
//       end else if (enb_i && rd_wren_i && rd_addr_i !== 5'b00000) begin
//         regfile[rd_addr_i] <= rd_data_i;
//       end
//     end
//     always_comb begin : regfile_rs_data
//       rs1_data_o = (rs1_addr_i == 5'b00000 ) ? 32'b0 : regfile[rs1_addr_i];
//       rs2_data_o = (rs2_addr_i == 5'b00000)  ? 32'b0 : regfile[rs2_addr_i];
//       rs1_data_o = (rs1_addr_i == rd_addr_i) ? rd_data_i : rs1_data_o;
//       rs2_data_o = (rs2_addr_i == rd_addr_i) ? rd_data_i : rs2_data_o;
//     end