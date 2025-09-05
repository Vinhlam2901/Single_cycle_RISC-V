module brcomp (
    input      [31:0] rs1_i,
    input      [31:0] rs2_i,
    input             br_unsign,// 1 if unsign, 0 if sign
    output wire       br_less,
    output reg        br_equal
);
  integer i;
  wire [31:0] sub_o;
  wire        cout;
  reg  [31:0] etemp1, etemp2;

  add_subtract S1 ( .a_i(rs1_i), .b_i(rs2_i), .cin_i(1'b1), .result_o(sub_o), .cout_o(cout));
  //assign mux_out = (br_unsign) ? cout : ~sub_o[31];
  //assign less_sign1 = mux_out ^ ~br_unsign;
  //overflow check
  // assign ltemp1 = rs1_i[31] ^ rs2_i[31];
  // assign ltemp2 = rs1_i[31] ^ sub_o[31];
  // assign ltemp3 = (rs1_i[31] ^ rs2_i[31]) & (rs1_i[31] ^ sub_o[31]);
  // assign ltemp4 = ((rs1_i[31] ^ rs2_i[31]) & (rs1_i[31] ^ sub_o[31])) ^ sub_o[31];
  //assign less_sign2 = ((rs1_i[31] ^ rs2_i[31]) & (rs1_i[31] ^ sub_o[31])) ^ sub_o[31] & ~br_unsign;
  //br_less
  assign br_less = (br_unsign ? cout : ~sub_o[31]) ^ ~br_unsign |
                   (rs1_i[31] ^ rs2_i[31]) & (rs1_i[31] ^ sub_o[31]) ^ sub_o[31] & ~br_unsign;
  //compare block
  always @(*)begin
    for(i = 0; i < 32; i = i + 1) begin
      etemp1[i] =  sub_o[i] ^ 1'b1;
    end
    for(i = 0; i < 31; i = i + 1) begin
      etemp2[i] =  etemp1[i] & etemp1[i+1];
      if (etemp2[i] == 1'b0) begin
        br_equal = 1'b0;
      end else begin
        br_equal = 1'b1;
      end
    end
  end
endmodule
