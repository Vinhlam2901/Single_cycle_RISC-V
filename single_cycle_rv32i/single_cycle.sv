//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Single Cycle R-Type
// File            : single_cycle.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 8/10/2025
//=============================================================================================================
import package_param::*;
module single_cycle (
    input  wire          clk_i,
    input  wire          rst_ni,

    input  reg  [31:0]  io_sw_i,
    input  reg  [31:0]  io_key_i,
    output reg  [31:0]  io_ledg_o,
    output reg  [31:0]  io_ledr_o,

    output reg  [31:0]  io_hex0_o,
    output reg  [31:0]  io_hex1_o,
    output reg  [31:0]  io_hex2_o,
    output reg  [31:0]  io_hex3_o,
    output reg  [31:0]  io_hex4_o,
    output reg  [31:0]  io_hex5_o,
    output reg  [31:0]  io_hex6_o,
    output reg  [31:0]  io_hex7_o,

    output reg  [31:0]  io_lcd0_o,
    output reg  [31:0]  io_lcd1_o,
    output reg  [31:0]  io_lcd2_o,
    output reg  [31:0]  io_lcd3_o,
    output reg  [31:0]  io_lcd4_o,
    output reg  [31:0]  io_lcd5_o,
    output reg  [31:0]  io_lcd6_o,
    output reg  [31:0]  io_lcd7_o,

    output reg  [31:0]  wb_data_o
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
  wire  [3:0]   alu_op;
  wire  [31:0]  rs1_data;
  wire  [31:0]  rs2_data, op2;
  wire  [31:0]  imm_ex;
  reg           op1_sel;
  reg   [3:0]   bmask;
  reg   [31:0]  op1;
  reg   [11:0]  rd_address;
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
    next_pc = (wb_sel == 2'b01 || pc_sel == 1'b1) ? jmp_pc : (pc_reg + 32'd4);
  end
//==================IMEM=========================================================================================
  initial begin : instruction
    $readmemh("../00_src/single_cycle_rv32i/code.hex", mem);
  end

  // always_comb begin : next_instruction
  //   if (pc_reg[31:2] < 31) begin
  //       inst = mem[pc_reg[31:2]];
  //   end else begin
  //     inst = 32'h00000013; // NOP
  //   end
  // end
  assign inst = (~rst_ni) ? 32'h00000013 : mem[pc_reg[31:2]];
//==================REGFILE========================================================================================
  assign st_imm_addr = (inst[6:0] == STYPE)                       ? inst[11:7] : 5'b0;
  assign rdes_addr   = (inst[6:0] == STYPE || inst[6:0] == BTYPE) ? st_imm_addr : inst[11:7];
  regfile regfile (
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
  control_unit control_unit (
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
  immgen immgen  (
                  .inst_i (inst),
                  .imm_o  (imm_ex)
                 );
//==================BRCOMP=========================================================================================
  brcomp branch_compare (
                .rs1_i       (rs1_data),
                .rs2_i       (rs2_data),
                .br_unsign_i (br_unsign),
                .br_less     (br_less),
                .br_equal    (br_equal)
               );
//==================OPERATION_1=======================================================================================
  always_comb begin : op1_sel_branch
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
  assign op2 = (op2_sel) ? (imm_ex)
                         : ((inst[6:0] == BTYPE || inst[6:0] == ILTYPE ) ? imm_ex :rs2_data);
//==================ALU=================================================================================================
  alu     alu  (
                 .rs1_data_i  (op1),
                 .rs2_data_i  (op2),
                 .br_unsign_i (br_unsign),
                 .alu_op_i    (alu_op),
                 .rd_data_o   (rd_data_o)
                );
//==================DMEM=================================================================================================
  always_comb begin : rd_check_width
    // only has data in case stype or iltype,    = rs1 + imm
    rd_address = ( inst[6:0] == STYPE || inst[6:0] == ILTYPE) ? rd_data_o[11:0] : 10'b0;
    // has rs2'data if stype to store rs2'data to mem
    wr_data    = ( inst[6:0] == STYPE || inst[6:0] == ILTYPE) ? rs2_data       : 32'b0;
    if(inst[6:0] == STYPE || inst[6:0] == ILTYPE ) begin : bmask_sort
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
  lsu lsu (
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
    2'b01:   begin  : pc_jump
        case (inst[14:12])
        3'b000: jmp_pc = (br_equal == 1'b1)                                           ? rd_data_o : (pc_reg + 32'd4); // beq
        3'b001: jmp_pc = (br_equal == 1'b0)                                           ? rd_data_o : (pc_reg + 32'd4); // blt
        3'b100: jmp_pc = (br_less  == 1'b1)                                           ? rd_data_o : (pc_reg + 32'd4); // bge
        3'b101: jmp_pc = (br_less  == 1'b0 && br_equal  == 1'b0)                      ? rd_data_o : (pc_reg + 32'd4); // bltu
        3'b110: jmp_pc = (br_less  == 1'b1 && br_unsign == 1'b1)                      ? rd_data_o : (pc_reg + 32'd4); // bgeu
        3'b111: jmp_pc = (br_less  == 1'b0 && br_equal  == 1'b0 && br_unsign == 1'b1) ? rd_data_o : (pc_reg + 32'd4);
        default:jmp_pc = rd_data_o;
      endcase
      end
    2'b10:   begin : io_data
      case (rd_address)
        12'h800,12'h801,12'h802,12'h803: io_lcd7_o = read_data;
        12'h804,12'h805,12'h806,12'h807: io_lcd6_o = read_data;
        12'h808,12'h809,12'h80A,12'h80B: io_lcd5_o = read_data;
        12'h80C,12'h80D,12'h80E,12'h80F: io_lcd4_o = read_data;
        12'h810,12'h811,12'h812,12'h813: io_lcd3_o = read_data;
        12'h814,12'h815,12'h816,12'h817: io_lcd2_o = read_data;
        12'h818,12'h819,12'h81A,12'h81B: io_lcd1_o = read_data;
        12'h81C,12'h81D,12'h81E,12'h81F: io_lcd0_o = read_data;
        //========================HEX==========================================
        12'h820:                         io_hex7_o = read_data;
        12'h824:                         io_hex6_o = read_data;
        12'h828:                         io_hex5_o = read_data;
        12'h82C:                         io_hex4_o = read_data;
        12'h830:                         io_hex3_o = read_data;
        12'h834:                         io_hex2_o = read_data;
        12'h838:                         io_hex1_o = read_data;
        12'h83C:                         io_hex0_o = read_data;
        //========================LED_R===================================
        12'h840:                         io_ledr_o = read_data;
        12'h844:                         io_ledg_o = read_data;
        12'hA00:                         wb_data_o = io_key_i;
        12'hA04:                         wb_data_o = io_sw_i;
        default:                         wb_data_o = read_data;
      endcase

    end
    2'b11:   begin : pc_select
      wb_data_o = (pc_sel) ? (pc_reg + 32'd4) : 32'b0;
      jmp_pc    = (pc_sel) ? rd_data_o        : (pc_reg + 32'd4);
      end
    default: wb_data_o = rd_data_o;
  endcase
end
  always_comb begin
    $strobe("----------------------------------------------------------------------------------------");
    $strobe("ins = %h | opcode = %b | wb = %h        | op = %h ", inst, inst[6:0], wb_sel, alu_op);
    $strobe("rs1_addr = %h  | rs1 = %h   | rs2_addr = %h | rs2 = %h", inst[19:15], op1, inst[24:20], op2);
    $strobe("rd_addr = %h   | data = %h  | rdes_addr = %h ", inst[11:7], wb_data_o, rdes_addr);
    $strobe("imm_ex = %h, br_equal = %b, read_data = %h", imm_ex, br_equal, read_data);
    $strobe("rd_address = %h, pc_reg = %h, next_pc = %h, io_ledr_o = %h", rd_address, pc_reg, next_pc, io_ledr_o);
  end
endmodule
