//===========================================================================================================
// Project         : Single Cycle Pipeline of RISV - V
// Module          : Single Cycle Pipeline
// File            : pipeline_core.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 26/11/2025
// Updated date    : 26/11/2025
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
  reg  [2:0] current_stage, next_stage;
  reg   [31:0]  inst;
  reg   [31:0]  inst_next;
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
//==================STRUCT=============================================================================================================
  typedef logic [31:0] word_t;
  typedef logic [4:0]  addr_t;

  typedef struct packed {
    word_t      pc;
    word_t      inst;
  } if_id_reg_t;

  typedef struct packed {
    word_t      pc;
    word_t      inst;
    word_t      rs1_data;
    word_t      rs2_data;
    word_t      imm_ext;

    addr_t      rs1_addr;
    addr_t      rs2_addr;
    addr_t      rd_addr;
    // Control Signals
    logic       alu_src;
    logic [3:0] alu_op;
    logic       mem_write;
    logic       mem_read;
    logic       reg_write;
  } id_ex_reg_t;

  typedef struct packed {
    word_t      pc;
    word_t      inst;
    word_t      alu_result;
    word_t      rs2_data;

    addr_t      rd_addr;

    // Control Signals
    logic       mem_write;
    logic       mem_read;
    logic       reg_write;
  } ex_mem_reg_t;

  typedef struct packed {
    word_t      pc4;
    word_t      alu_result;
    word_t      rs2_data;    // Dữ liệu để ghi vào Mem (Store)
    word_t      inst;
    word_t      read_data;

    // Control Signals (chỉ giữ lại cái cần cho MEM và WB)
    logic       mem_write;
    logic       mem_read;
    logic       reg_write;
  } mem_wb_reg_t;
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
  // Define the stages of the pipeline
  parameter IF = 3'b000, ID  = 3'b001,
            EX = 3'b010, MEM = 3'b011,
            WB = 3'b100;

  always_ff @( posedge i_clk ) begin : register_state
    if (~i_reset) begin
      current_stage <= IF;
    end else begin
      current_stage <= next_stage;
    end
  end
// Update the pipeline stage signal in each clock cycle
  always_comb begin
    case (current_stage)
      IF:      next_stage = ID;
      ID:      next_stage = EX;
      EX:      next_stage = MEM;
      MEM:     next_stage = WB;
      WB:      next_stage = IF;
      default: next_stage = IF;
    endcase
  end
//==================PC=================================================================================================================================
  always_ff @(posedge i_clk) begin: pc_reg
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

  assign inst = mem[o_pc_debug[31:2]];

  d_ff #(
    .DATA_WIDTH(`IF_ID_WIDTH) // 64
  ) if_id_register (
    .i_clk  (i_clk     ),
    .i_reset(i_reset   ),
    .i_enb  (1'b1      ),
    .i_q    (if_id_next),
    .o_out  (if_id_reg )
  );
//========================================================================================================================================================================
  always_comb begin : processing_state
    if (current_stage) begin
      IF: begin
        if_id_next.inst = inst;
        if_id_next.pc   = o_pc_debug;
          d_ff #(
        .DATA_WIDTH(`IF_ID_WIDTH) // 64
      ) if_id_register (
        .i_clk  (i_clk     ),
        .i_reset(i_reset   ),
        .i_enb  (1'b1      ),
        .i_q    (if_id_next),
        .o_out  (if_id_reg )
      );
      end
      // ID: begin
        
      // end
      // EX: begin
        
      // end
      // MEM: begin
        
      // end
      // WB: begin
        
      // end
      // default: 
    end
  end
endmodule
// always_ff @(posedge i_clk) begin
//     if (i_reset) begin
//        $display("RESETING");
//     end else begin
//       // Chỉ in ra giai đoạn hiện tại
//       case (current_stage)
//           IF:  $display("Pipeline is in IF stage at time %t", $time);
//           ID:  $display("Pipeline is in ID stage at time %t", $time);
//           EX:  $display("Pipeline is in EX stage at time %t", $time);
//           MEM: $display("Pipeline is in MEM stage at time %t", $time);
//           WB:  $display("Pipeline is in WB stage at time %t", $time);
//           default: $display("Pipeline is in unknown stage at time %t", $time);
//       endcase
//     end
// end
