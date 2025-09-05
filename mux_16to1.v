module mux_16to1 (
    input       [31:0] d0, d1, d2, d3, d4, d5, d6, d7,
                       d8, d9, d10, d11, d12, d13, d14, d15,
    input       [3:0]  s,
    output wire [31:0] y_o          // output 32-bits
);
 wire [31:0] mux_temp0, mux_temp1, mux_temp2, mux_temp3,
             mux_temp4, mux_temp5, mux_temp6, mux_temp7,
             mux_temp8, mux_temp9, mux_temp10, mux_temp11,
             mux_temp12, mux_temp13;
// Intermediate wires for the 2-to-1 muxes
  assign mux_temp0  =  (s[0]) ? d1  : d0;
  assign mux_temp1  =  (s[0]) ? d3  : d2;
  assign mux_temp2  =  (s[0]) ? d5  : d4;
  assign mux_temp3  =  (s[0]) ? d7  : d6;
  assign mux_temp4  =  (s[0]) ? d9  : d8;
  assign mux_temp5  =  (s[0]) ? d11 : d10;
  assign mux_temp6  =  (s[0]) ? d13 : d12;
  assign mux_temp7  =  (s[0]) ? d15 : d14;
//khong nen dung ngo ra cua mot instance thanh ngo vao cua instace khac (sequential)
  assign mux_temp8  = (s[1]) ? mux_temp1 : mux_temp0;
  assign mux_temp9  = (s[1]) ? mux_temp3 : mux_temp2;
  assign mux_temp10 = (s[1]) ? mux_temp5 : mux_temp4;
  assign mux_temp11 = (s[1]) ? mux_temp7 : mux_temp6;

  assign mux_temp12 = (s[2]) ? mux_temp9  : mux_temp8;
  assign mux_temp13 = (s[2]) ? mux_temp11 : mux_temp10;

  assign y_o = (s[3]) ? mux_temp13 : mux_temp12;
endmodule
