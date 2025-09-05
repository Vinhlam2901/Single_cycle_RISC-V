module or_gate (
    input       a_i,
    input       b_i,
    output wire c_o
);
  or O1 (c_o, a_i, b_i);
endmodule