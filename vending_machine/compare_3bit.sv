module compare_3bit (
    input  wire [2:0] i_sum,
    input  wire [2:0] i_20,
    output wire       sum_eq,
    output wire       sum_lt // br_less
);
  wire cout;
  wire [2:0] sub;
  assign {cout, sub} = i_sum - i_20;
  assign sum_eq = (sub[0] ^ 1) & (sub[1] ^ 1) &
                  (sub[2] ^ 1);
  assign sum_lt = (cout == 1'b0) ? 1'b0 : 1'b1;
  // sum_lt = 1 -> not enough
  // sum_eq   -> change = 000, soda = 1
  // sum_lt = 0, sum_eq = 0 -> change = ..., soda = 1
endmodule
