//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Single Cycle R-Type
// File            : single_cycle.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 6/11/2025 - Finished
//=============================================================================================================
import package_param::*;
module single_cycle (
    input  wire        i_clk,   // FPGA 50Mhz -> chia CLK xuống 10Hz
    input  wire        i_reset,

    input  wire  [31:0] i_io_sw,

    output reg  [31:0] o_io_ledr,
    output reg  [31:0] o_io_ledg,

    output reg  [31:0] o_io_lcd,

    output reg  [6:0]  o_io_hex0,
    output reg  [6:0]  o_io_hex1,
    output reg  [6:0]  o_io_hex2,
    output reg  [6:0]  o_io_hex3,
    output reg  [6:0]  o_io_hex4,
    output reg  [6:0]  o_io_hex5,
    output reg  [6:0]  o_io_hex6,
    output reg  [6:0]  o_io_hex7,


    output reg  [31:0] o_pc_debug,
    output reg         o_insn_vld
  );
//==================Declaration================================================================================
  // wire          i_clk;
  reg   [31:0]  inst;
  reg   [31:0]  next_pc;
  reg   [31:0]  jmp_pc;
  wire  [31:0]  pc_plus4;
  wire          pc_sel;
  wire  [1:0]   wb_sel;
  reg           op1_sel;
  wire          op2_sel;
  wire  [3:0]   alu_op;
  wire          rd_wren;
  wire          mem_wren;
  wire          br_unsign;
  wire          br_less;
  wire          br_equal;
  wire  [31:0]  rs1_data;
  reg   [31:0]  op1;
  wire  [31:0]  rs2_data;
  wire  [31:0]  op2;
  wire  [31:0]  imm_ex;
  reg   [31:0]  wb_data_o;
  reg   [31:0]  rd_data_o;
  reg   [31:0]  wr_data;
  reg   [31:0]  read_data;
  reg   [31:0]  mem           [0:8095];   //8kB

//==================Instance=====================================================================================
//==================i_clk=====================================================================================
  // clk_divider clock_divider (
  //                             .i_clk(i_clk),
  //                             .i_reset(i_reset),
  //                             .o_clk(clk_div)
  //                           );
//==================PC=============================================================================================

  always_ff @(posedge i_clk or negedge i_reset) begin: pc_reg
    if (~i_reset) begin
        o_pc_debug <= 32'b0;
    end else begin
        o_pc_debug <= next_pc;
    end
  end
  pc_reg PCplus4 (
                  .pc_reg(o_pc_debug),
                  .pc_o(pc_plus4)
                 );
  assign next_pc = (pc_sel) ? jmp_pc : pc_plus4;
//==================IMEM=========================================================================================
  initial begin : instruction
    $readmemh("../02_test/isa_4b.hex", mem);
  end

  assign inst = mem[o_pc_debug[31:2]];
//==================REGFILE========================================================================================
  regfile       regfile      (
                              .i_clk      (i_clk     ),
                              .i_reset    (i_reset     ),
                              .i_rs1_addr (inst[19:15] ),
                              .i_rs2_addr (inst[24:20] ),
                              .i_rd_addr  (inst[11:7]  ),
                              .i_rd_data  (wb_data_o   ),
                              .i_rd_wren  (rd_wren     ),
                              .o_rs1_data (rs1_data    ),
                              .o_rs2_data (rs2_data    )
                             );
//==================CONTROL_UNIT=====================================================================================
  control_unit  control_unit (
                              .instruction(inst      ),
                              .pc_sel     (pc_sel    ),
                              .o_inst_valid(o_insn_vld),
                              .br_unsign  (br_unsign ),
                              .op1_sel    (op1_sel   ),
                              .op2_sel    (op2_sel   ),
                              .alu_opcode (alu_op    ),
                              .rd_wren    (rd_wren   ),
                              .wb_sel     (wb_sel    ),
                              .mem_wren   (mem_wren  )
                              );
//==================IMMGEN==============================================================================================
  immgen        immgen       (
                              .inst_i (inst   ),
                              .imm_o  (imm_ex )
                             );
//==================BRCOMP=========================================================================================
  brcomp        branch_compare (
                              .i_rs1_data (rs1_data),
                              .i_rs2_data (rs2_data),
                              .i_br_un    (br_unsign),
                              .o_br_less  (br_less),
                              .o_br_equal (br_equal)
                              );
//==================OPERATION_1=======================================================================================
  always_comb begin : op1_sel_branch
    if(inst[6:0] == STYPE && op1_sel) begin
      case (inst[14:12])
        3'b000: op1 = ( br_equal                         ) ? o_pc_debug : rs1_data; // beq
        3'b001: op1 = (~br_equal                         ) ? o_pc_debug : rs1_data; // bne
        3'b100: op1 = ( br_less                          ) ? o_pc_debug : rs1_data; // blt
        3'b101: op1 = (~br_less || br_equal              ) ? o_pc_debug : rs1_data; // bge > or =
        3'b110: op1 = ( br_less && br_unsign             ) ? o_pc_debug : rs1_data; // bltu
        3'b111: op1 = (~br_less || br_equal && br_unsign ) ? o_pc_debug : rs1_data; // bgeu
        default:op1 = op1;
      endcase
    end else if (inst[6:0] == U1TYPE) begin
      op1 = 32'b0;
    end else if (inst[6:0] == U2TYPE) begin
      op1 = o_pc_debug;
    end else begin
      op1 = (op1_sel) ? o_pc_debug : rs1_data;
    end
  end
//==================OPERATION_2=======================================================================================
  assign op2 = (op2_sel) ? imm_ex : rs2_data;
//==================ALU=================================================================================================
  alu     alu  (
                 .i_op_a      (op1),
                 .i_op_b      (op2),
                 .br_unsign_i (br_unsign),
                 .i_alu_op    (alu_op),
                 .o_alu_data  (rd_data_o)
                );
//==================LSU=================================================================================================
  always_comb begin
    // has rs2'data if stype to store rs2'data to mem
    wr_data    = 32'b0;
    if(inst[6:0] == STYPE || inst[6:0] == ILTYPE) begin
      if(inst[6:0] == STYPE) begin
        wr_data = rs2_data;
      end else if (inst[6:0] == ILTYPE) begin
        wr_data = rs1_data;
      end
      case (inst[14:12])                            // check func3
        3'b000,
        3'b100:   wr_data = wr_data & 32'h000000FF;
        3'b001,
        3'b101:   wr_data = wr_data & 32'h0000FFFF;
        3'b010:   wr_data = wr_data & 32'hFFFFFFFF;
        3'b100:   wr_data = wr_data & 32'h000000FF;
        3'b101:   wr_data = wr_data & 32'h0000FFFF;
        default : wr_data = wr_data & 32'hFFFFFFFF;
      endcase
    end
  end

  lsu lsu (
            .i_clk      (i_clk),
            .i_reset    (i_reset),
            .i_lsu_addr (rd_data_o),
            .i_st_data  (wr_data),
            .i_lsu_wren (mem_wren),
            .i_func3    (inst[14:12]),
            .i_io_sw    (i_io_sw),
            .o_io_hex0  (o_io_hex0),
            .o_io_hex1  (o_io_hex1),
            .o_io_hex2  (o_io_hex2),
            .o_io_hex3  (o_io_hex3),
            .o_io_hex4  (o_io_hex4),
            .o_io_hex5  (o_io_hex5),
            .o_io_hex6  (o_io_hex6),
            .o_io_hex7  (o_io_hex7),
            .o_ld_data  (read_data),
            .o_io_ledr  (o_io_ledr),
            .o_io_ledg  (o_io_ledg),
            .o_io_lcd   (o_io_lcd)
          );
//==================WRITEBACK=========================================================================================
  always_comb begin : write_back
    case (wb_sel)
      2'b00: begin
        wb_data_o   = ((inst[11:7]) == 5'b00000) ? 32'b0 : rd_data_o; // hardwire x0
        jmp_pc = 32'b0;
      end
      2'b01: begin  : pc_jump
        jmp_pc = 32'b0;
        case (inst[14:12])
          3'b000: jmp_pc = ( br_equal)                         ? rd_data_o : (o_pc_debug + 32'd4); // beq
          3'b001: jmp_pc = (~br_equal)                         ? rd_data_o : (o_pc_debug + 32'd4); // bne
          3'b100: jmp_pc = ( br_less)                          ? rd_data_o : (o_pc_debug + 32'd4); // blt
          3'b101: jmp_pc = (~br_less || br_equal)              ? rd_data_o : (o_pc_debug + 32'd4); // bge
          3'b110: jmp_pc = ( br_less && br_unsign)             ? rd_data_o : (o_pc_debug + 32'd4); // bltu
          3'b111: jmp_pc = (~br_less || br_equal && br_unsign) ? rd_data_o : (o_pc_debug + 32'd4); // bgeu
          default:jmp_pc = rd_data_o; // For JALR
        endcase
      end
      2'b10: begin
        wb_data_o = o_pc_debug + 32'd4;
        jmp_pc    = rd_data_o;
      end
      2'b11: wb_data_o = read_data;
      default: wb_data_o = 32'b0;
    endcase
  end
endmodule
