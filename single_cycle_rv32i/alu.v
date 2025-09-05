module alu (
  input       [31:0] rs1_data_i,
  input       [31:0] rs2_data_i,
  input              br_unsign_i,
  input       [3:0]  alu_op_i,
  output wire [31:0] rd_data_o
  );
  wire [2:0]  func3;
  wire [6:0]  func7;
  wire [31:0] rd_and, rd_or, rd_xor, rd_sra,
              rd_srl, rd_sll, rs_sra, rd_add, rd_sub;
  wire        cout_add, cout_sub, rd_slt, rd_sltu,
              rd_equals, rd_equalu;
  wire [31:0] mux_temp0, mux_temp1, mux_temp2, mux_temp3,
              mux_temp4, mux_temp5, mux_temp6, mux_temp7,
              mux_temp8, mux_temp9, mux_temp10, mux_temp11,
              mux_temp12, mux_temp13;
  //instance alu_opcode
  //alu_opcode ap1   (.func3(func3), .func7(func7), .alu_opcode(alu_op_i));
  //and
  and_32bit a1     (.rs1_i(rs1_data_i), .rs2_i(rs2_data_i), .rd_o(rd_and));
  //or
  or_32bit o1      (.rs1_i(rs1_data_i), .rs2_i(rs2_data_i), .rd_o(rd_or));
  assign rd_xor = rs1_data_i ^ rs2_data_i;
  //add and sub
  add_subtract as1 (.a_i(rs1_data_i), .b_i(rs2_data_i), .cin_i(1'b1), .result_o(rd_sub), .cout_o(cout_sub));
  add_subtract as2 (.a_i(rs1_data_i), .b_i(rs2_data_i), .cin_i(1'b0), .result_o(rd_add), .cout_o(cout_add));
  //slt and sltu
  brcomp bc1       (.rs1_i(rs1_data_i), .rs2_i(rs2_data_i), .br_unsign(br_unsign_i), .br_less(rd_slt), .br_equal(rd_equals));
  brcomp bc2       (.rs1_i(rs1_data_i), .rs2_i(rs2_data_i), .br_unsign(1'b1), .br_less(rd_sltu), .br_equal(rd_equalu));
  //srl and sll
  srl s1           (.rs1_data(rs1_data_i), .rs2_data(rs2_data_i), .rd_data(rd_srl));
  sll s2           (.rs1_data(rs1_data_i), .rs2_data(rs2_data_i), .rd_data(rd_sll));
  //sra
  sra s3           (.rs1_data(rs1_data_i), .rs2_data(rs2_data_i), .br_unsign(br_unsign_i), .rd_data(rd_sra));
  //mux
  mux_16to1 m1 (.d0(rd_add), .d1(rd_sub), .d2(rd_sll), .d3({31'b0, rd_slt}), .d4({31'b0, rd_sltu}),
                .d5(rd_xor), .d6(rd_srl), .d7(rd_sra), .d8(rd_or), .d9(rd_and),
                .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0),
                .s(alu_op_i), .y_o(rd_data_o)
                );
endmodule
//lí do nmos dẫn 0 và pmos dẫn 1
/* liên quan đến điều kiện tọa thành kênh dẫn, nếu nmos mắc cực D với VDD, thf khi ta cấp mức 1 thì sẽ không có rơi áp ở VGD và VGs nên không thể tạo thành kênh dẫn*/