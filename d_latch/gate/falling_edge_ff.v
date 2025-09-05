module falling_edge_ff (
    input      data_i,
    input      clk_i,
    output reg q_o
);
  always @(negedge clk_i) q_o = data_i;
endmodule
