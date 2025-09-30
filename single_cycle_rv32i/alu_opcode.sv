//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : ALU Opcode
// File            : alu_opcode.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 12/9/2025
//===========================================================================================
parameter RTYPE  = 7'b0110011;
parameter ITYPE  = 7'b0010011;
parameter IITYPE = 7'b1100111;
parameter ILTYPE = 7'b0000011;
parameter IJTYPE = 7'b1101111;
parameter STYPE  = 7'b0100011;
parameter BTYPE  = 7'b1100011;
parameter U1TYPE = 7'b0110111;
parameter U2TYPE = 7'b0010111;
module alu_opcode (
  input wire   [31:0] instruction,
  output reg   [3:0]  alu_opcode
);
  wire is_add, is_sub, is_and, is_or, is_xor, is_slt, is_sltu, is_sra, is_srl, is_sll;
  wire is_addi, is_xori, is_ori, is_andi, is_slli, is_srli, is_srai, is_slti, is_sltiu;
  wire is_lb, is_lh, is_lw, is_lbu, is_lhu;
  wire is_sb, is_sh, is_sw;
  wire is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu;
  wire is_jal, is_jalr;
  wire is_lui, is_auipc;
//==========================RTYPE=========================================================================
  //is_add
  assign is_add   = ~instruction[12] & ~instruction[13] & ~instruction[14] & ~instruction[30];
  //is_sub
  assign is_sub   = ~instruction[12] & ~instruction[13] & ~instruction[14] & instruction[30];
  //is_sll
  assign is_sll   = instruction[12] & ~instruction[13] & ~instruction[14];
  //is_slt
  assign is_slt   = ~instruction[12] & instruction[13] & ~instruction[14];
  //is_sltu
  assign is_sltu  = instruction[12] & instruction[13] & ~instruction[14];
  //is_xor
  assign is_xor   = ~instruction[12] & ~instruction[13] & instruction[14];
  //is_sra
  assign is_sra   = instruction[12] & ~instruction[13] & instruction[14] & instruction[30];
  //is_srl
  assign is_srl   = instruction[12] & ~instruction[13] & instruction[14] & ~instruction[30];
  //is_or
  assign is_or    = ~instruction[12] & instruction[13] & instruction[14];
  //is_and
  assign is_and   =  instruction[12] & instruction[13] & instruction[14];
//==========================ITYPE=========================================================================
  //is_addi
  assign is_addi  = ~instruction[12] & ~instruction[13] & ~instruction[14];
  //is_sll
  assign is_slli  = instruction[12] & ~instruction[13] & ~instruction[14];
  //is_slt
  assign is_slti  = ~instruction[12] & instruction[13] & ~instruction[14];
  //is_sltiu
  assign is_sltiu = instruction[12] & instruction[13] & ~instruction[14];
  //is_xori
  assign is_xori  = ~instruction[12] & ~instruction[13] & instruction[14];
  //is_srai
  assign is_srai  = instruction[12] & ~instruction[13] & instruction[14] & instruction[30];
  //is_srli
  assign is_srli  = instruction[12] & ~instruction[13] & instruction[14] & ~instruction[30];
  //is_ori
  assign is_ori   = ~instruction[12] & instruction[13] & instruction[14];
  //is_andi
  assign is_andi  =  instruction[12] & instruction[13] & instruction[14];
//==========================ILTYPE=========================================================================
  //is_lb
  assign is_lb    = ~instruction[12] & ~instruction[13] & ~instruction[14];
  //is_lh
  assign is_lh    = instruction[12] & ~instruction[13] & ~instruction[14];
  //is_lw
  assign is_lw    = ~instruction[12] & instruction[13] & ~instruction[14];
  //is_lbu
  assign is_lbu   = ~instruction[12] & ~instruction[13] & instruction[14];
  //is_lhu
  assign is_lhu   = instruction[12] & ~instruction[13] & instruction[14];
//==========================STYPE=========================================================================
  //is_sb
  assign is_sb    = ~instruction[12] & ~instruction[13] & ~instruction[14];
  //is_sh
  assign is_sh    = instruction[12] & ~instruction[13] & ~instruction[14];
  //is_sw
  assign is_sw    = ~instruction[12] & instruction[13] & ~instruction[14];
//==========================BTYPE=========================================================================
  //is_beq
  assign is_beq  = ~instruction[12] & ~instruction[13] & ~instruction[14];
  //is_bne
  assign is_bne  = instruction[12] & ~instruction[13] & ~instruction[14];
   //is_blt
  assign is_blt  = ~instruction[12] & ~instruction[13] & instruction[14];
  //is_bge
  assign is_bge  = instruction[12] & ~instruction[13] & instruction[14];
  //is_bltu
  assign is_bltu = ~instruction[12] & instruction[13] & instruction[14];
  //is_bgeu
  assign is_bgeu = instruction[12] & instruction[13] & instruction[14];
//==========================CASE=========================================================================
  always_comb begin
    case (instruction[6:0])
      RTYPE: case (1'b1)
              is_add  : alu_opcode = 4'b0000;
              is_sub  : alu_opcode = 4'b0001;
              is_sll  : alu_opcode = 4'b0010;
              is_slt  : alu_opcode = 4'b0011;
              is_sltu : alu_opcode = 4'b0100;
              is_xor  : alu_opcode = 4'b0101;
              is_sra  : alu_opcode = 4'b0110;
              is_srl  : alu_opcode = 4'b0111;
              is_or   : alu_opcode = 4'b1000;
              is_and  : alu_opcode = 4'b1001;
              default : alu_opcode = 4'b0000;
            endcase
      ITYPE: case (1'b1)
              is_addi  : alu_opcode = 4'b0000;
              is_slli  : alu_opcode = 4'b0001;
              is_slti  : alu_opcode = 4'b0010;
              is_sltiu : alu_opcode = 4'b0011;
              is_xori  : alu_opcode = 4'b0100;
              is_srli  : alu_opcode = 4'b0101;
              is_srai  : alu_opcode = 4'b0110;
              is_ori   : alu_opcode = 4'b0111;
              is_andi  : alu_opcode = 4'b1000;
              default  : alu_opcode = 4'b0000;
            endcase
      ILTYPE: case (1'b1)
              is_lb   : alu_opcode = 4'b0000;
              is_lh   : alu_opcode = 4'b0001;
              is_lw   : alu_opcode = 4'b0010;
              is_lbu  : alu_opcode = 4'b0011;
              is_lhu  : alu_opcode = 4'b0100;
              default : alu_opcode = 4'b0000;
            endcase
      STYPE: case (1'b1)
              is_sb   : alu_opcode = 4'b0000;
              is_sh   : alu_opcode = 4'b0001;
              is_sw   : alu_opcode = 4'b0010;
              default : alu_opcode = 4'b0000;
            endcase
      BTYPE: case (1'b1)
              is_beq  : alu_opcode = 4'b0000;
              is_bne  : alu_opcode = 4'b0001;
              is_blt  : alu_opcode = 4'b0010;
              is_bge  : alu_opcode = 4'b0011;
              is_bltu : alu_opcode = 4'b0100;
              is_bgeu : alu_opcode = 4'b0101;
              default : alu_opcode = 4'b0000;
            endcase
      IJTYPE: case (1'b1)
              is_jal  : alu_opcode = 4'b0000;
              default : alu_opcode = 4'b0000;
            endcase
      IITYPE: case (1'b1)
              is_jalr : alu_opcode = 4'b0000;
              default : alu_opcode = 4'b0000;
            endcase
      U1TYPE: alu_opcode = 4'b0000;
      U2TYPE: alu_opcode = 4'b0000;
      default: alu_opcode = 4'b0000;
    endcase
end

endmodule

