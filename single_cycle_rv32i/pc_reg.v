module pc_reg (
  input             clk_i,
  input             nrst_i,
  input      [31:0] pc_ins_i,
  output reg [31:0] pc_o
);
  always @(posedge clk_i or negedge nrst_i) begin
    if (nrst_i == 0) begin
        pc_o <= 32'b0;
    end else begin
        pc_o <= pc_ins_i;
    end
  end
endmodule
