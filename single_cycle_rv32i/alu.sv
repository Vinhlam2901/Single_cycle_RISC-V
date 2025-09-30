//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : ALU - Arithmetic Logic Unit
// File            : alu.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 12/9/2025
//===========================================================================================
module alu (
  input  wire  [31:0] rs1_data_i,
  input  wire  [31:0] rs2_data_i,
  input  wire         br_unsign_i,
  input  wire  [3:0]  alu_op_i,
  output wire  [31:0] rd_data_o
  );
  wire        slt, sltu;
  wire [31:0] rd_and, rd_or, rd_xor, rd_sra, rd_srl, rd_sll, rs_sra, rd_add, rd_sub, rd_slt, rd_sltu;
  wire [31:0] imm_ex;
  wire        cout_add, cout_sub,
              rd_equals, rd_equalu;
  //and
  and_32bit    a1  (
                    .rs1_i(rs1_data_i),
                    .rs2_i(rs2_data_i),
                    .rd_o(rd_and)
                    ); //AND
  //or
  or_32bit     o1  (
                    .rs1_i(rs1_data_i),
                    .rs2_i(rs2_data_i),
                    .rd_o(rd_or)
                   ); //OR
  assign rd_xor = rs1_data_i ^ rs2_data_i; //XOR
    //add and sub
  add_subtract as1 (
                    .a_i      (rs1_data_i),
                    .b_i      (rs2_data_i),
                    .cin_i    (1'b1),
                    .result_o (rd_sub),
                    .cout_o   (cout_sub)
                   ); //SUB
  add_subtract as2 (
                    .a_i      (rs1_data_i),
                    .b_i      (rs2_data_i),
                    .cin_i    (1'b0),
                    .result_o (rd_add),
                    .cout_o   (cout_add)
                   ); //ADD
  //slt and sltu
  brcomp       bc1 (
                    .rs1_i        (rs1_data_i),
                    .rs2_i        (rs2_data_i),
                    .br_unsign_i  (br_unsign_i),
                    .br_less      (slt),
                    .br_equal     (rd_equals)
                    ); //SLT
  brcomp       bc2 (
                    .rs1_i        (rs1_data_i),
                    .rs2_i        (rs2_data_i),
                    .br_unsign_i  (1'b1),
                    .br_less      (sltu),
                    .br_equal     (rd_equalu)
                   ); //SLTU
  //srl and sll
  srl          s1  (
                    .rs1_data (rs1_data_i),
                    .rs2_data (rs2_data_i),
                    .rd_data  (rd_srl)
                    ); //SRL
  sll          s2  (
                    .rs1_data (rs1_data_i),
                    .rs2_data (rs2_data_i),
                    .rd_data  (rd_sll)
                   ); //SLL
  //sra
  sra          s3  (
                    .rs1_data   (rs1_data_i),
                    .rs2_data   (rs2_data_i),
                    .br_unsign  (br_unsign_i),
                    .rd_data    (rd_sra)
                    ); //SRA
  assign rd_slt  = {31'b0, slt};
  assign rd_sltu = {31'b0, sltu};
  //mux
  mux_16to1    m1 (
                    .d0   (rd_add),
                    .d1   (rd_sub),
                    .d2   (rd_sll),
                    .d3   (rd_slt),
                    .d4   (rd_sltu),
                    .d5   (rd_xor),
                    .d6   (rd_sra),
                    .d7   (rd_srl),
                    .d8   (rd_or),
                    .d9   (rd_and),
                    .d10  (32'b0),
                    .d11  (32'b0),
                    .d12  (32'b0),
                    .d13  (32'b0),
                    .d14  (32'b0),
                    .d15  (32'b0),
                    .s    (alu_op_i),
                    .y_o  (rd_data_o)
                );
endmodule
//lí do nmos dẫn 0 và pmos dẫn 1
/* liên quan đến điều kiện tọa thành kênh dẫn, nếu nmos mắc cực D với VDD, thf khi ta cấp mức 1 thì sẽ không có rơi áp ở VGD và VGs nên không thể tạo thành kênh dẫn*/