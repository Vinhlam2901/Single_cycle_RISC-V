module subtract20_4bit (
    input  wire [3:0] i_sum,
    input  wire [3:0] i_20,
    input  wire       i_cin,
    output wire [2:0] o_i_sub,
    output wire       o_cout
);
  wire [3:0] c;
  wire [3:0] sub;
  full_adder f1 (
    .X_i(i_sum[0]),
    .B_i(~i_20[0]),
    .C_i(1'b1),
    .S_o(sub[0]),
    .C_o(c[0])
);
  full_adder f2 (
    .X_i(i_sum[1]),
    .B_i(~i_20[1]),
    .C_i(c[0]),
    .S_o(sub[1]),
    .C_o(c[1])
);
  full_adder f3 (
    .X_i(i_sum[2]),
    .B_i(~i_20[2]),
    .C_i(c[1]),
    .S_o(sub[2]),
    .C_o(c[2])
);
  full_adder f4 (
    .X_i(i_sum[3]),
    .B_i(~i_20[3]),
    .C_i(c[2]),
    .S_o(sub[3]),
    .C_o(c[3])
);
  assign o_i_sub = sub[2:0];
  assign o_cout = ~c[3];
endmodule
