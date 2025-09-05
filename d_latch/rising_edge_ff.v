module rising_edge_ff (
    input      data,
    input      clk,
    output reg q
);
  always @(posedge clk) q = data;
endmodule
