//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Single Cycle R-Type
// File            : single_cycle.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 3/10/2025
//=============================================================================================================
import package_param::*;
module single_cycle (
    input  wire          clk_i,
    input  wire          rst_ni,
    output reg   [31:0]  wb_data_o
  );
    //==================Declaration================================================================================
  wire          rd_wren, mem_wren;
  wire          br_unsign;
  wire          br_less;
  wire          br_equal;
  wire          pc_en_i;
  wire          pc_sel;
  wire          op2_sel;
  wire  [1:0]   wb_sel;
  wire  [4:0]   rdes_addr;
  wire  [4:0]   st_imm_addr;
  wire  [31:0]  st_imm;
  wire  [3:0]   alu_op;
  wire  [31:0]  rs1_data;
  wire  [31:0]  rs2_data, op2;
  wire  [31:0]  imm_ex;
  //wire  [31:0]  rd_data_o;
  reg           op1_sel;
  reg   [31:0]  op1;
  reg   [4:0]   bmask;
  reg   [8:0]   rd_address;
  reg   [31:0]  rd_data_o;
  reg   [31:0]  pc_reg;
  reg   [31:0]  wr_data;
  reg   [31:0]  inst;
  reg   [31:0]  next_pc;
  reg   [31:0]  jmp_pc;
  reg   [31:0]  read_data;
  reg   [31:0]  read_data_ex;
  reg   [31:0]  mem           [0:511];   //2kB

//==================Instance=====================================================================================
//==================PC=============================================================================================
  always_ff @(posedge clk_i or negedge rst_ni) begin: pc_register
    if (~rst_ni) begin
        pc_reg <= 32'b0;
    end else begin
        pc_reg <= next_pc;
    end
  end

  always_comb begin : pc_instruction
    next_pc = (wb_sel == 2'b01) ? jmp_pc : (pc_reg + 32'd4);
  end
//==================IMEM=========================================================================================
  initial begin : instruction
    $readmemh("../00_src/single_cycle_rv32i/code.hex", mem);
  end

  always_comb begin
    if (pc_reg[31:2] < 31)
        inst = mem[pc_reg[31:2]];
    else
        inst = 32'h00000013; // NOP
  end
//==================REGFILE========================================================================================
  assign st_imm_addr = (inst[6:0] == STYPE)                       ? inst[11:7] : 5'b0;
  assign rdes_addr   = (inst[6:0] == STYPE || inst[6:0] == BTYPE) ? st_imm_addr : inst[11:7];
  assign st_imm      = {{27{st_imm_addr[4]}}, st_imm_addr[4:0]};
  regfile regfile_uut (
                  .clk_i      (clk_i),
                  .rst_ni     (rst_ni),
                  .enb_i      (1'b1),
                  .rs1_addr_i (inst[19:15]),
                  .rs2_addr_i (inst[24:20]),
                  .rd_addr_i  (rdes_addr),
                  .rd_data_i  (wb_data_o),
                  .rd_wren_i  (rd_wren),       // control unit is here
                  .rs1_data_o (rs1_data),
                  .rs2_data_o (rs2_data)
                 );
//==================CONTROL_UNIT=====================================================================================
  control_unit c1 (
                   .instruction(inst),
                   .pc_sel     (pc_sel),
                   .br_unsign  (br_unsign),
                   .op1_sel    (op1_sel),
                   .op2_sel    (op2_sel),
                   .alu_opcode (alu_op),
                   .rd_wren    (rd_wren),
                   .wb_sel     (wb_sel),
                   .mem_wren   (mem_wren)
                  );
//==================IMMGEN==============================================================================================
  immgen      i1 (
                  .inst_i (inst),
                  .imm_o  (imm_ex)
                 );
//==================BRCOMP=========================================================================================
  brcomp    b1 (.rs1_i       (rs1_data),
                .rs2_i       (rs2_data),
                .br_unsign_i (br_unsign),
                .br_less     (br_less),
                .br_equal    (br_equal)
               );
//==================OPERATION_1=======================================================================================
  always_comb begin
    if(inst[6:0] == BTYPE) begin
      case (inst[14:12])
        3'b000: op1 = (br_equal == 1'b1)                                           ? pc_reg : rs1_data; // beq
        3'b001: op1 = (br_equal == 1'b0)                                           ? pc_reg : rs1_data; // blt
        3'b100: op1 = (br_less  == 1'b1)                                           ? pc_reg : rs1_data; // bge
        3'b101: op1 = (br_less  == 1'b0 && br_equal  == 1'b0)                      ? pc_reg : rs1_data; // bltu
        3'b110: op1 = (br_less  == 1'b1 && br_unsign == 1'b1)                      ? pc_reg : rs1_data; // bgeu
        3'b111: op1 = (br_less  == 1'b0 && br_equal  == 1'b0 && br_unsign == 1'b1) ? pc_reg : rs1_data;
        default:op1 = op1;
      endcase
    end else begin
      op1 = (op1_sel) ? pc_reg : rs1_data;
    end
  end
//==================OPERATION_2=======================================================================================
  assign op2 = (op2_sel) ? ((inst[6:0] == STYPE) ? st_imm : imm_ex)
                         : ((inst[6:0] == BTYPE) ? imm_ex :rs2_data);
//==================ALU=================================================================================================
  alu        a2 (.rs1_data_i  (op1),
                 .rs2_data_i  (op2),
                 .br_unsign_i (br_unsign),
                 .alu_op_i    (alu_op),
                 .rd_data_o   (rd_data_o)
                );
//==================DMEM=================================================================================================
  always_comb begin : rd_check_width
    // only has data in case stype or iltype, rd_address = rs1 + imm
    rd_address = ( inst[6:0] == STYPE || inst[6:0] == ILTYPE) ? rd_data_o[9:0] : 10'b0;
    // has rs2'data if stype to store rs2'data to mem
    wr_data    = ( inst[6:0] == STYPE || inst[6:0] == ILTYPE) ? rs2_data       : 32'b0;
    if(inst[6:0] == STYPE || inst[6:0] == ILTYPE ) begin
      case (inst[14:12])                            // check func3
        3'b0,                                       // lb, sb
        3'b100 : begin                              // lbu
          wr_data  = wr_data  & 8'hFF;
          case (rd_address[1:0])                    // check number of immediate
          2'b00:     bmask = 4'b0001;                 // byte 1
          2'b01:     bmask = 4'b0010;                 // byte 2
          2'b10:     bmask = 4'b0100;                 // byte 3
          2'b11:     bmask = 4'b1000;                 // byte 4
          default:   bmask = 4'b0000;
        endcase
        end
        3'b001,                                     // lh, sh
        3'b101 : begin                              // lhu
          wr_data  = wr_data  & 16'hFFFF;
          case (rd_address[1:0])                    // check number of immediate
            2'b00,
            2'b01:   bmask = 4'b0011;               // byte 1, 2
            2'b10,
            2'b11:   bmask = 4'b1100;               // byte 3, 4
            default: bmask = 4'b0000;
          endcase
        end
        3'b010 : begin                              // lw, sw
          wr_data = wr_data  & 32'hFFFFFFFF;
                     bmask   = 4'b1111;
        end
        default : begin
          wr_data = wr_data  & 32'hFFFFFFFF;
        end
      endcase
    end
  end
  dmem d1 (
           .clk_i      (clk_i),
           .rst_ni     (rst_ni),
           .mem_wren   (mem_wren),
           .rd_addr_i  (rd_address),
           .wr_data    (wr_data),
           .bmask_i    (bmask),
           .rd_data    (read_data)
  );
//==================WRITEBACK=========================================================================================
  always_comb begin : write_back
    case (wb_sel)
    2'b00:   wb_data_o = ((inst[11:7]) == 5'b00000) ? 32'b0 : rd_data_o;
    2'b01:   begin
        case (inst[14:12])
        3'b000: jmp_pc = (br_equal == 1'b1)                                           ? rd_data_o : (pc_reg + 32'd4); // beq
        3'b001: jmp_pc = (br_equal == 1'b0)                                           ? rd_data_o : (pc_reg + 32'd4); // blt
        3'b100: jmp_pc = (br_less  == 1'b1)                                           ? rd_data_o : (pc_reg + 32'd4); // bge
        3'b101: jmp_pc = (br_less  == 1'b0 && br_equal  == 1'b0)                      ? rd_data_o : (pc_reg + 32'd4); // bltu
        3'b110: jmp_pc = (br_less  == 1'b1 && br_unsign == 1'b1)                      ?  rd_data_o : (pc_reg + 32'd4); // bgeu
        3'b111: jmp_pc = (br_less  == 1'b0 && br_equal  == 1'b0 && br_unsign == 1'b1) ? rd_data_o : (pc_reg + 32'd4);
        default:jmp_pc = rd_data_o;
      endcase
      end
    2'b10:   wb_data_o = read_data;
    default: wb_data_o = rd_data_o;
  endcase
end
  always_comb begin
    $strobe("----------------------------------------------------------------------------------------");
    $strobe("ins = %h | opcode = %b | wb = %h        | op = %h ", inst, inst[6:0], wb_sel, alu_op);
    $strobe("rs1_addr = %h  | rs1 = %h   | rs2_addr = %h | rs2 = %h", inst[19:15], op1, inst[24:20], op2);
    $strobe("rd_addr = %h   | data = %h  | rdes_addr = %h ", inst[11:7], wb_data_o, rdes_addr);
    $strobe("imm_ex = %h, br_less = %b, br_equal = %b", imm_ex, br_less, br_equal);
    $strobe("jmp_pc = %h, pc_reg = %h, next_pc = %h", jmp_pc, pc_reg, next_pc);
  end
endmodule