module alu_opcode (
  input       [2:0] func3,
  input       [6:0] func7,
  output wire [3:0] alu_opcode
);
  wire is_add, is_sub, is_and, is_or, is_xor, is_slt, is_sltu, is_sra, is_srl, is_sll;
  //is_add
  assign is_add  = ~func3[0] & ~func3[1] & ~func3[2] & ~func7[5];
  //is_sub
  assign is_sub  = ~func3[0] & ~func3[1] & ~func3[2] & func7[5];
  //is_sll
  assign is_sll  = func3[0] & ~func3[1] & ~func3[2];
  //is_slt
  assign is_slt  = ~func3[0] & func3[1] & ~func3[2];
  //is_sltu
  assign is_sltu = func3[0] & func3[1] & ~func3[2];
  //is_xor
  assign is_xor  = ~func3[0] & ~func3[1] & func3[2];
  //is_sra
  assign is_sra  = func3[0] & ~func3[1] & func3[2] & func7[5];
  //is_srl
  assign is_srl  = func3[0] & ~func3[1] & func3[2] & ~func7[5];
  //is_or
  assign is_or   = ~func3[0] & func3[1] & func3[2];
  //is_and
  assign is_and =  func3[0] & func3[1] & func3[2];
  //concatenate the results to form alu_op
  //wire [15:0] op;
  //ssign op = {is_add, is_sub, is_sll, is_slt, is_sltu, is_xor, is_sra, is_srl, is_or, is_and, 6'b0}; //bị sai thứ tự @@
  assign op = {is_and, is_or, is_srl, is_sra, is_xor, is_sltu, is_slt, is_sll, is_sub, is_add};
  //intantiate the encoder
  //encoder_16to4 e1 ( .y_i(op), .out_o(alu_opcode) ); //loi CBPHAI do instance
  assign alu_opcode  = (is_add)  ? 4'b0000 :
                       (is_sub)  ? 4'b0001 :
                       (is_sll)  ? 4'b0010 :
                       (is_slt)  ? 4'b0011 :
                       (is_sltu) ? 4'b0100 :
                       (is_xor)  ? 4'b0101 :
                       (is_sra)  ? 4'b0110 :
                       (is_srl)  ? 4'b0111 :
                       (is_or)   ? 4'b1000 :
                       (is_and)  ? 4'b1001 : 4'b0;
endmodule

