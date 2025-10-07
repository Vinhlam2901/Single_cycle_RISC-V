module adder_4bit (
    input  wire [3:0] i_sum,
    input  wire [3:0] i_coin,
    input  wire       i_cin,
    output wire [3:0] o_i_sum,
    output wire       o_cout
);
  wire [2:0] c;
  full_adder f1 (
    .X_i(i_sum[0]),
    .B_i(i_coin[0]),
    .C_i(i_cin),
    .S_o(o_i_sum[0]),
    .C_o(c[0])
);
  full_adder f2 (
    .X_i(i_sum[1]),
    .B_i(i_coin[1]),
    .C_i(c[0]),
    .S_o(o_i_sum[1]),
    .C_o(c[1])
);
  full_adder f3 (
    .X_i(i_sum[2]),
    .B_i(i_coin[2]),
    .C_i(c[1]),
    .S_o(o_i_sum[2]),
    .C_o(c[2])
);
  full_adder f4 (
    .X_i(i_sum[3]),
    .B_i(i_coin[3]),
    .C_i(c[2]),
    .S_o(o_i_sum[3]),
    .C_o(o_cout)
);
endmodule
