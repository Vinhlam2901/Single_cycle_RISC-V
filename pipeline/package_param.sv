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

   `define OPCODE    6:0
   `define RD_ADDR  11:7
   `define FUNC3    14:12
   `define RS1_ADDR 19:15
   `define RS2_ADDR 24:20
   `define FUNC7    31:25
   `define IF_ID_WIDTH  64
   `define ID_EX_WIDTH  250
   `define EX_MEM_WIDTH 128
   `define MEM_WB_WIDTH 128
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
  } id_ex_reg_t;

  typedef struct packed {
    word_t      pc;
    word_t      inst;
    word_t      alu_result;
    word_t      rs2_data;

    addr_t      rd_addr;
  } ex_mem_reg_t;

  typedef struct packed {
    word_t      pc4;
    word_t      alu_result;
    word_t      rs2_data;    // Dữ liệu để ghi vào Mem (Store)
    word_t      inst;
    word_t      read_data;
  } mem_wb_reg_t;
endpackage
