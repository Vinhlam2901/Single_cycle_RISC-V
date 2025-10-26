//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Branch Compararison
// File            : brcomp.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 10/9/2025
// Updated date    : 12/9/2025
//===========================================================================================
module brcomp (
    input  wire [31:0] i_rs1_data,
    input  wire [31:0] i_rs2_data,
    input  wire        i_br_un,// 1 if unsign, 0 if sign
    output wire        o_br_equal,
    output wire        o_br_less
);
  wire [31:0] sub_o;
  wire cout;
  //add_subtract S1 ( .a_i(i_rs1_data), .b_i(i_rs2_data), .cin_i(1'b1), .result_o(sub_o), .cout_o(cout));
  //assign mux_out = (i_br_un) ? cout : ~sub_o[31];
  //assign less_sign1 = mux_out ^ ~i_br_un;
  //overflow check
  // assign ltemp1 = i_rs1_data[31] ^ i_rs2_data[31];
  // assign ltemp2 = i_rs1_data[31] ^ sub_o[31];
  // assign ltemp3 = ltemp1 & ltemp2;
  // assign ltemp4 = ltemp3 ^ sub_o[31];
  //assign less_sign2 = ltemp4 & ~i_br_un;
  assign {cout, sub_o} = i_rs1_data - i_rs2_data;
  //o_br_less
  assign o_br_less = ((i_br_un ? cout : ~sub_o[31]) ^ ~i_br_un) |
                   (((i_rs1_data[31] ^ i_rs2_data[31])& (i_rs1_data[31] ^ sub_o[31]) ^ sub_o[31]) & ~i_br_un);
  //compare block
  assign o_br_equal = (sub_o[0]  ^ 1'b1) & (sub_o[1]  ^ 1'b1) & (sub_o[2]  ^ 1'b1) &
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
