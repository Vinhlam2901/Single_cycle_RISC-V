module nor_gate (  
    input       a_i,
    input       b_i,
    output wire c_o
);
  nor A2 (c_o, a_i, b_i);
endmodule