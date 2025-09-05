module immgen (
    input       [11:0] imm_i,
    output wire [31:0] imm_o
);
  assign imm_o = (imm_i[11] == 1'b0) ? {20'b0, imm_i} : {20'hFFFFF, imm_i};
endmodule
