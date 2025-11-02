module xor_32bit (
  input  wire [31:0] rs1_i,
  input  wire [31:0] rs2_i,
  output wire [31:0] rd_o
);
    assign rd_o = rs1_i ^ rs2_i;
endmodule
