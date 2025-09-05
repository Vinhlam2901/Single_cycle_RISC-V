module adder (
  input       [31:0] pc_in,
  output wire [31:0] pc_out
);
  wire cout;
  assign pc_out = pc_in + 32'd4;
endmodule