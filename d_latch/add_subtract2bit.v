module add_subtract2bit (
    input  [1:0] a_i,
    input  [1:0] b_i,
    input        cin_i, // Carry-in for the least significant bit
    output [1:0] result_o, // Sum output
    output       cout_o  // Carry-out for the most significant bit
);
  wire C1; // Carry from the first full adder
  wire raw_cout;
  assign cout_o = cin_i ? ~raw_cout : raw_cout;
  //cout thực tế sẽ bị đảo nếu thực hiện phép trừ do tính chất mượn và tràn số khi trừ 2 số binary
  wire [1:0] b_mod_i;
  assign b_mod_i = b_i ^ {2{cin_i}}; // Modify b_i based on cin_i for addition/subtraction

  // Instantiate two full adders for 2-bit addition
  full_adder FA0 (.X_i(a_i[0]), .B_i(b_mod_i[0]), .C_i(cin_i), .S_o(result_o[0]), .C_o(C1));
  full_adder FA1 (.X_i(a_i[1]), .B_i(b_mod_i[1]), .C_i(C1), .S_o(result_o[1]), .C_o(raw_cout));
endmodule