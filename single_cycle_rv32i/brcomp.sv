//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Branch Compararison
// File            : brcomp.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 10/9/2025
// Updated date    : 12/9/2025
//===========================================================================================
module brcomp (
    input  wire [31:0] rs1_i,
    input  wire [31:0] rs2_i,
    input  wire        br_unsign_i,// 1 if unsign, 0 if sign
    output wire        br_less,
    output wire        br_equal
);
  wire [31:0] sub_o;
  wire cout;
  //add_subtract S1 ( .a_i(rs1_i), .b_i(rs2_i), .cin_i(1'b1), .result_o(sub_o), .cout_o(cout));
  //assign mux_out = (br_unsign_i) ? cout : ~sub_o[31];
  //assign less_sign1 = mux_out ^ ~br_unsign_i;
  //overflow check
  // assign ltemp1 = rs1_i[31] ^ rs2_i[31];
  // assign ltemp2 = rs1_i[31] ^ sub_o[31];
  // assign ltemp3 = ltemp1 & ltemp2;
  // assign ltemp4 = ltemp3 ^ sub_o[31];
  //assign less_sign2 = ltemp4 & ~br_unsign_i;
  assign {cout, sub_o} = rs1_i - rs2_i;
  //br_less
  assign br_less = ((br_unsign_i ? cout : ~sub_o[31]) ^ ~br_unsign_i) |
                   (((rs1_i[31] ^ rs2_i[31])& (rs1_i[31] ^ sub_o[31]) ^ sub_o[31]) & ~br_unsign_i);
  //compare block
  assign br_equal = (sub_o[0]  ^ 1'b1) & (sub_o[1]  ^ 1'b1) & (sub_o[2]  ^ 1'b1) &
                    (sub_o[3]  ^ 1'b1) & (sub_o[4]  ^ 1'b1) & (sub_o[5]  ^ 1'b1) &
                    (sub_o[6]  ^ 1'b1) & (sub_o[7]  ^ 1'b1) & (sub_o[8]  ^ 1'b1) &
                    (sub_o[9]  ^ 1'b1) & (sub_o[10] ^ 1'b1) & (sub_o[11] ^ 1'b1) &
                    (sub_o[12] ^ 1'b1) & (sub_o[13] ^ 1'b1) & (sub_o[14] ^ 1'b1) &
                    (sub_o[15] ^ 1'b1) & (sub_o[16] ^ 1'b1) & (sub_o[17] ^ 1'b1) &
                    (sub_o[18] ^ 1'b1) & (sub_o[19] ^ 1'b1) & (sub_o[20] ^ 1'b1) &
                    (sub_o[21] ^ 1'b1) & (sub_o[22] ^ 1'b1) & (sub_o[23] ^ 1'b1) &
                    (sub_o[24] ^ 1'b1) & (sub_o[25] ^ 1'b1) & (sub_o[26] ^ 1'b1) &
                    (sub_o[27] ^ 1'b1) & (sub_o[28] ^ 1'b1) & (sub_o[29] ^ 1'b1) &
                    (sub_o[30] ^ 1'b1);
endmodule
