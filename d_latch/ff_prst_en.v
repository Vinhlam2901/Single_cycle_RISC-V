module ff_prst_en (
    input      data_i,
    input      clk_i,
    input      prst_i,
    input      en_i,
    output reg q_o
);
  always @(posedge clk_i or negedge prst_i)
    if (~prst_i) q_o <= 1'b1;
    else if (en_i) q_o <= data_i;
endmodule
