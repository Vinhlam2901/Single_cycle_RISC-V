module adder (
  input       [31:0] pc_in,
  output wire [31:0] pc_out
);
  assign pc_out = pc_in + 32'h00000004;
endmodule
