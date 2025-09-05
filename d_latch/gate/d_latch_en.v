module d_latch_en (
    input data, en,
    output reg y
);
always @(data or en)
    if (en) y = data;
endmodule