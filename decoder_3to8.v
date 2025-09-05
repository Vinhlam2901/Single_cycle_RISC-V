module decoder_3to8 (
    input [2:0] a_i,   // 3-bit input
    input g1, g2a, g2b, // Active low enable signals
    output [7:0] out_o  // 8-bit output
);
    wire n_g1, n_g2a, n_g2b; // Inverted enable signals
    
    // Invert the enable signals (active low logic)
    assign n_g1 = ~g1;
    assign n_g2a = ~g2a;
    assign n_g2b = ~g2b;
    
    // Output logic: all output lines are active low (only one will be low at a time)
    assign out_o[0] = n_g1 & n_g2a & n_g2b & ~a_i[2] & ~a_i[1] & ~a_i[0];
    assign out_o[1] = n_g1 & n_g2a & n_g2b & ~a_i[2] & ~a_i[1] &  a_i[0];
    assign out_o[2] = n_g1 & n_g2a & n_g2b & ~a_i[2] &  a_i[1] & ~a_i[0];
    assign out_o[3] = n_g1 & n_g2a & n_g2b & ~a_i[2] &  a_i[1] &  a_i[0];
    assign out_o[4] = n_g1 & n_g2a & n_g2b &  a_i[2] & ~a_i[1] & ~a_i[0];
    assign out_o[5] = n_g1 & n_g2a & n_g2b &  a_i[2] & ~a_i[1] &  a_i[0];
    assign out_o[6] = n_g1 & n_g2a & n_g2b &  a_i[2] &  a_i[1] & ~a_i[0];
    assign out_o[7] = n_g1 & n_g2a & n_g2b &  a_i[2] &  a_i[1] &  a_i[0];

endmodule

