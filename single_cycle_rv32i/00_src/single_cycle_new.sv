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
endpackage

import package_param::*;
module control_unit (
  input  wire  [31:0] instruction,
  output reg          pc_sel,
  output reg          o_inst_vld,
  output reg          br_unsign,
  output reg          op1_sel,
  output reg          op2_sel,
  output reg  [3:0]   alu_opcode,
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
  assign is_sub   = ~instruction[12] & ~instruction[13] & ~instruction[14] & instruction[30];
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
  assign is_beq  = ~instruction[12]  & ~instruction[13] & ~instruction[14];
  //is_bne
  assign is_bne  =  instruction[12]  & ~instruction[13] & ~instruction[14];
   //is_blt
  assign is_blt  = ~instruction[12]  & ~instruction[13] &  instruction[14];
  //is_bge
  assign is_bge  =  instruction[12]  & ~instruction[13] &  instruction[14];
  //is_bltu
  assign is_bltu = ~instruction[12]  & instruction[13]  &  instruction[14];
  //is_bgeu
  assign is_bgeu =  instruction[12]  & instruction[13]  &  instruction[14];
  // concat
  assign btype = {is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu};
//==========================ALU_OPCODE=========================================================================
  always_comb begin : signal_sel
    br_unsign   = 1'b1;
    wb_sel      = 2'b00;
    pc_sel      = 1'b0;
    rd_wren     = ( instruction[6:0] == STYPE  ||
                    instruction[6:0] == BTYPE   )  ? 1'b0 : 1'b1;
    mem_wren    = ( instruction[6:0] == STYPE)     ? 1'b1 : 1'b0;
    case (instruction[6:0])
      RTYPE: case (rtype)
              11'b10000000000 : alu_opcode = 4'b0000;  // add
              11'b01000000000 : alu_opcode = 4'b0001;  // sub
              11'b00100000000 : alu_opcode = 4'b0010;  // sll
              11'b00010000000 : alu_opcode = 4'b0011;  // slt
              11'b00001000000 : alu_opcode = 4'b0100;  // sltu
              11'b00000100000 : alu_opcode = 4'b0101;  // xor
              11'b00000010000 : alu_opcode = 4'b0110;  // srl
              11'b00000001000 : alu_opcode = 4'b0111;  // sra
              11'b00000000100 : alu_opcode = 4'b1000;  // or
              11'b00000000010 : alu_opcode = 4'b1001;  // and
              11'b00000000001 : alu_opcode = 4'b1010;  // mul
              default         : alu_opcode = 4'b0000;
            endcase
      ITYPE: case (itype)
              9'b100000000   : begin
                alu_opcode = 4'b0000;   // addi
                br_unsign  = 1'b0;
              end
              9'b010000000   : alu_opcode = 4'b0010;  // slli
              9'b001000000   : alu_opcode = 4'b0011;  // slti
              9'b000100000   : alu_opcode = 4'b0100;  // sltiu
              9'b000010000   : alu_opcode = 4'b0101;  // xori
              9'b000001000   : alu_opcode = 4'b0110;  // srli
              9'b000000100   : begin
                alu_opcode = 4'b0111;                 // is_srai
                br_unsign  = 1'b0;
              end
              9'b000000010   : alu_opcode = 4'b1000;   // ori
              9'b000000001   : alu_opcode = 4'b1001;   // andi
              default        : alu_opcode = 4'b0000;
            endcase
      ILTYPE,
      STYPE:                  alu_opcode = 4'b0000;    // alu using add
      BTYPE: case (btype)
              6'b100000  : begin                       // beq
                alu_opcode = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b010000 : begin                        // bne
                alu_opcode = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b001000 : begin                        // blt
                alu_opcode = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b000100: begin                         // bge
                alu_opcode = 4'b0000;
                br_unsign = 1'b0;
                end
              6'b000010: begin
                alu_opcode = 4'b0000;         // bltu
                br_unsign  = 1'b1;
                end
              6'b000001: begin
                alu_opcode = 4'b0000;
                br_unsign  = 1'b1;
                end
              default  : alu_opcode = 4'b0000;
            endcase
      IJTYPE:            alu_opcode = 4'b0000;
      IITYPE:            alu_opcode = 4'b0000;
      U1TYPE:            alu_opcode = 4'b0000;         // lui using imm + 0
      U2TYPE:            alu_opcode = 4'b0000;         // auipc using pc + imm
      default:           alu_opcode = 4'b0000;
    endcase
//==================================WRITE_BACK===============================================
  case (instruction[6:0])
    RTYPE: begin                     // opcode rd, r1, r2
      wb_sel   = 2'b00; // rd
      pc_sel   = 1'b0;  // pc + 4
      op1_sel  = 1'b0;  //rs1
      op2_sel  = 1'b0;  //rs2;
    end
    ITYPE: begin
      wb_sel   = 2'b00; // rd
      pc_sel   = 1'b0;  // pc + 4
      op1_sel  = 1'b0;  // rs1
      op2_sel  = 1'b1;  // imm
    end
    ILTYPE: begin
      wb_sel   = 2'b11; // read_data
      pc_sel   = 1'b0;  // pc + 4
      op1_sel  = 1'b0;  // rs1
      op2_sel  = 1'b1;  // imm_ex;
    end
    BTYPE: begin
      wb_sel   = 2'b01;   //jmp_pc
      pc_sel   = 1'b1;    // jmp_pc
      op1_sel  = 1'b1;    // pc
      op2_sel  = 1'b1;    // imm
    end
    STYPE: begin
      op1_sel  = 1'b0; // rs1
      op2_sel  = 1'b1; // imm
      pc_sel   = 1'b0; // pc + 4
      mem_wren = 1'b1;
    end
    IJTYPE: begin
      wb_sel  = 2'b10; // rd = pc +4
      pc_sel  = 1'b1;  // jmp_pc
      op1_sel = 1'b1;  // pc
      op2_sel = 1'b1;  // imm
    end
    IITYPE: begin
      wb_sel  = 2'b10; // pc = rs1 + imm
      pc_sel  = 1'b1;  // jmp_pc
      op1_sel = 1'b0;  // rs1
      op2_sel = 1'b1;  // imm
    end
    U1TYPE,
    U2TYPE: begin
      wb_sel  = 2'b00; // rd
      pc_sel  = 1'b0;  // pc + 4
      op1_sel = 1'b0;
      op2_sel = 1'b1;  // imm
    end
    default: begin
      op1_sel = 1'b0; // rs1_data
      op2_sel = 1'b0; // rs2_data
      pc_sel  = 1'b0;
      wb_sel  = 2'b00;
    end
  endcase
end
endmodule


module brcomp (
    input  wire [31:0] i_rs1_data,
    input  wire [31:0] i_rs2_data,
    input  wire        i_br_un,   // 1 if unsign, 0 if sign
    output wire        o_br_equal,
    output wire        o_br_less
);
//===============================================DECLARATION=========================================
  wire [31:0] sub_o;
  wire cout, same_sign, diff_sign;
  wire o_br_less_uns, o_br_less_s;
  wire o_br_less1, o_br_less2, o_br_less3;
//===============================================CODE================================================
  add_subtract S1 (.a_i(i_rs1_data),.b_i(i_rs2_data),.cin_i(1'b1),.result_o(sub_o),.cout_o(cout));
  // sign check
  assign  same_sign     = (i_rs1_data[31] && i_rs2_data[31]) ? 1'b1 : 1'b0;  // if same sign : 1
  assign  diff_sign     = (i_rs1_data[31] ^  i_rs2_data[31]) ? 1'b1 : 1'b0;  // if diff sign : 1
  //o_br_less
  assign  o_br_less1    = (same_sign && sub_o[31]     ) ? 1'b1 :1'b0;     // same sign and have cout
  assign  o_br_less2    = (diff_sign && i_rs1_data[31]) ? 1'b1 : 1'b0;    // diff sign and rs1[31] = 1 (neg)
  assign  o_br_less3    = (((i_rs1_data[31] ^ i_rs2_data[31]) && (i_rs1_data[31] ^ sub_o[31])) ^ sub_o[31]); // ovf
  assign  o_br_less_s   = o_br_less1 || o_br_less2 || o_br_less3;
  assign  o_br_less_uns = cout;
  assign  o_br_less     = (i_br_un) ? (o_br_less_uns) : (o_br_less_s);
  //compare block
  assign  o_br_equal    = (sub_o[0]  ^ 1'b1) & (sub_o[1]  ^ 1'b1) & (sub_o[2]  ^ 1'b1) &
                          (sub_o[3]  ^ 1'b1) & (sub_o[4]  ^ 1'b1) & (sub_o[5]  ^ 1'b1) &
                          (sub_o[6]  ^ 1'b1) & (sub_o[7]  ^ 1'b1) & (sub_o[8]  ^ 1'b1) &
                          (sub_o[9]  ^ 1'b1) & (sub_o[10] ^ 1'b1) & (sub_o[11] ^ 1'b1) &
                          (sub_o[12] ^ 1'b1) & (sub_o[13] ^ 1'b1) & (sub_o[14] ^ 1'b1) &
                          (sub_o[15] ^ 1'b1) & (sub_o[16] ^ 1'b1) & (sub_o[17] ^ 1'b1) &
                          (sub_o[18] ^ 1'b1) & (sub_o[19] ^ 1'b1) & (sub_o[20] ^ 1'b1) &
                          (sub_o[21] ^ 1'b1) & (sub_o[22] ^ 1'b1) & (sub_o[23] ^ 1'b1) &
                          (sub_o[24] ^ 1'b1) & (sub_o[25] ^ 1'b1) & (sub_o[26] ^ 1'b1) &
                          (sub_o[27] ^ 1'b1) & (sub_o[28] ^ 1'b1) & (sub_o[29] ^ 1'b1) &
                          (sub_o[30] ^ 1'b1) & (sub_o[31] ^ 1'b1);
endmodule

module xor_32bit (
  input  wire [31:0] rs1_i,
  input  wire [31:0] rs2_i,
  output wire [31:0] rd_o
);
  xor G0  (rd_o[0 ], rs1_i[0 ], rs2_i[0 ]);
  xor G1  (rd_o[1 ], rs1_i[1 ], rs2_i[1 ]);
  xor G2  (rd_o[2 ], rs1_i[2 ], rs2_i[2 ]);
  xor G3  (rd_o[3 ], rs1_i[3 ], rs2_i[3 ]);
  xor G4  (rd_o[4 ], rs1_i[4 ], rs2_i[4 ]);
  xor G5  (rd_o[5 ], rs1_i[5 ], rs2_i[5 ]);
  xor G6  (rd_o[6 ], rs1_i[6 ], rs2_i[6 ]);
  xor G7  (rd_o[7 ], rs1_i[7 ], rs2_i[7 ]);
  xor G8  (rd_o[8 ], rs1_i[8 ], rs2_i[8 ]);
  xor G9  (rd_o[9 ], rs1_i[9 ], rs2_i[9 ]);
  xor G10 (rd_o[10], rs1_i[10], rs2_i[10]);
  xor G11 (rd_o[11], rs1_i[11], rs2_i[11]);
  xor G12 (rd_o[12], rs1_i[12], rs2_i[12]);
  xor G13 (rd_o[13], rs1_i[13], rs2_i[13]);
  xor G14 (rd_o[14], rs1_i[14], rs2_i[14]);
  xor G15 (rd_o[15], rs1_i[15], rs2_i[15]);
  xor G16 (rd_o[16], rs1_i[16], rs2_i[16]);
  xor G17 (rd_o[17], rs1_i[17], rs2_i[17]);
  xor G18 (rd_o[18], rs1_i[18], rs2_i[18]);
  xor G19 (rd_o[19], rs1_i[19], rs2_i[19]);
  xor G20 (rd_o[20], rs1_i[20], rs2_i[20]);
  xor G21 (rd_o[21], rs1_i[21], rs2_i[21]);
  xor G22 (rd_o[22], rs1_i[22], rs2_i[22]);
  xor G23 (rd_o[23], rs1_i[23], rs2_i[23]);
  xor G24 (rd_o[24], rs1_i[24], rs2_i[24]);
  xor G25 (rd_o[25], rs1_i[25], rs2_i[25]);
  xor G26 (rd_o[26], rs1_i[26], rs2_i[26]);
  xor G27 (rd_o[27], rs1_i[27], rs2_i[27]);
  xor G28 (rd_o[28], rs1_i[28], rs2_i[28]);
  xor G29 (rd_o[29], rs1_i[29], rs2_i[29]);
  xor G30 (rd_o[30], rs1_i[30], rs2_i[30]);
  xor G31 (rd_o[31], rs1_i[31], rs2_i[31]);
endmodule

module pc_reg (
  input  wire  [31:0]  pc_reg,
  output reg   [31:0]  pc_o
);
  full_adder_32bit PCplus4 (
                            .A_i(pc_reg),
                            .Y_i(32'd4),
                            .C_i(1'b0),
                            .Sum_o(pc_o),
                            .c_o()
                           );

endmodule

module full_adder (
    input  X_i,
    input  B_i,
    input  C_i,
    output S_o,
    output C_o
);
  wire w1, w2, w3;
  //Structural code for one bit full adder
  xor G1 (w1, X_i, B_i);
  and G2 (w3, X_i, B_i);
  and G3 (w2, w1, C_i);
  xor G4 (S_o, w1, C_i);
  or G5 (C_o, w2, w3);
endmodule

module full_adder_32bit (
    input       [31:0] A_i,
    input       [31:0] Y_i,
    input              C_i,
    output wire [31:0] Sum_o,
    output wire        c_o
);
  wire [30:0] c;
  wire w1, w2, w3;
  assign Sum_o[0]  =  A_i[0]  ^ Y_i[0]   ^ C_i;
  assign c[0]      = (A_i[0]  & Y_i[0])  | ((A_i[0] ^ Y_i[0]) & C_i);
  assign Sum_o[1]  =  A_i[1]  ^ Y_i[1]   ^ c[0];
  assign c[1]      = (A_i[1]  & Y_i[1])  | ((A_i[1] ^ Y_i[1]) & c[0]);
  assign Sum_o[2]  =  A_i[2]  ^ Y_i[2]   ^ c[1];
  assign c[2]      = (A_i[2]  & Y_i[2])  | ((A_i[2] ^ Y_i[2]) & c[1]);
  assign Sum_o[3]  =  A_i[3]  ^ Y_i[3]   ^ c[2];
  assign c[3]      = (A_i[3]  & Y_i[3])  | ((A_i[3] ^ Y_i[3]) & c[2]);
  assign Sum_o[4]  =  A_i[4]  ^ Y_i[4]   ^ c[3];
  assign c[4]      = (A_i[4]  & Y_i[4])  | ((A_i[4] ^ Y_i[4]) & c[3]);
  assign Sum_o[5]  =  A_i[5]  ^ Y_i[5]   ^ c[4];
  assign c[5]      = (A_i[5]  & Y_i[5])  | ((A_i[5] ^ Y_i[5]) & c[4]);
  assign Sum_o[6]  =  A_i[6]  ^ Y_i[6]   ^ c[5];
  assign c[6]      = (A_i[6]  & Y_i[6])  | ((A_i[6] ^ Y_i[6]) & c[5]);
  assign Sum_o[7]  =  A_i[7]  ^ Y_i[7]   ^ c[6];
  assign c[7]      = (A_i[7]  & Y_i[7])  | ((A_i[7] ^ Y_i[7]) & c[6]);
  assign Sum_o[8]  =  A_i[8]  ^ Y_i[8]   ^ c[7];
  assign c[8]      = (A_i[8]  & Y_i[8])  | ((A_i[8] ^ Y_i[8]) & c[7]);
  assign Sum_o[9]  =  A_i[9]  ^ Y_i[9]   ^ c[8];
  assign c[9]      = (A_i[9]  & Y_i[9])  | ((A_i[9] ^ Y_i[9]) & c[8]);
  assign Sum_o[10] =  A_i[10] ^ Y_i[10]  ^ c[9];
  assign c[10]     = (A_i[10] & Y_i[10]) | ((A_i[10] ^ Y_i[10]) & c[9]);
  assign Sum_o[11] =  A_i[11] ^ Y_i[11]  ^ c[10];
  assign c[11]     = (A_i[11] & Y_i[11]) | ((A_i[11] ^ Y_i[11]) & c[10]);
  assign Sum_o[12] =  A_i[12] ^ Y_i[12]  ^ c[11];
  assign c[12]     = (A_i[12] & Y_i[12]) | ((A_i[12] ^ Y_i[12]) & c[11]);
  assign Sum_o[13] =  A_i[13] ^ Y_i[13]  ^ c[12];
  assign c[13]     = (A_i[13] & Y_i[13]) | ((A_i[13] ^ Y_i[13]) & c[12]);
  assign Sum_o[14] =  A_i[14] ^ Y_i[14]  ^ c[13];
  assign c[14]     = (A_i[14] & Y_i[14]) | ((A_i[14] ^ Y_i[14]) & c[13]);
  assign Sum_o[15] =  A_i[15] ^ Y_i[15]  ^ c[14];
  assign c[15]     = (A_i[15] & Y_i[15]) | ((A_i[15] ^ Y_i[15]) & c[14]);
  assign Sum_o[16] =  A_i[16] ^ Y_i[16]  ^ c[15];
  assign c[16]     = (A_i[16] & Y_i[16]) | ((A_i[16] ^ Y_i[16]) & c[15]);
  assign Sum_o[17] =  A_i[17] ^ Y_i[17]  ^ c[16];
  assign c[17]     = (A_i[17] & Y_i[17]) | ((A_i[17] ^ Y_i[17]) & c[16]);
  assign Sum_o[18] =  A_i[18] ^ Y_i[18]  ^ c[17];
  assign c[18]     = (A_i[18] & Y_i[18]) | ((A_i[18] ^ Y_i[18]) & c[17]);
  assign Sum_o[19] =  A_i[19] ^ Y_i[19]  ^ c[18];
  assign c[19]     = (A_i[19] & Y_i[19]) | ((A_i[19] ^ Y_i[19]) & c[18]);
  assign Sum_o[20] =  A_i[20] ^ Y_i[20]  ^ c[19];
  assign c[20]     = (A_i[20] & Y_i[20]) | ((A_i[20] ^ Y_i[20]) & c[19]);
  assign Sum_o[21] =  A_i[21] ^ Y_i[21]  ^ c[20];
  assign c[21]     = (A_i[21] & Y_i[21]) | ((A_i[21] ^ Y_i[21]) & c[20]);
  assign Sum_o[22] =  A_i[22] ^ Y_i[22]  ^ c[21];
  assign c[22]     = (A_i[22] & Y_i[22]) | ((A_i[22] ^ Y_i[22]) & c[21]);
  assign Sum_o[23] =  A_i[23] ^ Y_i[23]  ^ c[22];
  assign c[23]     = (A_i[23] & Y_i[23]) | ((A_i[23] ^ Y_i[23]) & c[22]);
  assign Sum_o[24] =  A_i[24] ^ Y_i[24]  ^ c[23];
  assign c[24]     = (A_i[24] & Y_i[24]) | ((A_i[24] ^ Y_i[24]) & c[23]);
  assign Sum_o[25] =  A_i[25] ^ Y_i[25]  ^ c[24];
  assign c[25]     = (A_i[25] & Y_i[25]) | ((A_i[25] ^ Y_i[25]) & c[24]);
  assign Sum_o[26] =  A_i[26] ^ Y_i[26]  ^ c[25];
  assign c[26]     = (A_i[26] & Y_i[26]) | ((A_i[26] ^ Y_i[26]) & c[25]);
  assign Sum_o[27] =  A_i[27] ^ Y_i[27]  ^ c[26];
  assign c[27]     = (A_i[28] & Y_i[27]) | ((A_i[27] ^ Y_i[27]) & c[26]);
  assign Sum_o[28] =  A_i[28] ^ Y_i[28]  ^ c[27];
  assign c[28]     = (A_i[28] & Y_i[28]) | ((A_i[28] ^ Y_i[28]) & c[27]);
  assign Sum_o[29] =  A_i[29] ^ Y_i[29]  ^ c[28];
  assign c[29]     = (A_i[29] & Y_i[29]) | ((A_i[29] ^ Y_i[29]) & c[28]);
  assign Sum_o[30] =  A_i[30] ^ Y_i[30]  ^ c[29];
  assign c[30]     = (A_i[30] & Y_i[30]) | ((A_i[30] ^ Y_i[30]) & c[29]);
  assign Sum_o[31] =  A_i[31] ^ Y_i[31]  ^ c[30];
  assign c_o       = (A_i[31] & Y_i[31]) | ((A_i[31] ^ Y_i[31]) & c[30]);
endmodule

module or_32bit (
  input       [31:0] rs1_i,
  input       [31:0] rs2_i,
  output wire [31:0] rd_o
);
  or or0  (rd_o[0 ], rs1_i[0 ], rs2_i[0 ]);
  or or1  (rd_o[1 ], rs1_i[1 ], rs2_i[1 ]);
  or or2  (rd_o[2 ], rs1_i[2 ], rs2_i[2 ]);
  or or3  (rd_o[3 ], rs1_i[3 ], rs2_i[3 ]);
  or or4  (rd_o[4 ], rs1_i[4 ], rs2_i[4 ]);
  or or5  (rd_o[5 ], rs1_i[5 ], rs2_i[5 ]);
  or or6  (rd_o[6 ], rs1_i[6 ], rs2_i[6 ]);
  or or7  (rd_o[7 ], rs1_i[7 ], rs2_i[7 ]);
  or or8  (rd_o[8 ], rs1_i[8 ], rs2_i[8 ]);
  or or9  (rd_o[9 ], rs1_i[9 ], rs2_i[9 ]);
  or or10 (rd_o[10], rs1_i[10], rs2_i[10]);
  or or11 (rd_o[11], rs1_i[11], rs2_i[11]);
  or or12 (rd_o[12], rs1_i[12], rs2_i[12]);
  or or13 (rd_o[13], rs1_i[13], rs2_i[13]);
  or or14 (rd_o[14], rs1_i[14], rs2_i[14]);
  or or15 (rd_o[15], rs1_i[15], rs2_i[15]);
  or or16 (rd_o[16], rs1_i[16], rs2_i[16]);
  or or17 (rd_o[17], rs1_i[17], rs2_i[17]);
  or or18 (rd_o[18], rs1_i[18], rs2_i[18]);
  or or19 (rd_o[19], rs1_i[19], rs2_i[19]);
  or or20 (rd_o[20], rs1_i[20], rs2_i[20]);
  or or21 (rd_o[21], rs1_i[21], rs2_i[21]);
  or or22 (rd_o[22], rs1_i[22], rs2_i[22]);
  or or23 (rd_o[23], rs1_i[23], rs2_i[23]);
  or or24 (rd_o[24], rs1_i[24], rs2_i[24]);
  or or25 (rd_o[25], rs1_i[25], rs2_i[25]);
  or or26 (rd_o[26], rs1_i[26], rs2_i[26]);
  or or27 (rd_o[27], rs1_i[27], rs2_i[27]);
  or or28 (rd_o[28], rs1_i[28], rs2_i[28]);
  or or29 (rd_o[29], rs1_i[29], rs2_i[29]);
  or or30 (rd_o[30], rs1_i[30], rs2_i[30]);
  or or31 (rd_o[31], rs1_i[31], rs2_i[31]);
endmodule

module sra (
  input       [31:0] rs1_data,
  input       [31:0] rs2_data,
  input              br_unsign,
  output wire [31:0] rd_data
);
//chi dich 5 bit thap nhat cua rs2_data
//dich phai msb extend
  wire [31:0] rd_data_unsign, rd_data_sign;
  wire [31:0] s0, s1, s2, s3;
  // dich phai voi msb = 1
  assign s0           = rs2_data[0] ? {rs1_data[31],      rs1_data[31:1] } : rs1_data;
  assign s1           = rs2_data[1] ? {{2{rs1_data[31]}},       s0[31:2] } : s0;
  assign s2           = rs2_data[2] ? {{4{rs1_data[31]}},       s1[31:4] } : s1;
  assign s3           = rs2_data[3] ? {{8{rs1_data[31]}},       s2[31:8] } : s2;
  assign rd_data      = rs2_data[4] ? {{16{rs1_data[31]}},      s3[31:16]} : s3;
endmodule

module srl (
  input       [31:0] rs1_data,
  input       [31:0] rs2_data,
  output wire [31:0] rd_data
);
  wire [31:0] s0, s1, s2, s3, s4;
  assign s0 = rs2_data[0] ? {1'b0, rs1_data[31:1]}   : rs1_data; //dich phai 1 bit hoac 0 dich
  assign s1 = rs2_data[1] ? {2'b0, s0[31:2]}         : s0;       //dich phai 2 bit hoac 0 dich
  assign s2 = rs2_data[2] ? {4'b0, s1[31:4]}         : s1;       //dich phai 4 bit hoac 0 dich
  assign s3 = rs2_data[3] ? {8'b0, s2[31:8]}         : s2;       //dich phai 8 bit hoac 0 dich
  assign s4 = rs2_data[4] ? {16'b0, s3[31:16]}       : s3;      //dich phai 16 bit hoac 0 dich
  assign rd_data = s4;
endmodule

module and_32bit (
  input       [31:0] rs1_i,
  input       [31:0] rs2_i,
  output wire [31:0] rd_o
);
  and and0  (rd_o[0 ], rs1_i[0 ], rs2_i[0 ]);
  and and1  (rd_o[1 ], rs1_i[1 ], rs2_i[1 ]);
  and and2  (rd_o[2 ], rs1_i[2 ], rs2_i[2 ]);
  and and3  (rd_o[3 ], rs1_i[3 ], rs2_i[3 ]);
  and and4  (rd_o[4 ], rs1_i[4 ], rs2_i[4 ]);
  and and5  (rd_o[5 ], rs1_i[5 ], rs2_i[5 ]);
  and and6  (rd_o[6 ], rs1_i[6 ], rs2_i[6 ]);
  and and7  (rd_o[7 ], rs1_i[7 ], rs2_i[7 ]);
  and and8  (rd_o[8 ], rs1_i[8 ], rs2_i[8 ]);
  and and9  (rd_o[9 ], rs1_i[9 ], rs2_i[9 ]);
  and and10 (rd_o[10], rs1_i[10], rs2_i[10]);
  and and11 (rd_o[11], rs1_i[11], rs2_i[11]);
  and and12 (rd_o[12], rs1_i[12], rs2_i[12]);
  and and13 (rd_o[13], rs1_i[13], rs2_i[13]);
  and and14 (rd_o[14], rs1_i[14], rs2_i[14]);
  and and15 (rd_o[15], rs1_i[15], rs2_i[15]);
  and and16 (rd_o[16], rs1_i[16], rs2_i[16]);
  and and17 (rd_o[17], rs1_i[17], rs2_i[17]);
  and and18 (rd_o[18], rs1_i[18], rs2_i[18]);
  and and19 (rd_o[19], rs1_i[19], rs2_i[19]);
  and and20 (rd_o[20], rs1_i[20], rs2_i[20]);
  and and21 (rd_o[21], rs1_i[21], rs2_i[21]);
  and and22 (rd_o[22], rs1_i[22], rs2_i[22]);
  and and23 (rd_o[23], rs1_i[23], rs2_i[23]);
  and and24 (rd_o[24], rs1_i[24], rs2_i[24]);
  and and25 (rd_o[25], rs1_i[25], rs2_i[25]);
  and and26 (rd_o[26], rs1_i[26], rs2_i[26]);
  and and27 (rd_o[27], rs1_i[27], rs2_i[27]);
  and and28 (rd_o[28], rs1_i[28], rs2_i[28]);
  and and29 (rd_o[29], rs1_i[29], rs2_i[29]);
  and and30 (rd_o[30], rs1_i[30], rs2_i[30]);
  and and31 (rd_o[31], rs1_i[31], rs2_i[31]);
endmodule

module mux_2to1 (
    input       [31:0] d0_i,
    input       [31:0] d1_i,
    input              s_i,
    output wire [31:0] y_o
); 
  assign y_o = (s_i) ? d1_i : d0_i;
endmodule

module decoder_5to32 (
    input       [4:0]  a_i,
    output wire [31:0] out_o
);
  assign out_o[0]  = ~a_i[4] & ~a_i[3] & ~a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[1]  = ~a_i[4] & ~a_i[3] & ~a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[2]  = ~a_i[4] & ~a_i[3] & ~a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[3]  = ~a_i[4] & ~a_i[3] & ~a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[4]  = ~a_i[4] & ~a_i[3] &  a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[5]  = ~a_i[4] & ~a_i[3] &  a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[6]  = ~a_i[4] & ~a_i[3] &  a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[7]  = ~a_i[4] & ~a_i[3] &  a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[8]  = ~a_i[4] &  a_i[3] & ~a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[9]  = ~a_i[4] &  a_i[3] & ~a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[10] = ~a_i[4] &  a_i[3] & ~a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[11] = ~a_i[4] &  a_i[3] & ~a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[12] = ~a_i[4] &  a_i[3] &  a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[13] = ~a_i[4] &  a_i[3] &  a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[14] = ~a_i[4] &  a_i[3] &  a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[15] = ~a_i[4] &  a_i[3] &  a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[16] =  a_i[4] & ~a_i[3] & ~a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[17] =  a_i[4] & ~a_i[3] & ~a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[18] =  a_i[4] & ~a_i[3] & ~a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[19] =  a_i[4] & ~a_i[3] & ~a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[20] =  a_i[4] & ~a_i[3] &  a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[21] =  a_i[4] & ~a_i[3] &  a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[22] =  a_i[4] & ~a_i[3] &  a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[23] =  a_i[4] & ~a_i[3] &  a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[24] =  a_i[4] &  a_i[3] & ~a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[25] =  a_i[4] &  a_i[3] & ~a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[26] =  a_i[4] &  a_i[3] & ~a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[27] =  a_i[4] &  a_i[3] & ~a_i[2] &  a_i[1] &  a_i[0];
  assign out_o[28] =  a_i[4] &  a_i[3] &  a_i[2] & ~a_i[1] & ~a_i[0];
  assign out_o[29] =  a_i[4] &  a_i[3] &  a_i[2] & ~a_i[1] &  a_i[0];
  assign out_o[30] =  a_i[4] &  a_i[3] &  a_i[2] &  a_i[1] & ~a_i[0];
  assign out_o[31] =  a_i[4] &  a_i[3] &  a_i[2] &  a_i[1] &  a_i[0];
endmodule

module sll (
  input       [31:0] rs1_data,
  input       [31:0] rs2_data,
  output wire [31:0] rd_data
);
  wire [31:0] s0, s1, s2, s3, s4;
  assign s0 = rs2_data[0] ? {rs1_data[30:0],  1'b0} : rs1_data; //dich phai 1 bit hoac 0 dich
  assign s1 = rs2_data[1] ? {      s0[29:0],  2'b0} : s0;       //dich phai 2 bit hoac 0 dich
  assign s2 = rs2_data[2] ? {      s1[27:0],  4'b0} : s1;       //dich phai 4 bit hoac 0 dich
  assign s3 = rs2_data[3] ? {      s2[23:0],  8'b0} : s2;       //dich phai 8 bit hoac 0 dich
  assign s4 = rs2_data[4] ? {      s3[15:0], 16'b0} : s3;       //dich phai 16 bit hoac 0 dich
  assign rd_data = s4;
endmodule

//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : ALU - Arithmetic Logic Unit
// File            : alu.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 6/11/2025 - Finished
//===========================================================================================
module alu (
  input  wire  [31:0] i_op_a,
  input  wire  [31:0] i_op_b,
  input  wire         br_unsign_i,
  input  wire  [3:0]  i_alu_op,
  output wire  [31:0] o_alu_data
  );
  wire        slt, sltu;
  wire [31:0] rd_and, rd_or, rd_xor, rd_sra, rd_srl, rd_sll, rd_add, rd_sub, rd_slt, rd_sltu, rd_mul;
  wire        cout_add, cout_sub, rd_equals, rd_equalu;

  and_32bit     and_module      (
                                .rs1_i(i_op_a),
                                .rs2_i(i_op_b),
                                .rd_o(rd_and)
                                ); //AND

  or_32bit      or_module       (
                                .rs1_i(i_op_a),
                                .rs2_i(i_op_b),
                                .rd_o(rd_or)
                                ); //OR

  xor_32bit     xor_module      (
                                .rs1_i(i_op_a),
                                .rs2_i(i_op_b),
                                .rd_o(rd_xor)
                                ); // XOR

  add_subtract  subtract_module (
                                .a_i      (i_op_a),
                                .b_i      (i_op_b),
                                .cin_i    (1'b1),
                                .result_o (rd_sub),
                                .cout_o   (cout_sub)
                                ); //SUB

  add_subtract add_module       (
                                .a_i      (i_op_a),
                                .b_i      (i_op_b),
                                .cin_i    (1'b0),
                                .result_o (rd_add),
                                .cout_o   (cout_add)
                                ); //ADD

  brcomp        slt_module      (
                                .i_rs1_data(i_op_a),
                                .i_rs2_data(i_op_b),
                                .i_br_un   (1'b0),
                                .o_br_less (slt),
                                .o_br_equal(rd_equals)
                                ); //SLT

  brcomp        sltu_module     (
                                .i_rs1_data  (i_op_a),
                                .i_rs2_data  (i_op_b),
                                .i_br_un     (1'b1),
                                .o_br_less   (sltu),
                                .o_br_equal  (rd_equalu)
                                ); //SLTU

  srl           srl_module      (
                                .rs1_data (i_op_a),
                                .rs2_data (i_op_b),
                                .rd_data  (rd_srl)
                                ); //SRL

  sll           sll_module      (
                                .rs1_data (i_op_a),
                                .rs2_data (i_op_b),
                                .rd_data  (rd_sll)
                                ); //SLL

  sra           sra_module      (
                                .rs1_data   (i_op_a),
                                .rs2_data   (i_op_b),
                                .rd_data    (rd_sra)
                                ); //SRA
  multiply_extension multiply   (
                                .i_op_a(i_op_a),
                                .i_op_b(i_op_b),
                                .o_mul (rd_mul)
                                );
  assign rd_slt  = {31'b0, slt};
  assign rd_sltu = {31'b0, sltu};
  //mux
  mux_16to1  mux1 (
                    .d0   (rd_add),
                    .d1   (rd_sub),
                    .d2   (rd_sll),
                    .d3   (rd_slt),
                    .d4   (rd_sltu),
                    .d5   (rd_xor),
                    .d6   (rd_srl),
                    .d7   (rd_sra),
                    .d8   (rd_or),
                    .d9   (rd_and),
                    .d10  (rd_mul),
                    .d11  (32'b0),
                    .d12  (32'b0),
                    .d13  (32'b0),
                    .d14  (32'b0),
                    .d15  (32'b0),
                    .s    (i_alu_op),
                    .y_o  (o_alu_data)
                );
endmodule


module memory (
 input  wire        i_clk,
 input  wire        i_reset,
 input  wire [2:0]  i_func3,
 input  wire  [15:0] i_addr,
 input  wire  [31:0] i_wdata,
 input  wire  [3:0]  i_bmask_align,
 input  wire  [3:0]  i_bmask_misalign,
 input  wire         i_wren,
 output reg [31:0] o_rdata
);
  integer  i;
  reg  [31:0] mem         [0: 16]; // 2kB
  reg  [31:0] mem_st_align;
  reg  [31:0] mem_st_misalign;
  reg  [31:0] mem_ld_align;
  reg  [31:0] mem_ld_misalign;
  wire [31:0] mem_addr;
  wire [31:0] mem_addr_plus1;
  reg         is_sbyte;
  reg         is_ubyte;
  reg         is_shb;
  reg         is_uhb;
  reg         is_word;

  always_comb begin
    is_ubyte = 1'b0;
    is_sbyte = 1'b0;
    is_uhb   = 1'b0;
    is_shb   = 1'b0;
    is_word  = 1'b0;
    case (i_func3)
      3'b000: is_sbyte = 1'b1;
      3'b001: is_shb   = 1'b1;
      3'b010: is_word  = 1'b1;
      3'b100: is_ubyte = 1'b1;
      3'b101: is_uhb   = 1'b1;
      default: begin
              is_ubyte = 1'b0;
              is_sbyte = 1'b0;
              is_uhb   = 1'b0;
              is_shb   = 1'b0;
              is_word  = 1'b0;
              end
    endcase
  end
  assign mem_addr = {23'b0 , i_addr[10:2]};

  full_adder_32bit fa (
                        .A_i(mem_addr),
                        .Y_i(32'd1),
                        .C_i(1'b0),
                        .Sum_o(mem_addr_plus1),
                        .c_o()
                      );

  assign mem_ld_align    = mem[mem_addr];
  assign mem_ld_misalign = mem[mem_addr_plus1];

  always_comb begin
    case (i_bmask_align)
      4'b0001: mem_st_align    = {24'b0, i_wdata[ 7:0]       };
      4'b0010: mem_st_align    = {16'b0, i_wdata[ 7:0], 8'b0 };
      4'b0100: mem_st_align    = {8'b0 , i_wdata[ 7:0], 16'b0};
      4'b1000: mem_st_align    = {       i_wdata[ 7:0], 24'b0};
      4'b0011: mem_st_align    = {16'b0, i_wdata[15:0]       };
      4'b1100: mem_st_align    = {       i_wdata[15:0], 16'b0};
      4'b1110: mem_st_align    = {       i_wdata[23:0], 8'b0 };
      4'b1111: mem_st_align    =         i_wdata;
      default: mem_st_align    = 32'b0;
    endcase
    case (i_bmask_misalign)
      4'b0000: mem_st_misalign = 32'b0;
      4'b0001: mem_st_misalign = (i_bmask_align[2])?{24'b0, i_wdata[31:24]}:{24'b0, i_wdata[15:8]};
      4'b0011: mem_st_misalign = {16'b0, i_wdata[31:16]};
      4'b0111: mem_st_misalign = {8'b0 , i_wdata[31:8]};
      default: mem_st_misalign = 32'b0;
    endcase
  end

  always_ff @(posedge i_clk or negedge i_reset) begin : mem_align_store
    if (~i_reset) begin : reset
      for(i = 0; i < 9; i++) begin
        mem[i] <= 32'b0;
      end
    end else if (i_wren) begin
        if (i_bmask_align[0])    mem[mem_addr      ][7 :0 ] <= mem_st_align[ 7:0 ];
        if (i_bmask_align[1])    mem[mem_addr      ][15:8 ] <= mem_st_align[15:8 ];
        if (i_bmask_align[2])    mem[mem_addr      ][23:16] <= mem_st_align[23:16];
        if (i_bmask_align[3])    mem[mem_addr      ][31:24] <= mem_st_align[31:24];
        if (i_bmask_misalign[0]) mem[mem_addr_plus1][7 :0 ] <= mem_st_misalign[ 7:0 ];
        if (i_bmask_misalign[1]) mem[mem_addr_plus1][15:8 ] <= mem_st_misalign[15:8 ];
        if (i_bmask_misalign[2]) mem[mem_addr_plus1][23:16] <= mem_st_misalign[23:16];
        if (i_bmask_misalign[3]) mem[mem_addr_plus1][31:24] <= mem_st_misalign[31:24];
    end
  end

  always_comb begin : mem_load
    o_rdata = 32'b0;
    if(is_word) begin
      case(i_addr[1:0])
        2'b00:   o_rdata =                         mem_ld_align;
        2'b01:   o_rdata = {mem_ld_misalign[ 7:0], mem_ld_align[31:8 ]};
        2'b10:   o_rdata = {mem_ld_misalign[15:0], mem_ld_align[31:16]};
        2'b11:   o_rdata = {mem_ld_misalign[23:0], mem_ld_align[31:24]};
        default: o_rdata = 32'b0;
      endcase
    end

    if(is_shb) begin
      case(i_addr[1:0])
        2'b00:   o_rdata = {{16{mem_ld_align[15]}}  ,                       mem_ld_align[15:0 ]};
        2'b01:   o_rdata = {{16{mem_ld_align[23]}}  ,                       mem_ld_align[23:8 ]};
        2'b10:   o_rdata = {{16{mem_ld_align[31]}}  ,                       mem_ld_align[31:16]};
        2'b11:   o_rdata = {{16{mem_ld_misalign[7]}}, mem_ld_misalign[7:0], mem_ld_align[31:24]};
        default: o_rdata = 32'b0;
      endcase
    end
    if(is_uhb) begin
      case(i_addr[1:0])
        2'b00:   o_rdata = {16'b0,                       mem_ld_align[15:0 ]};
        2'b01:   o_rdata = {16'b0,                       mem_ld_align[23:8 ]};
        2'b10:   o_rdata = {16'b0,                       mem_ld_align[31:16]};
        2'b11:   o_rdata = {16'b0, mem_ld_misalign[7:0], mem_ld_align[31:24]};
        default: o_rdata = 32'b0;
      endcase
    end

    if(is_sbyte) begin
      case(i_addr[1:0])
        2'b00:   o_rdata = {{24{mem_ld_align[7]}} , mem_ld_align[ 7:0 ]};
        2'b01:   o_rdata = {{24{mem_ld_align[15]}}, mem_ld_align[15:8 ]};
        2'b10:   o_rdata = {{24{mem_ld_align[23]}}, mem_ld_align[23:16]};
        2'b11:   o_rdata = {{24{mem_ld_align[31]}}, mem_ld_align[31:24]};
        default: o_rdata = 32'b0;
      endcase
    end


    if(is_ubyte) begin
      case(i_addr[1:0])
        2'b00:   o_rdata = {24'b0, mem_ld_align[ 7:0 ]};
        2'b01:   o_rdata = {24'b0, mem_ld_align[15:8 ]};
        2'b10:   o_rdata = {24'b0, mem_ld_align[23:16]};
        2'b11:   o_rdata = {24'b0, mem_ld_align[31:24]};
        default: o_rdata = 32'b0;
      endcase
    end
  end
endmodule

  module register_32bit (
      input  wire        i_clk,
      input  wire        nrst_i,
      input  wire        en_i,
      input  wire [31:0] d_i,
      output reg  [31:0] q_o
  ); //da hal check va khong co loi

    always @(posedge i_clk or negedge nrst_i) begin
      if (~nrst_i) begin
        q_o <= 0;
      end else if (en_i) begin
        q_o <= d_i;
      end else begin
         q_o <= q_o;
      end
    end
  endmodule

module mux_16to1 (
    input       [31:0] d0, d1, d2, d3, d4, d5, d6, d7,
                       d8, d9, d10, d11, d12, d13, d14, d15,
    input       [3:0]  s,
    output wire [31:0] y_o          // output 32-bits
);
  assign y_o = s[3] ? (
                        s[2] ? (
                                  s[1] ? (s[0] ? d15 : d14) : (s[0] ? d13 : d12)
                               )
                              :
                               (
                                  s[1] ? (s[0] ? d11 : d10) : (s[0] ? d9  : d8)
                               )
                      )
                    :
                      (
                        s[2] ? (
                                  s[1] ? (s[0] ? d7  : d6) : (s[0] ? d5  : d4)
                               )
                             :
                               (
                                  s[1] ? (s[0] ? d3  : d2) : (s[0] ? d1  : d0)
                               )
                      );
endmodule

module regfile (
    input  wire         i_clk,
    input  wire         i_reset,
    input  wire  [4:0]  i_rs1_addr,
    input  wire  [4:0]  i_rs2_addr,
    input  wire  [4:0]  i_rd_addr,
    input  wire  [31:0] i_rd_data,
    input  wire         i_rd_wren,
    output reg  [31:0]  o_rs1_data,
    output reg  [31:0]  o_rs2_data
);
//==================================Declaration=========================================================
  wire [31:0] data_o;
  wire [31:0] q_o0, q_o1, q_o2, q_o3, q_o4, q_o5, q_o6, q_o7,
              q_o8, q_o9, q_o10, q_o11, q_o12, q_o13, q_o14, q_o15,
              q_o16, q_o17, q_o18, q_o19, q_o20, q_o21, q_o22, q_o23,
              q_o24, q_o25, q_o26, q_o27, q_o28, q_o29, q_o30, q_o31;
  wire  [31:1] enb;
  //===========================================================================================
  decoder_5to32 d1 (.a_i(i_rd_addr), .out_o(data_o));
  assign enb[1]   = i_rd_wren & data_o[1];
  assign enb[2]   = i_rd_wren & data_o[2];
  assign enb[3]   = i_rd_wren & data_o[3];
  assign enb[4]   = i_rd_wren & data_o[4];
  assign enb[5]   = i_rd_wren & data_o[5];
  assign enb[6]   = i_rd_wren & data_o[6];
  assign enb[7]   = i_rd_wren & data_o[7];
  assign enb[8]   = i_rd_wren & data_o[8];
  assign enb[9]   = i_rd_wren & data_o[9];
  assign enb[10]  = i_rd_wren & data_o[10];
  assign enb[11]  = i_rd_wren & data_o[11];
  assign enb[12]  = i_rd_wren & data_o[12];
  assign enb[13]  = i_rd_wren & data_o[13];
  assign enb[14]  = i_rd_wren & data_o[14];
  assign enb[15]  = i_rd_wren & data_o[15];
  assign enb[16]  = i_rd_wren & data_o[16];
  assign enb[17]  = i_rd_wren & data_o[17];
  assign enb[18]  = i_rd_wren & data_o[18];
  assign enb[19]  = i_rd_wren & data_o[19];
  assign enb[20]  = i_rd_wren & data_o[20];
  assign enb[21]  = i_rd_wren & data_o[21];
  assign enb[22]  = i_rd_wren & data_o[22];
  assign enb[23]  = i_rd_wren & data_o[23];
  assign enb[24]  = i_rd_wren & data_o[24];
  assign enb[25]  = i_rd_wren & data_o[25];
  assign enb[26]  = i_rd_wren & data_o[26];
  assign enb[27]  = i_rd_wren & data_o[27];
  assign enb[28]  = i_rd_wren & data_o[28];
  assign enb[29]  = i_rd_wren & data_o[29];
  assign enb[30]  = i_rd_wren & data_o[30];
  assign enb[31]  = i_rd_wren & data_o[31];
  register_32bit r0  (.i_clk(i_clk), .nrst_i(1'b0),    .en_i(1'b1),    .d_i(32'b0),     .q_o(q_o0) );
  register_32bit r1  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[1]),  .d_i(i_rd_data), .q_o(q_o1) );
  register_32bit r2  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[2]),  .d_i(i_rd_data), .q_o(q_o2) );
  register_32bit r3  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[3]),  .d_i(i_rd_data), .q_o(q_o3) );
  register_32bit r4  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[4]),  .d_i(i_rd_data), .q_o(q_o4) );
  register_32bit r5  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[5]),  .d_i(i_rd_data), .q_o(q_o5) );
  register_32bit r6  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[6]),  .d_i(i_rd_data), .q_o(q_o6) );
  register_32bit r7  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[7]),  .d_i(i_rd_data), .q_o(q_o7) );
  register_32bit r8  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[8]),  .d_i(i_rd_data), .q_o(q_o8) );
  register_32bit r9  (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[9]),  .d_i(i_rd_data), .q_o(q_o9) );
  register_32bit r10 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[10]), .d_i(i_rd_data), .q_o(q_o10));
  register_32bit r11 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[11]), .d_i(i_rd_data), .q_o(q_o11));
  register_32bit r12 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[12]), .d_i(i_rd_data), .q_o(q_o12));
  register_32bit r13 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[13]), .d_i(i_rd_data), .q_o(q_o13));
  register_32bit r14 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[14]), .d_i(i_rd_data), .q_o(q_o14));
  register_32bit r15 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[15]), .d_i(i_rd_data), .q_o(q_o15));
  register_32bit r16 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[16]), .d_i(i_rd_data), .q_o(q_o16));
  register_32bit r17 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[17]), .d_i(i_rd_data), .q_o(q_o17));
  register_32bit r18 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[18]), .d_i(i_rd_data), .q_o(q_o18));
  register_32bit r19 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[19]), .d_i(i_rd_data), .q_o(q_o19));
  register_32bit r20 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[20]), .d_i(i_rd_data), .q_o(q_o20));
  register_32bit r21 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[21]), .d_i(i_rd_data), .q_o(q_o21));
  register_32bit r22 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[22]), .d_i(i_rd_data), .q_o(q_o22));
  register_32bit r23 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[23]), .d_i(i_rd_data), .q_o(q_o23));
  register_32bit r24 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[24]), .d_i(i_rd_data), .q_o(q_o24));
  register_32bit r25 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[25]), .d_i(i_rd_data), .q_o(q_o25));
  register_32bit r26 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[26]), .d_i(i_rd_data), .q_o(q_o26));
  register_32bit r27 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[27]), .d_i(i_rd_data), .q_o(q_o27));
  register_32bit r28 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[28]), .d_i(i_rd_data), .q_o(q_o28));
  register_32bit r29 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[29]), .d_i(i_rd_data), .q_o(q_o29));
  register_32bit r30 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[30]), .d_i(i_rd_data), .q_o(q_o30));
  register_32bit r31 (.i_clk(i_clk), .nrst_i(i_reset), .en_i(enb[31]), .d_i(i_rd_data), .q_o(q_o31));
  mux_32to1 mux_rs1 (
                      .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
                      .d4(q_o4),  .d5(q_o5),  .d6(q_o6),  .d7(q_o7),
                      .d8(q_o8),  .d9(q_o9),  .d10(q_o10),.d11(q_o11),
                      .d12(q_o12),.d13(q_o13),.d14(q_o14),.d15(q_o15),
                      .d16(q_o16),.d17(q_o17),.d18(q_o18),.d19(q_o19),
                      .d20(q_o20),.d21(q_o21),.d22(q_o22),.d23(q_o23),
                      .d24(q_o24),.d25(q_o25),.d26(q_o26),.d27(q_o27),
                      .d28(q_o28),.d29(q_o29),.d30(q_o30),.d31(q_o31),
                      .s(i_rs1_addr), .y_o(o_rs1_data)
                    );
  mux_32to1 mux_rs2 (
                      .d0(q_o0),  .d1(q_o1),  .d2(q_o2),  .d3(q_o3),
                      .d4(q_o4),  .d5(q_o5),  .d6(q_o6),  .d7(q_o7),
                      .d8(q_o8),  .d9(q_o9),  .d10(q_o10),.d11(q_o11),
                      .d12(q_o12),.d13(q_o13),.d14(q_o14),.d15(q_o15),
                      .d16(q_o16),.d17(q_o17),.d18(q_o18),.d19(q_o19),
                      .d20(q_o20),.d21(q_o21),.d22(q_o22),.d23(q_o23),
                      .d24(q_o24),.d25(q_o25),.d26(q_o26),.d27(q_o27),
                      .d28(q_o28),.d29(q_o29),.d30(q_o30),.d31(q_o31),
                      .s(i_rs2_addr), .y_o(o_rs2_data)
                    );
endmodule

import package_param::*;
module lsu (
  input  wire        i_clk,
  input  wire        i_reset,

  input  wire [31:0] i_lsu_addr,
  input  wire [31:0] i_st_data,
  input  wire        i_lsu_wren,
  input  wire [2:0]  i_func3,

  input  wire [31:0] i_io_sw,

  output reg  [6:0]  o_io_hex0,
  output reg  [6:0]  o_io_hex1,
  output reg  [6:0]  o_io_hex2,
  output reg  [6:0]  o_io_hex3,
  output reg  [6:0]  o_io_hex4,
  output reg  [6:0]  o_io_hex5,
  output reg  [6:0]  o_io_hex6,
  output reg  [6:0]  o_io_hex7,

  output reg  [31:0] o_ld_data,

  output reg  [31:0] o_io_ledr,

  output reg  [31:0] o_io_ledg,

  output reg  [31:0] o_io_lcd
);

//====================================DECLARATION==============================================================
  wire        is_ledr;
  wire        is_ledg;
  wire        is_hex03;
  wire        is_hex47;
  wire        is_lcd;
  wire        is_sw;

  wire        is_dmem;
  wire        is_out;
  wire        is_in;

  wire [15:0] dmem_ptr;

  reg         mem_wren;

  reg         is_sbyte;
  reg         is_ubyte;
  reg         is_shb;
  reg         is_uhb;
  reg         is_word;

  reg  [31:0] dmem;

  reg  [31:0] ledr_next, ledg_next, lcd_next;
  reg  [6:0]  hex0_next, hex1_next, hex2_next, hex3_next;
  reg  [6:0]  hex4_next, hex5_next, hex6_next, hex7_next;

  reg  [31:0] st_wdata;
  reg  [31:0] ld_data;
  reg  [15:0] halfword_out;
  reg  [7:0]  byte_out;

  reg  [3:0]  bmask_align;
  reg  [3:0]  bmask_misalign;

//====================================CODE====================================================================
  always_comb begin
    is_ubyte = 1'b0;
    is_sbyte = 1'b0;
    is_uhb   = 1'b0;
    is_shb   = 1'b0;
    is_word  = 1'b0;
    bmask_align = 4'b0;
    bmask_misalign = 4'b0;
    case (i_func3)
      3'b000: is_sbyte = 1'b1;
      3'b001: is_shb   = 1'b1;
      3'b010: is_word  = 1'b1;
      3'b100: is_ubyte = 1'b1;
      3'b101: is_uhb   = 1'b1;
      default: begin
              is_ubyte = 1'b0;
              is_sbyte = 1'b0;
              is_uhb   = 1'b0;
              is_shb   = 1'b0;
              is_word  = 1'b0;
              end
    endcase
    if( is_sbyte || is_ubyte) begin : bmask_align_sort
      case (i_lsu_addr[1:0])                      // check number of immediate
        2'b00: begin
                bmask_align    = 4'b0001;                 // byte 1
                bmask_misalign = 4'b0000;
               end
        2'b01: begin
                bmask_align    = 4'b0010;                 // byte 2
                bmask_misalign = 4'b0000;
               end
        2'b10: begin
                bmask_align    = 4'b0100;                 // byte 3
                bmask_misalign = 4'b0000;
               end
        2'b11: begin
                bmask_align    = 4'b1000;                 // byte 4
                bmask_misalign = 4'b0000;
               end
        default: begin
                bmask_align    = 4'b0000;
                bmask_misalign = 4'b0000;
               end
      endcase
    end else if ( is_shb || is_uhb) begin
      case (i_lsu_addr[1:0])                      // check number of immediate
        2'b00: begin
                bmask_align    = 4'b0011;                 // byte 1, 2
                bmask_misalign = 4'b0000;
               end
        2'b01: begin
                bmask_align    = 4'b0110;
                bmask_misalign = 4'b0000;
               end
        2'b10: begin
                bmask_align    = 4'b1100;                 // byte 3, 4
                bmask_misalign = 4'b0000;
               end
        2'b11: begin
                bmask_align    = 4'b1000;
                bmask_misalign = 4'b0001;
               end
        default: begin
                bmask_align    = 4'b0000;
                bmask_misalign = 4'b0000;
        end
      endcase
    end else if (is_word) begin
      case(i_lsu_addr[1:0])
          2'b00: begin
              bmask_align    = 4'b1111;
              bmask_misalign = 4'b0000;
          end
          2'b01: begin
              bmask_align    = 4'b1110;
              bmask_misalign = 4'b0001;
          end
          2'b10: begin
              bmask_align    = 4'b1100;
              bmask_misalign = 4'b0011;
          end
          2'b11: begin
              bmask_align    = 4'b1000;
              bmask_misalign = 4'b0111;
          end
        default: begin
              bmask_align    = 4'b0000;
              bmask_misalign = 4'b0000;
          end
      endcase
    end
  end

  assign dmem_ptr  =  i_lsu_addr[15:0];
  assign is_dmem   =  ~i_lsu_addr[28];                        //0000 -> bit 28 == 0
  assign is_out    =  (i_lsu_addr[28] && ~(i_lsu_addr[16])); //1000 -> a[28] & ~a[16]
  assign is_in     =  (i_lsu_addr[28] &&   i_lsu_addr[16] ); //1001 -> a[28] & a[16]

  assign is_ledr   = is_out && (~i_lsu_addr[14] && ~i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_0xxx
  assign is_ledg   = is_out && (~i_lsu_addr[14] && ~i_lsu_addr[13] &&  i_lsu_addr[12]); // 0x1000_1xxx
  assign is_hex03  = is_out && (~i_lsu_addr[14] &&  i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_2xxx
  assign is_hex47  = is_out && (~i_lsu_addr[14] &&  i_lsu_addr[13] &&  i_lsu_addr[12]); // 0x1000_3xxx
  assign is_lcd    = is_out && ( i_lsu_addr[14] && ~i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_4xxx
  assign is_sw     = is_in  && ( i_lsu_addr[16] && ~i_lsu_addr[13]                  ); // 0x1001_0xxx

  memory memory (
                .i_clk  (i_clk),
                .i_reset(i_reset),
                .i_func3(i_func3),
                .i_addr (dmem_ptr),
                .i_wdata(i_st_data),
                .i_bmask_align(bmask_align),
                .i_bmask_misalign(bmask_misalign),
                .i_wren (mem_wren),
                .o_rdata(dmem)
              );

  always_comb begin : st_data
    mem_wren  = 1'b0;
    ld_data   = 32'b0;
    st_wdata  = i_st_data;

    ledr_next = o_io_ledr;
    ledg_next = o_io_ledg;
    lcd_next  = o_io_lcd;
    hex0_next = o_io_hex0; hex1_next = o_io_hex1;
    hex2_next = o_io_hex2; hex3_next = o_io_hex3;
    hex4_next = o_io_hex4; hex5_next = o_io_hex5;
    hex6_next = o_io_hex6; hex7_next = o_io_hex7;

    if(is_dmem) begin
      if(i_lsu_wren) begin
        mem_wren = 1'b1;
        case (bmask_align)
          4'b0000: mem_wren = 1'b0;
          4'b0001,
          4'b0010,
          4'b0100: st_wdata = {24'b0, i_st_data[7:0]};
          4'b1000: st_wdata = i_st_data;
          4'b0011: st_wdata = {16'b0, i_st_data[15:0]};
          4'b1100: st_wdata = {       i_st_data[15:0], 16'b0};
          4'b1111: st_wdata =         i_st_data;
          default: begin
                   st_wdata = 32'b0;
                   mem_wren = 1'b0;
          end
        endcase
      end else begin
        ld_data = dmem;
      end
    end else if (i_lsu_wren && is_ledr) begin
        ledr_next = st_wdata;
    end else if (i_lsu_wren && is_ledg) begin
        ledg_next = st_wdata;
    end else if (i_lsu_wren && is_hex03) begin
          case (bmask_align)
            4'b0000: begin
              hex0_next = 7'b1111111;
              hex1_next = 7'b1111111;
              hex2_next = 7'b1111111;
              hex3_next = 7'b1111111;
            end
            4'b0001: hex0_next = st_wdata[6:0];
            4'b0010: hex1_next = st_wdata[6:0];
            4'b0100: hex2_next = st_wdata[6:0];
            4'b1000: hex3_next = st_wdata[6:0];
            4'b0011: begin
              hex0_next = st_wdata[6:0];
              hex1_next = st_wdata[14:8];
              hex2_next = 7'b0;
              hex3_next = 7'b0;
            end
            4'b1100: begin
              hex0_next = 7'b0;
              hex1_next = 7'b0;
              hex2_next = st_wdata[6:0];
              hex3_next = st_wdata[14:8];
            end
            4'b1111: begin
              hex0_next = st_wdata[6:0];
              hex1_next = st_wdata[14:8];
              hex2_next = st_wdata[22:16];
              hex3_next = st_wdata[30:24];
            end
            default: begin
              hex0_next = 7'b1111111;
              hex1_next = 7'b1111111;
              hex2_next = 7'b1111111;
              hex3_next = 7'b1111111;
            end
          endcase
      end else if (is_hex47 && i_lsu_wren) begin
        case (bmask_align)
          4'b0000: begin
            hex4_next = 7'b1111111;
            hex5_next = 7'b1111111;
            hex6_next = 7'b1111111;
            hex7_next = 7'b1111111;
          end
          4'b0001: hex4_next = st_wdata[6:0];
          4'b0010: hex5_next = st_wdata[6:0];
          4'b0100: hex6_next = st_wdata[6:0];
          4'b1000: hex7_next = st_wdata[6:0];
          4'b0011: begin
            hex4_next = st_wdata[6:0];
            hex5_next = st_wdata[14:8];
            hex6_next = 7'b0;
            hex7_next = 7'b0;
          end
          4'b1100: begin
            hex4_next = 7'b0;
            hex5_next = 7'b0;
            hex6_next = st_wdata[6:0];
            hex7_next = st_wdata[14:8];
          end
          4'b1111: begin
            hex4_next = st_wdata[6:0];
            hex5_next = st_wdata[14:8];
            hex6_next = st_wdata[22:16];
            hex7_next = st_wdata[30:24];
          end
          default: begin
            hex4_next = 7'b1111111;
            hex5_next = 7'b1111111;
            hex6_next = 7'b1111111;
            hex7_next = 7'b1111111;
          end
        endcase
      end else if (i_lsu_wren && is_lcd) begin
        lcd_next = st_wdata;
      end else if (~i_lsu_wren && is_sw) begin
        ld_data = i_io_sw;
      end
    end
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
        o_io_ledr <= 32'b0;
        o_io_ledg <= 32'b0;
        o_io_lcd  <= 32'b0;
        o_io_hex0 <= 7'b1111111;
        o_io_hex1 <= 7'b1111111;
        o_io_hex2 <= 7'b1111111;
        o_io_hex3 <= 7'b1111111;
        o_io_hex4 <= 7'b1111111;
        o_io_hex5 <= 7'b1111111;
        o_io_hex6 <= 7'b1111111;
        o_io_hex7 <= 7'b1111111;
    end else if (i_lsu_wren) begin
        o_io_ledr <= ledr_next;
        o_io_ledg <= ledg_next;
        o_io_lcd  <= lcd_next;
        o_io_hex0 <= hex0_next;
        o_io_hex1 <= hex1_next;
        o_io_hex2 <= hex2_next;
        o_io_hex3 <= hex3_next;
        o_io_hex4 <= hex4_next;
        o_io_hex5 <= hex5_next;
        o_io_hex6 <= hex6_next;
        o_io_hex7 <= hex7_next;
    end
  end

  always_comb begin
    o_ld_data = ld_data;
  end
endmodule
module encoder_16to4 (
    input       [15:0] y_i,
    output wire [3:0]  out_o
);
  assign out_o = (y_i[15]) ? 4'd15 :
                 (y_i[14]) ? 4'd14 :
                 (y_i[13]) ? 4'd13 :
                 (y_i[12]) ? 4'd12 :
                 (y_i[11]) ? 4'd11 :
                 (y_i[10]) ? 4'd10 :
                 (y_i[9])  ? 4'd9  :
                 (y_i[8])  ? 4'd8  :
                 (y_i[7])  ? 4'd7  :
                 (y_i[6])  ? 4'd6  :
                 (y_i[5])  ? 4'd5  :
                 (y_i[4])  ? 4'd4  :
                 (y_i[3])  ? 4'd3  :
                 (y_i[2])  ? 4'd2  :
                 (y_i[1])  ? 4'd1  :
                 (y_i[0])  ? 4'd0  : 4'd0;  // default
endmodule

module add_subtract (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input              cin_i,     // 0: Cộng, 1: Trừ
    output wire [31:0] result_o,
    output             cout_o
);
  wire [30:0] c;
  wire [31:0] b_mod_i;
  wire raw_cout;
  // Tính b XOR cin cho từng bit
  assign b_mod_i      = b_i ^ {32{cin_i}}; // nếu b_i là [3:0] và cin_i là 1 bit
  // FA[0]
  assign result_o[0]  =  a_i[0]  ^ b_mod_i[0]   ^ cin_i;
  assign c[0]         = (a_i[0]  & b_mod_i[0])  | ((a_i[0] ^ b_mod_i[0]) & cin_i);

  assign result_o[1]  =  a_i[1]  ^ b_mod_i[1]   ^ c[0];
  assign c[1]         = (a_i[1]  & b_mod_i[1])  | ((a_i[1] ^ b_mod_i[1]) & c[0]);

  assign result_o[2]  =  a_i[2]  ^ b_mod_i[2]   ^ c[1];
  assign c[2]         = (a_i[2]  & b_mod_i[2])  | ((a_i[2] ^ b_mod_i[2]) & c[1]);

  assign result_o[3]  =  a_i[3]  ^ b_mod_i[3]   ^ c[2];
  assign c[3]         = (a_i[3]  & b_mod_i[3])  | ((a_i[3] ^ b_mod_i[3]) & c[2]);

  assign result_o[4]  =  a_i[4]  ^ b_mod_i[4]   ^ c[3];
  assign c[4]         = (a_i[4]  & b_mod_i[4])  | ((a_i[4] ^ b_mod_i[4]) & c[3]);

  assign result_o[5]  =  a_i[5]  ^ b_mod_i[5]   ^ c[4];
  assign c[5]         = (a_i[5]  & b_mod_i[5])  | ((a_i[5] ^ b_mod_i[5]) & c[4]);

  assign result_o[6]  =  a_i[6]  ^ b_mod_i[6]   ^ c[5];
  assign c[6]         = (a_i[6]  & b_mod_i[6])  | ((a_i[6] ^ b_mod_i[6]) & c[5]);

  assign result_o[7]  =  a_i[7]  ^ b_mod_i[7]   ^ c[6];
  assign c[7]         = (a_i[7]  & b_mod_i[7])  | ((a_i[7] ^ b_mod_i[7]) & c[6]);

  assign result_o[8]  =  a_i[8]  ^ b_mod_i[8]   ^ c[7];
  assign c[8]         = (a_i[8]  & b_mod_i[8])  | ((a_i[8] ^ b_mod_i[8]) & c[7]);

  assign result_o[9]  =  a_i[9]  ^ b_mod_i[9]   ^ c[8];
  assign c[9]         = (a_i[9]  & b_mod_i[9])  | ((a_i[9] ^ b_mod_i[9]) & c[8]);

  assign result_o[10] =  a_i[10] ^ b_mod_i[10]  ^ c[9];
  assign c[10]        = (a_i[10] & b_mod_i[10]) | ((a_i[10] ^ b_mod_i[10]) & c[9]);

  assign result_o[11] =  a_i[11] ^ b_mod_i[11]  ^ c[10];
  assign c[11]        = (a_i[11] & b_mod_i[11]) | ((a_i[11] ^ b_mod_i[11]) & c[10]);

  assign result_o[12] =  a_i[12] ^ b_mod_i[12]  ^ c[11];
  assign c[12]        = (a_i[12] & b_mod_i[12]) | ((a_i[12] ^ b_mod_i[12]) & c[11]);

  assign result_o[13] =  a_i[13] ^ b_mod_i[13]  ^ c[12];
  assign c[13]        = (a_i[13] & b_mod_i[13]) | ((a_i[13] ^ b_mod_i[13]) & c[12]);

  assign result_o[14] =  a_i[14] ^ b_mod_i[14]  ^ c[13];
  assign c[14]        = (a_i[14] & b_mod_i[14]) | ((a_i[14] ^ b_mod_i[14]) & c[13]);

  assign result_o[15] =  a_i[15] ^ b_mod_i[15]  ^ c[14];
  assign c[15]        = (a_i[15] & b_mod_i[15]) | ((a_i[15] ^ b_mod_i[15]) & c[14]);

  assign result_o[16] =  a_i[16] ^ b_mod_i[16]  ^ c[15];
  assign c[16]        = (a_i[16] & b_mod_i[16]) | ((a_i[16] ^ b_mod_i[16]) & c[15]);

  assign result_o[17] =  a_i[17] ^ b_mod_i[17]  ^ c[16];
  assign c[17]        = (a_i[17] & b_mod_i[17]) | ((a_i[17] ^ b_mod_i[17]) & c[16]);

  assign result_o[18] =  a_i[18] ^ b_mod_i[18]  ^ c[17];
  assign c[18]        = (a_i[18] & b_mod_i[18]) | ((a_i[18] ^ b_mod_i[18]) & c[17]);

  assign result_o[19] =  a_i[19] ^ b_mod_i[19]  ^ c[18];
  assign c[19]        = (a_i[19] & b_mod_i[19]) | ((a_i[19] ^ b_mod_i[19]) & c[18]);

  assign result_o[20] =  a_i[20] ^ b_mod_i[20]  ^ c[19];
  assign c[20]        = (a_i[20] & b_mod_i[20]) | ((a_i[20] ^ b_mod_i[20]) & c[19]);

  assign result_o[21] =  a_i[21] ^ b_mod_i[21]  ^ c[20];
  assign c[21]        = (a_i[21] & b_mod_i[21]) | ((a_i[21] ^ b_mod_i[21]) & c[20]);

  assign result_o[22] =  a_i[22] ^ b_mod_i[22]  ^ c[21];
  assign c[22]        = (a_i[22] & b_mod_i[22]) | ((a_i[22] ^ b_mod_i[22]) & c[21]);

  assign result_o[23] =  a_i[23] ^ b_mod_i[23]  ^ c[22];
  assign c[23]        = (a_i[23] & b_mod_i[23]) | ((a_i[23] ^ b_mod_i[23]) & c[22]);

  assign result_o[24] =  a_i[24] ^ b_mod_i[24]  ^ c[23];
  assign c[24]        = (a_i[24] & b_mod_i[24]) | ((a_i[24] ^ b_mod_i[24]) & c[23]);

  assign result_o[25] =  a_i[25] ^ b_mod_i[25]  ^ c[24];
  assign c[25]        = (a_i[25] & b_mod_i[25]) | ((a_i[25] ^ b_mod_i[25]) & c[24]);

  assign result_o[26] =  a_i[26] ^ b_mod_i[26]  ^ c[25];
  assign c[26]        = (a_i[26] & b_mod_i[26]) | ((a_i[26] ^ b_mod_i[26]) & c[25]);

  assign result_o[27] =  a_i[27] ^ b_mod_i[27]  ^ c[26];
  assign c[27]        = (a_i[27] & b_mod_i[27]) | ((a_i[27] ^ b_mod_i[27]) & c[26]);

  assign result_o[28] =  a_i[28] ^ b_mod_i[28]  ^ c[27];
  assign c[28]        = (a_i[28] & b_mod_i[28]) | ((a_i[28] ^ b_mod_i[28]) & c[27]);

  assign result_o[29] =  a_i[29] ^ b_mod_i[29]  ^ c[28];
  assign c[29]        = (a_i[29] & b_mod_i[29]) | ((a_i[29] ^ b_mod_i[29]) & c[28]);

  assign result_o[30] =  a_i[30] ^ b_mod_i[30]  ^ c[29];
  assign c[30]        = (a_i[30] & b_mod_i[30]) | ((a_i[30] ^ b_mod_i[30]) & c[29]);

  assign result_o[31] =  a_i[31] ^ b_mod_i[31]  ^ c[30];
  assign cout_o       = cin_i ? ~((a_i[31] & b_mod_i[31]) | ((a_i[31] ^ b_mod_i[31]) & c[30])) :
                                 (a_i[31] & b_mod_i[31]) | ((a_i[31] ^ b_mod_i[31]) & c[30]);
endmodule

import package_param::*;
module immgen (
    input  wire [31:0] inst_i,
    output reg  [31:0] imm_o
);
  reg is_msb;
  always_comb begin : immgen_msb_extend
    case (inst_i[6:0])
      //Itype msb extend when func3 == 0, 2, 4, 5, 6, 7,
      IITYPE,
      ITYPE  : is_msb = (inst_i[14] | ~inst_i[12]);
      default: is_msb = 1'b0;
    endcase
  end
  always_comb begin : immgen_init
    case (inst_i[6:0])
      IITYPE,
      ILTYPE,
      ITYPE  : imm_o = (is_msb) ? {{20{inst_i[31]}}, inst_i[31:20]              }:
                                  {{20{1'b0      }}, inst_i[31:20]              };
      STYPE  : imm_o =            {{20{1'b0      }}, inst_i[31:25], inst_i[11:7]};
      BTYPE  : imm_o =            {{20{inst_i[31]}}, inst_i[31]   , inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
      IJTYPE : imm_o =            {{20{inst_i[31]}}, inst_i[31]   , inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
      U1TYPE,
      U2TYPE : imm_o =            {inst_i[31:12]   , {12{1'b0}}};
      default: imm_o = 32'd0;
    endcase
  end
endmodule

module mux_32to1 (
    input       [31:0] d0, d1, d2, d3, d4, d5, d6, d7,
                       d8, d9, d10, d11, d12, d13, d14, d15,
                       d16, d17, d18, d19, d20, d21, d22, d23,
                       d24, d25, d26, d27, d28, d29, d30, d31,
    input       [4:0]  s,       // select signal
    output wire [31:0] y_o          // output 32-bit
); 
 wire [31:0] mux_temp0, mux_temp1, mux_temp2, mux_temp3,
             mux_temp4, mux_temp5, mux_temp6, mux_temp7,
             mux_temp8, mux_temp9, mux_temp10, mux_temp11,
             mux_temp12, mux_temp13, mux_temp14, mux_temp15,
             mux_temp16, mux_temp17, mux_temp18, mux_temp19,
             mux_temp20, mux_temp21, mux_temp22, mux_temp23,
             mux_temp24, mux_temp25, mux_temp26, mux_temp27,
             mux_temp28, mux_temp29;

  assign mux_temp0 =  (s[0]) ? d1 : d0;
  assign mux_temp1 =  (s[0]) ? d3 : d2;
  assign mux_temp2 =  (s[0]) ? d5 : d4;
  assign mux_temp3 =  (s[0]) ? d7 : d6;
  assign mux_temp4 =  (s[0]) ? d9 : d8;
  assign mux_temp5 =  (s[0]) ? d11 : d10;
  assign mux_temp6 =  (s[0]) ? d13 : d12;
  assign mux_temp7 =  (s[0]) ? d15 : d14;
  assign mux_temp8 =  (s[0]) ? d17 : d16;
  assign mux_temp9 =  (s[0]) ? d19 : d18;
  assign mux_temp10 = (s[0]) ? d21 : d20;
  assign mux_temp11 = (s[0]) ? d23 : d22;
  assign mux_temp12 = (s[0]) ? d25 : d24;
  assign mux_temp13 = (s[0]) ? d27 : d26;
  assign mux_temp14 = (s[0]) ? d29 : d28;
  assign mux_temp15 = (s[0]) ? d31 : d30;

  assign mux_temp16 = (s[1]) ? mux_temp1 : mux_temp0;
  assign mux_temp17 = (s[1]) ? mux_temp3 : mux_temp2;
  assign mux_temp18 = (s[1]) ? mux_temp5 : mux_temp4;
  assign mux_temp19 = (s[1]) ? mux_temp7 : mux_temp6;
  assign mux_temp20 = (s[1]) ? mux_temp9 : mux_temp8;
  assign mux_temp21 = (s[1]) ? mux_temp11 : mux_temp10;
  assign mux_temp22 = (s[1]) ? mux_temp13 : mux_temp12;
  assign mux_temp23 = (s[1]) ? mux_temp15 : mux_temp14;

  assign mux_temp24 = (s[2]) ? mux_temp17 : mux_temp16;
  assign mux_temp25 = (s[2]) ? mux_temp19 : mux_temp18;
  assign mux_temp26 = (s[2]) ? mux_temp21 : mux_temp20;
  assign mux_temp27 = (s[2]) ? mux_temp23 : mux_temp22;
  assign mux_temp28 = (s[3]) ? mux_temp25 : mux_temp24;
  assign mux_temp29 = (s[3]) ? mux_temp27 : mux_temp26;

  assign y_o = (s[4]) ? mux_temp29 : mux_temp28;
endmodule

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
                              .i_clk      (i_clk      ),
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
                              .pc_sel     (pc_sel    ),sing
                              .o_inst_vld(o_insn_vld),
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
