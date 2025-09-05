module d_latch_en_rst (
    input data, en, rst,
    output reg q
);
always @(data or en or rst) 
    if(~rst) q = 1'b0;
    else if(en) q = data;
endmodule