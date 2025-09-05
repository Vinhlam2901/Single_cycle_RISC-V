module mux_2to1_1bit (
    input       d0_i,
    input       d1_i,
    input       s_i,
    output wire y_o
); //da hal check va khong co loi

  assign y_o = (s_i) ? d1_i : d0_i;

endmodule
