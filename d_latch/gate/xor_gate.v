module xor_gate (
    input       a_i,
    input       b_i,
    output wire c_o
);
  xor X1 (c_o, a_i, b_i);    
endmodule