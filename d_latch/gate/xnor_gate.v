module xnor_gate (
    input       a_i,
    input       b_i,
    //input       z_i,
    output wire c_o
);
  xnor X2 (c_o, a_i, b_i);
endmodule
