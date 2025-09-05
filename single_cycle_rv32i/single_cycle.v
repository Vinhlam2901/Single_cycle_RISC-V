module single_cycle (
    input              clk_i,
    input              rst_i,
    output wire [31:0] rd_data_o
);
  wire        br_unsign, br_less, br_equal;
  reg  [31:0]  pc_reg;
  wire [31:0] inst;
  wire [6:0]  opcode;
  wire [4:0]  rd_addr, rs1_addr, rs2_addr;
  wire [2:0]  func3;
  wire [6:0]  func7;
  wire [11:0] imm_data;
  wire [3:0]  alu_op;
  wire [31:0] rs1_data, rs2_data, imm_ex, op1, op2;
  //imem
  imem i1 (.Address(pc_reg), .Instruction(inst));
  //pc
  always @(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_reg <= 32'b0;
    end else begin
        pc_reg <= pc_reg + 4'd4;
    end
  end
  //decode instruction
  assign opcode   = inst[6:0];
  assign rd_addr  = inst[11:7];
  assign func3    = inst[14:12];
  assign rs1_addr = inst[19:15];
  assign rs2_addr = inst[24:20];
  assign func7    = inst[31:25];
  assign imm_data = inst[31:20];
  // //regfile
  regifle r1 (.rs1_addr_i(rs1_addr),
              .rs2_addr_i(rs2_addr),
              .rd_addr_i(rd_addr),
              .rd_data_i(rd_data_o),
              .rd_wren_i(1'b1),
              .clk_i(clk_i),
              .rs1_data_o(rs1_data),
              .rs2_data_o(rs2_data)
              );
  //immgen
  immgen i2 (.imm_i(imm_data), .imm_o(imm_ex));
  //mux1
  assign op2 = (opcode[5] == 1) ? rs2_data : imm_ex;
  //alu opcode
  alu_opcode a1 (.func3(func3), .func7(func7), .alu_opcode(alu_op));
  //alu
  alu        a2 (.rs1_data_i(rs1_data),
                 .rs2_data_i(op2),
                 .alu_op_i(alu_op),
                 .br_unsign_i(br_unsign),
                 .rd_data_o(rd_data_o)
                );
  //brcomp
  brcomp b1 (.rs1_i(rs1_data),
             .rs2_i(rs2_data),
             .br_unsign(br_unsign),
             .br_less(br_less),
             .br_equal(br_equal)
             );
endmodule

