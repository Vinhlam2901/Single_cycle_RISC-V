//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Single Cycle R-Type
// File            : single_cycle.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 6/11/2025 - Finished
//=============================================================================================================
import package_param::*;
module pipeline_core (
  input  wire        i_clk,
  input  wire        i_reset,

  input  wire [31:0] i_io_sw,

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
//==================Declaration=======================================================================================================

  reg   [31:0]  inst_if;
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
  wire  [31:0]  rs2_data;
  wire  [31:0]  op2;
  wire  [31:0]  imm_ex;
  wire  [31:0]  rs1_data;
  reg   [31:0]  op1;
  reg   [31:0]  wb_data_o;
  reg   [31:0]  rd_data_o;
  reg   [31:0]  wr_data;
  reg   [31:0]  read_data;
  reg   [31:0]  mem           [0:8095];   //8kB
//=================PIPELINE_REGISTER========================================================================================================================
  if_id_reg_t  if_id_reg, if_id_next;
  id_ex_reg_t  id_ex_reg, id_ex_next;
  ex_mem_reg_t ex_mem_reg, ex_mem_next;
  mem_wb_reg_t mem_wb_reg, mem_wb_next;

  reg [31:0] inst_id_debug;
  reg [31:0] pc_id_debug;

  reg [31:0] inst_ex_debug;
  reg [31:0] pc_ex_debug;
  reg [31:0] rs2_ex_debug;
  reg [31:0] rs1_ex_debug;
  reg [31:0] imm_ex_debug;

  reg [31:0] inst_mem_debug;
  reg [31:0] pc_mem_debug;
  reg [31:0] rs2_mem_debug;
  reg [31:0] alu_mem_debug;
  reg [31:0] inst_wb_debug;

  reg [31:0] pc4_wb_debug;
  reg [31:0] alu_wb_debug;
  reg [31:0] memdata_wb_debug;

  reg id_reg_enb;
  reg ex_reg_enb;
  reg mem_reg_enb;
  reg wb_reg_enb;

  reg ex_rs1_forwarding;
  reg ex_rs2_forwarding;
  reg mem_rs1_forwarding;
  reg mem_rs2_forwarding;
//==================STATE_MACHINE=========================================================================================================================
  typedef enum logic [2:0] {
    IF  = 3'b000,
    ID  = 3'b001,
    EX  = 3'b010,
    MEM = 3'b011,
    WB  = 3'b100
  } phase_t;

  phase_t current_phase, next_phase;

  always_ff @( posedge i_clk ) begin : register_state
    if (~i_reset) begin
      current_phase <= IF;
    end else begin
      current_phase <= next_phase;
    end
  end
// Update the pipeline stage signal in each clock cycle
  always_comb begin
    case (current_phase)
      IF:      next_phase = ID;
      ID:      next_phase = EX;
      EX:      next_phase = MEM;
      MEM:     next_phase = WB;
      WB:      next_phase = IF;
      default: next_phase = IF;
    endcase
  end

//========================================================================================================================================================================
  always_ff @(posedge i_clk) begin : processing_state
    case(current_phase)
      IF: begin
        id_reg_enb  <= 1'b1;
        ex_reg_enb  <= 1'b1;
        mem_reg_enb <= 1'b1;
        wb_reg_enb  <= 1'b1;
      end
      ID: begin
        id_reg_enb  <= 1'b1;
        ex_reg_enb  <= 1'b1;
        mem_reg_enb <= 1'b1;
        wb_reg_enb  <= 1'b1;
      end
      EX: begin
        id_reg_enb  <= 1'b1;
        ex_reg_enb  <= 1'b1;
        mem_reg_enb <= 1'b1;
        wb_reg_enb  <= 1'b1;
      end
      MEM: begin
        id_reg_enb  <= 1'b1;
        ex_reg_enb  <= 1'b1;
        mem_reg_enb <= 1'b1;
        wb_reg_enb  <= 1'b1;
      end
      WB: begin
        id_reg_enb  <= 1'b1;
        ex_reg_enb  <= 1'b1;
        mem_reg_enb <= 1'b1;
        wb_reg_enb  <= 1'b1;
      end
    default: begin
        id_reg_enb  <= 1'b0;
        ex_reg_enb  <= 1'b0;
        mem_reg_enb <= 1'b0;
        wb_reg_enb  <= 1'b0;
    end
    endcase
  end
//==================PC=================================================================================================================================
  always_ff @(posedge i_clk) begin: if_pc_reg
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
//==================IMEM=============================================================================================================================
  initial begin : instruction
    $readmemh("../02_test/isa_4b.hex", mem);
  end

  assign inst_if = mem[o_pc_debug[31:2]];
      //==================ID_STAGE========================================================================================================================
      //==================PC_ID_REGISTER========================================================================================================================
        always_comb begin: if_id_input
          if_id_next.inst = inst_if;
          if_id_next.pc   = o_pc_debug;
        end
        d_ff #(
          .DATA_WIDTH(`IF_ID_WIDTH) // 64
        ) if_id_register (
          .i_clk  (i_clk     ),
          .i_reset(i_reset   ),
          .i_enb  (id_reg_enb),
          .i_q    (if_id_next),
          .o_out  (if_id_reg )
        );

        always_comb begin: if_id_debug
          inst_id_debug = if_id_reg.inst;
          pc_id_debug   = if_id_reg.pc;
        end
      //==================REGFILE============================================================================================================================
        regfile regfile_id (
          .i_clk      (i_clk                    ),
          .i_reset    (i_reset                  ),
          .i_rs1_addr (if_id_reg.inst[`RS1_ADDR]),
          .i_rs2_addr (if_id_reg.inst[`RS2_ADDR]),
          .i_rd_addr  (if_id_reg.inst[`RD_ADDR] ),
          .i_rd_data  (mem_wb_reg.alu_result    ),
          .i_rd_wren  (rd_wren                  ),
          .o_rs1_data (rs1_data                 ),
          .o_rs2_data (rs2_data                 )
          );
      //==================CONTROL_UNIT=========================================================================================================================
        control_unit  control_unit (
          .i_clk      (i_clk),
          .i_reset    (i_reset),
          .instruction(if_id_reg.inst),
          .pc_sel     (pc_sel        ),
          .o_inst_vld (o_insn_vld    ),
          .br_unsign  (br_unsign     ),
          .op1_sel    (op1_sel       ),
          .op2_sel    (op2_sel       ),
          .alu_opcode_ex(alu_op        ),
          .rd_wren    (rd_wren       ),
          .wb_sel     (wb_sel        ),
          .mem_wren   (mem_wren      )
          );
      //==================IMMGEN==================================================================================================================================
        immgen immgen (
        .inst_i (if_id_reg.inst),
        .imm_o  (imm_ex        )
        );
          //==================EX_STAGE========================================================================================================================
            always_comb begin: input_ex_stage_reg
              id_ex_next.inst     = if_id_reg.inst;
              id_ex_next.pc       = if_id_reg.pc;
              id_ex_next.rs1_addr = if_id_reg.inst[`RS1_ADDR];
              id_ex_next.rs2_addr = if_id_reg.inst[`RS2_ADDR];
              id_ex_next.rd_addr  = if_id_reg.inst[`RD_ADDR];
              id_ex_next.imm_ext  = imm_ex;
              if(ex_rs1_forwarding || mem_rs1_forwarding) begin
                id_ex_next.rs1_data = rd_data_o;
                id_ex_next.rs2_data = rs2_data;
              end else if (ex_rs2_forwarding || mem_rs2_forwarding) begin
                id_ex_next.rs1_data = rs1_data;
                id_ex_next.rs2_data = rd_data_o;
              end else begin
                id_ex_next.rs1_data = rs1_data;
                id_ex_next.rs2_data = rs2_data;
              end
            end
            d_ff #(
              .DATA_WIDTH(`ID_EX_WIDTH) // 250
            ) id_ex_register (
              .i_clk  (i_clk     ),
              .i_reset(i_reset   ),
              .i_enb  (ex_reg_enb),
              .i_q    (id_ex_next),
              .o_out  (id_ex_reg )
            );

            always_comb begin: id_ex_debug
              inst_ex_debug = id_ex_reg.inst;
              pc_ex_debug   = id_ex_reg.pc;
              rs1_ex_debug  = id_ex_reg.rs1_data;
              rs2_ex_debug  = id_ex_reg.rs2_data;
              imm_ex_debug  = id_ex_reg.imm_ext;
            end
          //==================BRCOMP=============================================================================================================================
            brcomp branch_compare (
            .i_rs1_data (id_ex_reg.rs1_data),
            .i_rs2_data (id_ex_reg.rs2_data),
            .i_br_un    (br_unsign         ),
            .o_br_less  (br_less           ),
            .o_br_equal (br_equal          )
            );
          //==================OPERATION_1===========================================================================================================================
            always_comb begin : op1_sel_branch
              op1 = id_ex_reg.rs1_data;
              if( id_ex_reg.inst[`OPCODE] == STYPE && op1_sel) begin
                case (id_ex_reg.inst[`FUNC3])
                  3'b000: op1 = ( br_equal                         ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // beq
                  3'b001: op1 = (~br_equal                         ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // bne
                  3'b100: op1 = ( br_less                          ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // blt
                  3'b101: op1 = (~br_less || br_equal              ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // bge > or =
                  3'b110: op1 = ( br_less && br_unsign             ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // bltu
                  3'b111: op1 = (~br_less || br_equal && br_unsign ) ? id_ex_reg.pc : id_ex_reg.rs1_data; // bgeu
                  default:op1 = op1;
                endcase
              end else if (id_ex_reg.inst[`OPCODE] == U1TYPE) begin
                op1 = 32'b0;
              end else if (id_ex_reg.inst[`OPCODE] == U2TYPE) begin
                op1 = id_ex_reg.pc;
              end else begin
                op1 = (op1_sel) ? id_ex_reg.pc : id_ex_reg.rs1_data;
              end
            end
          //==================OPERATION_2===========================================================================================================================
            assign op2 = (op2_sel) ? imm_ex_debug : id_ex_reg.rs2_data;
          //==================ALU=====================================================================================================================================
            alu alu (
            .i_op_a      (op1      ),
            .i_op_b      (op2      ),
            .br_unsign_i (br_unsign),
            .i_alu_op    (alu_op   ),
            .o_alu_data  (rd_data_o)
            );
          //==================EX_FORWARDING===========================================================================================================================
            // occuring when rd in mem stage appear in next inst as rs1/rs2 in ex stage
            // checking if yes: send rd to rs1, no: continue
            always_comb begin : ex_forwarding
              if(id_ex_reg.inst[`RD_ADDR] == if_id_reg.inst[`RS1_ADDR]) begin
                ex_rs1_forwarding = 1'b1;
              end else if (id_ex_reg.inst[`RD_ADDR] == if_id_reg.inst[`RS2_ADDR]) begin
                ex_rs2_forwarding = 1'b1;
              end else begin
                ex_rs1_forwarding = 1'b0;
                ex_rs2_forwarding = 1'b0;
              end
            end
              //==================MEM_STAGE========================================================================================================================
                always_comb begin: input_mem_stage_reg
                  ex_mem_next.inst       = id_ex_reg.inst;
                  ex_mem_next.pc         = id_ex_reg.pc;
                  ex_mem_next.rs2_data   = id_ex_reg.rs2_data;
                  ex_mem_next.alu_result = rd_data_o;
                end
                d_ff #(
                  .DATA_WIDTH(`EX_MEM_WIDTH) // 128
                ) ex_mem_register (
                  .i_clk  (i_clk      ),
                  .i_reset(i_reset    ),
                  .i_enb  (mem_reg_enb),
                  .i_q    (ex_mem_next),
                  .o_out  (ex_mem_reg )
                );

                always_comb begin: ex_mem_debug
                  inst_mem_debug = ex_mem_reg.inst;
                  pc_mem_debug   = ex_mem_reg.pc;
                  rs2_mem_debug  = ex_mem_reg.rs2_data;
                  alu_mem_debug  = ex_mem_reg.alu_result;
                end
              //==================LSU=====================================================================================================================================
                always_comb begin
                  // has rs2's data if stype to store rs2's data to mem
                  wr_data  = 32'b0;
                  if(ex_mem_reg.inst[`OPCODE] == STYPE) begin
                    wr_data = ex_mem_reg.rs2_data;
                  end
                  case (ex_mem_reg.inst[`FUNC3])                            // check func3
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

                lsu lsu (
                          .i_clk      (i_clk                  ),
                          .i_reset    (i_reset                ),
                          .i_lsu_addr (ex_mem_reg.alu_result  ),
                          .i_st_data  (wr_data                ),
                          .i_lsu_wren (mem_wren               ),
                          .i_func3    (ex_mem_reg.inst[`FUNC3]),
                          .i_io_sw    (i_io_sw                ),
                          .o_io_hex0  (o_io_hex0              ),
                          .o_io_hex1  (o_io_hex1              ),
                          .o_io_hex2  (o_io_hex2              ),
                          .o_io_hex3  (o_io_hex3              ),
                          .o_io_hex4  (o_io_hex4              ),
                          .o_io_hex5  (o_io_hex5              ),
                          .o_io_hex6  (o_io_hex6              ),
                          .o_io_hex7  (o_io_hex7              ),
                          .o_ld_data  (read_data              ),
                          .o_io_ledr  (o_io_ledr              ),
                          .o_io_ledg  (o_io_ledg              ),
                          .o_io_lcd   (o_io_lcd               )
                        );
              //==================MEM_FORWARDING===========================================================================================================================
                // occuring when rd in mem stage appear in next inst as rs1/rs2 in ex stage
                // checking if yes: send rd to rs1, no: continue
                always_comb begin : mem_forwarding
                  if(ex_mem_reg.inst[`RD_ADDR] == if_id_reg.inst[`RS1_ADDR]) begin
                    mem_rs1_forwarding = 1'b1;
                  end else if (id_ex_reg.inst[`RD_ADDR] == if_id_reg.inst[`RS2_ADDR]) begin
                    mem_rs2_forwarding = 1'b1;
                  end else begin
                    mem_rs1_forwarding = 1'b0;
                    mem_rs2_forwarding = 1'b0;
                  end
                end
                  //==================WB_STAGE========================================================================================================================
                    pc_reg PC_wb_plus4 (
                      .pc_reg(ex_mem_reg.pc),
                      .pc_o(mem_wb_next.pc4)
                    );
                    always_comb begin: input_wb_stage_reg
                      mem_wb_next.inst       = ex_mem_reg.inst;
                      mem_wb_next.rs2_data   = ex_mem_reg.rs2_data;
                      mem_wb_next.alu_result = ex_mem_reg.alu_result;
                      mem_wb_next.read_data  = read_data;
                    end
                    d_ff #(
                      .DATA_WIDTH(`MEM_WB_WIDTH) // 128
                    ) mem_wb_register (
                      .i_clk  (i_clk      ),
                      .i_reset(i_reset    ),
                      .i_enb  (wb_reg_enb ),
                      .i_q    (mem_wb_next),
                      .o_out  (mem_wb_reg )
                    );

                    always_comb begin: mem_wb_debugger
                      inst_wb_debug    = mem_wb_reg.inst;
                      pc4_wb_debug     = mem_wb_reg.pc4;
                      alu_wb_debug     = mem_wb_reg.alu_result;
                      memdata_wb_debug = mem_wb_reg.read_data;
                    end
                  //==================REGFILE============================================================================================================================
                    regfile regfile_wb (
                      .i_clk      (i_clk                    ),
                      .i_reset    (i_reset                  ),
                      .i_rs1_addr (mem_wb_reg.inst[`RS1_ADDR]),
                      .i_rs2_addr (mem_wb_reg.inst[`RS2_ADDR]),
                      .i_rd_addr  (mem_wb_reg.inst[`RD_ADDR] ),
                      .i_rd_data  (mem_wb_reg.alu_result    ),
                      .i_rd_wren  (rd_wren                  ),
                      .o_rs1_data (rs1_data                 ),
                      .o_rs2_data (rs2_data                 )
                      );
                  //==================WRITEBACK=============================================================================================================================
                    always_comb begin : write_back
                      wb_data_o = 32'b0;
                      jmp_pc    = 32'b0;
                      case (wb_sel)
                        2'b00: begin
                          wb_data_o   = ((mem_wb_reg.inst[`RD_ADDR]) == 5'b00000) ? 32'b0 : mem_wb_reg.alu_result; // hardwire x0
                          jmp_pc = 32'b0;
                        end
                        2'b01: begin  : pc_jump
                          jmp_pc = 32'b0;
                          case (mem_wb_reg.inst[`FUNC3])
                            3'b000: jmp_pc = ( br_equal)                         ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // beq
                            3'b001: jmp_pc = (~br_equal)                         ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // bne
                            3'b100: jmp_pc = ( br_less)                          ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // blt
                            3'b101: jmp_pc = (~br_less || br_equal)              ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // bge
                            3'b110: jmp_pc = ( br_less && br_unsign)             ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // bltu
                            3'b111: jmp_pc = (~br_less || br_equal && br_unsign) ? mem_wb_reg.alu_result : (mem_wb_reg.pc4); // bgeu
                            default:jmp_pc = mem_wb_reg.alu_result; // For JALR
                          endcase
                        end
                        2'b10: begin
                          wb_data_o = mem_wb_reg.pc4;
                          jmp_pc    = mem_wb_reg.alu_result;
                        end
                        2'b11:   wb_data_o = mem_wb_reg.read_data;
                        default: wb_data_o = 32'b0;
                      endcase
                    end
endmodule
