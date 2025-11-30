//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Control Unit
// File            : control_unit.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 13/9/2025
// Updated date    : 6/11/2025 - Finished
//=============================================================================================================
import package_param::*;
module control_unit (
  input  wire         i_clk,
  input  wire         i_reset,
  input  wire  [31:0] instruction,
  output reg          pc_sel,
  output reg          o_inst_vld,
  output reg          br_unsign,
  output reg          op1_sel,
  output reg          op2_sel,
  output reg  [3:0]   alu_opcode_ex,
  output reg          rd_wren,
  output reg  [1:0]   wb_sel,
  output reg          mem_wren
);
//===================================DECLARATION==================================================
  wire is_add, is_sub, is_and, is_or, is_xor, is_slt, is_sltu, is_sra, is_srl, is_sll, is_mul;
  wire is_addi, is_xori, is_ori, is_andi, is_slli, is_srli, is_srai, is_slti, is_sltiu;
  wire is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu;
  wire [31:0] pc_addr, rs1_data, rs2_data;
  wire [10:0] rtype;
  wire [8:0] itype;
  wire [4:0] iltype;
  wire [2:0] stype;
  wire [5:0] btype;
  reg [3:0] alu_opcode_id;
  typedef enum logic [2:0] {
    IF  = 3'b000,
    ID  = 3'b001,
    EX  = 3'b010,
    MEM = 3'b011,
    WB  = 3'b100
  } state_t;

  state_t current_phase, next_phase;

//====================================STATE MACHINE===============================================
always_ff @(posedge i_clk) begin
  if (~i_reset) begin
    current_phase <= IF;
  end else begin
    current_phase <= next_phase;
  end
end

//==================================STATE TRANSITIONS============================================
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

//==================================CONTROL SIGNALS BASED ON STATE=============================
always_ff @(posedge i_clk) begin
  if (~i_reset) begin
    alu_opcode_ex <= 4'b0000;
    pc_sel        <= 1'b0;
    rd_wren <= 1'b1;
    op1_sel <= 1'b0;  //rs1
    op2_sel <= 1'b0;  //rs2;
    wb_sel   <= 2'b00;
  end else begin
    case (current_phase)
      IF: begin       // control pc_sel
        pc_sel        <= 1'b0;
        alu_opcode_ex <= 4'b0000;
        wb_sel   <= 2'b00;
      end
      ID: begin       // control reg_wren
        pc_sel        <= 1'b0;
        wb_sel   <= 2'b00;
        case (alu_opcode_id)
          4'b0000: alu_opcode_ex <= 4'b0000;
          4'b0001: alu_opcode_ex <= 4'b0001;
          4'b0010: alu_opcode_ex <= 4'b0010;
          4'b0011: alu_opcode_ex <= 4'b0011;
          4'b0100: alu_opcode_ex <= 4'b0100;
          4'b0101: alu_opcode_ex <= 4'b0101;
          4'b0110: alu_opcode_ex <= 4'b0110;
          4'b0111: alu_opcode_ex <= 4'b0111;
          4'b1000: alu_opcode_ex <= 4'b1000;
          4'b1001: alu_opcode_ex <= 4'b1001;
          default: alu_opcode_ex <= 4'b0000;
        endcase

      case (instruction[6:0])
        RTYPE: begin                     // opcode rd, r1, r2
          op1_sel <= 1'b0;  //rs1
          op2_sel <= 1'b0;  //rs2;
        end
        ITYPE: begin
          op1_sel <= 1'b0;  // rs1
          op2_sel <= 1'b1;  // imm
        end
        ILTYPE: begin
          op1_sel <= 1'b0;  // rs1
          op2_sel <= 1'b1;  // imm_ex;
        end
        BTYPE: begin
          op1_sel <= 1'b1;    // pc
          op2_sel <= 1'b1;    // imm
        end
        STYPE: begin
          op1_sel <= 1'b0; // rs1
          op2_sel <= 1'b1; // imm
        end
        IJTYPE: begin
          op1_sel <= 1'b1;  // pc
          op2_sel <= 1'b1;  // imm
        end
        IITYPE: begin
          op1_sel <= 1'b0;  // rs1
          op2_sel <= 1'b1;  // imm
        end
        U1TYPE,
        U2TYPE: begin
          op1_sel <= 1'b0;
          op2_sel <= 1'b1;  // imm
        end
        default: begin
          op1_sel <= 1'b0; // rs1_data
          op2_sel <= 1'b0; // rs2_data
        end
      endcase
      end
      EX: begin       // control alu_src, alu_op, alu_control, zero (for no branch predict)
        pc_sel        <= 1'b0;
        wb_sel   <= 2'b00;
        case (alu_opcode_id)
          4'b0000: alu_opcode_ex <= 4'b0000;
          4'b0001: alu_opcode_ex <= 4'b0001;
          4'b0010: alu_opcode_ex <= 4'b0010;
          4'b0011: alu_opcode_ex <= 4'b0011;
          4'b0100: alu_opcode_ex <= 4'b0100;
          4'b0101: alu_opcode_ex <= 4'b0101;
          4'b0110: alu_opcode_ex <= 4'b0110;
          4'b0111: alu_opcode_ex <= 4'b0111;
          4'b1000: alu_opcode_ex <= 4'b1000;
          4'b1001: alu_opcode_ex <= 4'b1001;
          default: alu_opcode_ex <= 4'b0000;
        endcase
      end
      MEM: begin      // brach predict, mem_wren, mem_read
        alu_opcode_ex <= 4'b0000;
        pc_sel        <= 1'b0;
        wb_sel   <= 2'b00;
      end
      WB: begin       // contrl MemToReg
        alu_opcode_ex <= 4'b0000;
        case (instruction[`OPCODE])
          RTYPE: begin                     // opcode rd, r1, r2
            rd_wren <= 1'b1;
            wb_sel   <= 2'b00; // rd
            pc_sel <= 1'b0;  // pc + 4
          end
          ITYPE: begin
            rd_wren <= 1'b1;
            wb_sel   <= 2'b00; // rd
            pc_sel <= 1'b0;  // pc + 4
          end
          ILTYPE: begin
            rd_wren <= 1'b1;
            wb_sel   <= 2'b11; // read_data
            pc_sel <= 1'b0;  // pc + 4
          end
          BTYPE: begin
            wb_sel   <= 2'b01;   //jmp_pc
            rd_wren <= 1'b0;
            pc_sel <= 1'b1;    // jmp_pc
          end
          STYPE: begin
            pc_sel <= 1'b0; // pc + 4
            rd_wren <= 1'b0;
          end
          IJTYPE: begin
            rd_wren <= 1'b1;
            wb_sel  <= 2'b10; // pc = rs1 + imm
            pc_sel <= 1'b1;  // jmp_pc
          end
          IITYPE: begin
            rd_wren <= 1'b1;
            wb_sel  <= 2'b10; // pc = rs1 + imm
            pc_sel <= 1'b1;  // jmp_pc
          end
          U1TYPE,
          U2TYPE: begin
            rd_wren <= 1'b1;
            wb_sel   <= 2'b00; // rd
            pc_sel <= 1'b0;  // pc + 4
          end
          default: begin
            wb_sel   <= 2'b00; // rd
            rd_wren <= 1'b1;
            pc_sel <= 1'b0;
          end
        endcase
      end
      default: begin

      end
    endcase
  end
end

//==========================RTYPE=========================================================================
  always_comb begin : inst_valid
    case(instruction[6:0])
      RTYPE,
      ITYPE,
      ILTYPE,
      STYPE,
      BTYPE,
      IJTYPE,
      U1TYPE,
      U2TYPE: o_inst_vld = 1'b1;
      default: o_inst_vld = 1'b0;
    endcase
  end
//==========================RTYPE=========================================================================
  //is_mul
  assign is_mul   = ~instruction[12] & ~instruction[13] & ~instruction[14] & instruction[25];
  //is_add
  assign is_add   = ~instruction[12] & ~instruction[13] & ~instruction[14] & ~instruction[30] & ~instruction[25];
  //is_sub
  assign is_sub   = ~instruction[12] & ~instruction[13] & ~instruction[14] &  instruction[30] & ~instruction[25];
  //is_sll
  assign is_sll   =  instruction[12] & ~instruction[13] & ~instruction[14];
  //is_slt
  assign is_slt   = ~instruction[12] & instruction[13]  & ~instruction[14];
  //is_sltu
  assign is_sltu  =  instruction[12] & instruction[13]  & ~instruction[14];
  //is_xor
  assign is_xor   = ~instruction[12] & ~instruction[13] &  instruction[14];
  //is_sra
  assign is_sra   =  instruction[12] & ~instruction[13] &  instruction[14]  &  instruction[30];
  //is_srl
  assign is_srl   =  instruction[12] & ~instruction[13] &  instruction[14]  & ~instruction[30];
  //is_or
  assign is_or    = ~instruction[12] & instruction[13]  &  instruction[14];
  //is_and
  assign is_and   =  instruction[12] & instruction[13]  &  instruction[14];
  // concatenat
  assign rtype = {is_add, is_sub, is_sll, is_slt, is_sltu, is_xor, is_srl, is_sra, is_or, is_and, is_mul};
//==========================ITYPE=========================================================================
  //is_addi
  assign is_addi  = ~instruction[12] & ~instruction[13] & ~instruction[14] & ~instruction[25];
  //is_sll
  assign is_slli  =  instruction[12] & ~instruction[13] & ~instruction[14];
  //is_slt
  assign is_slti  = ~instruction[12] & instruction[13]  & ~instruction[14];
  //is_sltiu
  assign is_sltiu =  instruction[12] & instruction[13]  & ~instruction[14];
  //is_xori
  assign is_xori  = ~instruction[12] & ~instruction[13] &  instruction[14];
  //is_srai
  assign is_srai  =  instruction[12] & ~instruction[13] &  instruction[14]  & instruction[30];
  //is_srli
  assign is_srli  =  instruction[12] & ~instruction[13] &  instruction[14]  & ~instruction[30];
  //is_ori
  assign is_ori   = ~instruction[12] & instruction[13]  &  instruction[14];
  //is_andi
  assign is_andi  =  instruction[12] & instruction[13]  &  instruction[14];
  // concat
  assign itype = {is_addi, is_slli, is_slti, is_sltiu, is_xori, is_srli, is_srai, is_ori, is_andi};
//==========================BTYPE=========================================================================
  //is_beq
  assign is_beq  = ~instruction[12] & ~instruction[13] & ~instruction[14] & ~instruction[25];
  //is_bne
  assign is_bne  =  instruction[12] & ~instruction[13] & ~instruction[14];
   //is_blt
  assign is_blt  = ~instruction[12] & ~instruction[13] &  instruction[14];
  //is_bge
  assign is_bge  =  instruction[12] & ~instruction[13] &  instruction[14];
  //is_bltu
  assign is_bltu = ~instruction[12] & instruction[13]  &  instruction[14];
  //is_bgeu
  assign is_bgeu =  instruction[12] & instruction[13]  &  instruction[14];
  // concat
  assign btype = {is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu};
//==========================ALU_OPCODE_id=========================================================================
  always_comb begin : signal_sel
    br_unsign   = 1'b1;
    // wb_sel      = 2'b00;
    // rd_wren     = ( instruction[6:0] == STYPE  ||
    //                 instruction[6:0] == BTYPE   )  ? 1'b0 : 1'b1;
    mem_wren    = ( instruction[6:0] == STYPE)     ? 1'b1 : 1'b0;
    case (instruction[6:0])
      RTYPE: case (rtype)
              11'b10000000000 : alu_opcode_id = 4'b0000;  // add
              11'b01000000000 : alu_opcode_id = 4'b0001;  // sub
              11'b00100000000 : alu_opcode_id = 4'b0010;  // sll
              11'b00010000000 : alu_opcode_id = 4'b0011;  // slt
              11'b00001000000 : alu_opcode_id = 4'b0100;  // sltu
              11'b00000100000 : alu_opcode_id = 4'b0101;  // xor
              11'b00000010000 : alu_opcode_id = 4'b0110;  // srl
              11'b00000001000 : alu_opcode_id = 4'b0111;  // sra
              11'b00000000100 : alu_opcode_id = 4'b1000;  // or
              11'b00000000010 : alu_opcode_id = 4'b1001;  // and
              11'b00000000001 : alu_opcode_id = 4'b1010;  // mul
              default         : alu_opcode_id = 4'b0000;
            endcase
      ITYPE: case (itype)
              9'b100000000   : begin
                alu_opcode_id = 4'b0000;   // addi
                br_unsign  = 1'b0;
              end
              9'b010000000   : alu_opcode_id = 4'b0010;  // slli
              9'b001000000   : alu_opcode_id = 4'b0011;  // slti
              9'b000100000   : alu_opcode_id = 4'b0100;  // sltiu
              9'b000010000   : alu_opcode_id = 4'b0101;  // xori
              9'b000001000   : alu_opcode_id = 4'b0110;  // srli
              9'b000000100   : begin
                alu_opcode_id = 4'b0111;                 // is_srai
                br_unsign  = 1'b0;
              end
              9'b000000010   : alu_opcode_id = 4'b1000;   // ori
              9'b000000001   : alu_opcode_id = 4'b1001;   // andi
              default        : alu_opcode_id = 4'b0000;
            endcase
      ILTYPE,
      STYPE:              alu_opcode_id = 4'b0000;    // alu using add
      BTYPE: case (btype)
              6'b100000  : begin                       // beq
                alu_opcode_id = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b010000 : begin                        // bne
                alu_opcode_id = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b001000 : begin                        // blt
                alu_opcode_id = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b000100: begin                         // bge
                alu_opcode_id = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b000010: begin
                alu_opcode_id = 4'b0000;         // bltu
                br_unsign  = 1'b1;
                end
              6'b000001: begin
                alu_opcode_id = 4'b0000;
                br_unsign  = 1'b1;
                end
              default  : alu_opcode_id = 4'b0000;
            endcase
      IJTYPE:            alu_opcode_id = 4'b0000;
      IITYPE:            alu_opcode_id = 4'b0000;
      U1TYPE:            alu_opcode_id = 4'b0000;         // lui using imm + 0
      U2TYPE:            alu_opcode_id = 4'b0000;         // auipc using pc + imm
      default:           alu_opcode_id = 4'b0000;
    endcase
//==================================WRITE_BACK===============================================
  case (instruction[6:0])
    RTYPE: begin                     // opcode rd, r1, r2
      // wb_sel   = 2'b00; // rd
      // pc_sel   = 1'b0;  // pc + 4
      // op1_sel  = 1'b0;  //rs1
      // op2_sel  = 1'b0;  //rs2;
    end
    ITYPE: begin
      // wb_sel   = 2'b00; // rd
      // pc_sel   = 1'b0;  // pc + 4
      // op1_sel  = 1'b0;  // rs1
      // op2_sel  = 1'b1;  // imm
    end
    ILTYPE: begin
      // wb_sel   = 2'b11; // read_data
      // pc_sel   = 1'b0;  // pc + 4
      // op1_sel  = 1'b0;  // rs1
      // op2_sel  = 1'b1;  // imm_ex;
    end
    BTYPE: begin
      // wb_sel   = 2'b01;   //jmp_pc
      // pc_sel   = 1'b1;    // jmp_pc
      // op1_sel  = 1'b1;    // pc
      // op2_sel  = 1'b1;    // imm
    end
    STYPE: begin
      // op1_sel  = 1'b0; // rs1
      // op2_sel  = 1'b1; // imm
      // pc_sel   = 1'b0; // pc + 4
      mem_wren = 1'b1;
    end
    IJTYPE: begin
      // wb_sel  = 2'b10; // rd = pc +4
      // pc_sel  = 1'b1;  // jmp_pc
      // op1_sel = 1'b1;  // pc
      // op2_sel = 1'b1;  // imm
    end
    IITYPE: begin
      // wb_sel  = 2'b10; // pc = rs1 + imm
      // pc_sel  = 1'b1;  // jmp_pc
      // op1_sel = 1'b0;  // rs1
      // op2_sel = 1'b1;  // imm
    end
    U1TYPE,
    U2TYPE: begin
      // wb_sel  = 2'b00; // rd
      // pc_sel  = 1'b0;  // pc + 4
      // op1_sel = 1'b0;
      // op2_sel = 1'b1;  // imm
    end
    default: begin
      // op1_sel = 1'b0; // rs1_data
      // op2_sel = 1'b0; // rs2_data
      // pc_sel  = 1'b0;
      // wb_sel  = 2'b00;
    end
  endcase
end
endmodule
