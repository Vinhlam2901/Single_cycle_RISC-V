package package_param;
   parameter RTYPE  = 7'b0110011;
   parameter ITYPE  = 7'b0010011;
   parameter IITYPE = 7'b1100111;
   parameter ILTYPE = 7'b0000011;
   parameter IJTYPE = 7'b1101111;
   parameter STYPE  = 7'b0100011;
   parameter BTYPE  = 7'b1100011;
   parameter U1TYPE = 7'b0110111;
   parameter U2TYPE = 7'b0010111;

   parameter int WIDTH = 32;

   `define OPCODE       6:0
   `define RD_ADDR      11:7
   `define FUNC3        14:12
   `define RS1_ADDR     19:15
   `define RS2_ADDR     24:20
   `define FUNC7        31:25
   `define IF_ID_WIDTH  64
   `define ID_EX_WIDTH  250
   `define EX_MEM_WIDTH 128
   `define MEM_WB_WIDTH 128
//==================STRUCT=============================================================================================================
  typedef logic [31:0] word_t;
  typedef logic [4:0]  addr_t;

  typedef struct packed {
    word_t  pc;
    word_t  inst;
    logic   o_insn_vld;
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

    logic       o_insn_vld;
    logic [3:0] alu_opcode;
    logic       br_unsign;
    logic       op1_sel;
    logic       op2_sel;    // alu_src
    logic       mem_wren;
    logic       mem_rden;
    logic       branch_signal;
    logic       jmp_signal;
    logic       rd_wren;
    logic [1:0] mem_to_reg;
  } id_ex_reg_t;

  typedef struct packed {
    word_t      pc;
    word_t      inst;
    word_t      alu_result;
    word_t      rs2_data;

    addr_t      rd_addr;

    logic       o_insn_vld;
    logic       mem_wren;
    logic       mem_rden;
    logic       branch_signal;
    logic       jmp_signal;

    logic       rd_wren;
    logic [1:0] mem_to_reg;
  } ex_mem_reg_t;

  typedef struct packed {
    word_t      pc4;
    word_t      alu_result;
    word_t      rs2_data;
    word_t      inst;
    word_t      read_data;

    addr_t      rd_addr;

    logic       o_insn_vld;
    logic       rd_wren;
    logic [1:0] mem_to_reg;
  } mem_wb_reg_t;
endpackage

/*
Trong module top-level, tại giai đoạn EX
  1. Lấy cờ Zero từ ALU (hoặc bộ so sánh)
  Hoặc dùng module brcomp của bạn trả về br_equal / br_less
  2. Tính toán PC Src (Logic tổ hợp)
  Lệnh là Branch VÀ Thỏa mãn điều kiện (Zero/Equal)
  wire branch_taken = id_ex_reg.branch && br_equal; 
  Có phải nhảy không? (Branch Taken HOẶC Jump Unconditional)
  assign o_pc_src = branch_taken || id_ex_reg.jump;
  3. Tính địa chỉ đích (Target Address)
  Thường là PC + Imm (đã tính ở ID hoặc tính tại EX bằng Adder riêng)
  assign branch_target_addr = id_ex_reg.pc + id_ex_reg.imm_ext;
  4. Xử lý Flush (Nếu o_pc_src == 1)
  always_comb begin
      if (o_pc_src) begin
          flush_en = 1'b1;      // Xóa lệnh đang ở IF và ID
          next_pc_mux = branch_target_addr; // Cập nhật PC
      end else begin
          ...
      end
  end
*/