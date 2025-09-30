//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Single Cycle R-Type
// File            : single_cycle.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 28/9/2025
//=============================================================================================================
import package_param::*;
module single_cycle (
    input  wire  clk_i,
    input  wire  rst_ni,
    output reg   [31:0]  wb_data_o
  );
    //==================Declaration================================================================================
  wire          rd_wren, mem_wren;
  wire          br_unsign;
  wire          br_less;
  wire          br_equal;
  wire          pc_en_i;
  wire          pc_sel;
  wire          op1_sel, op2_sel;
  wire  [1:0]   wb_sel;
  wire  [4:0]   rdes_addr;
  wire  [4:0]   st_imm_addr;
  wire  [31:0]   st_imm;
  wire  [3:0]   alu_op;
  wire  [31:0]  rs1_data, op1;
  wire  [31:0]  rs2_data, op2;
  wire  [31:0]  imm_ex;
  //wire  [31:0]  rd_data_o;
  reg   [4:0]   bmask;
  reg   [10:0]  rd_address;
  reg   [31:0]  rd_data_o;
  reg   [31:0]  pc_reg;
  reg   [31:0]  wr_data;
  reg   [31:0]  inst;
  reg   [31:0]  next_pc;
  reg   [31:0]  read_data;
  reg   [31:0]  read_data_ex;
  reg   [31:0]  mem           [0:511];   //2kB //moi o nho la 1 word, dinh dia chi theo word

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
    next_pc = (1'b1) ? (pc_reg + 32'd4) : pc_reg;
  end
//==================IMEM=========================================================================================
  initial begin : instruction
    //mem[0]  = 32'h00300093; // addi x1, x0, 3
    // mem[1]  = 32'h00700113; // addi x2, x0, 7
    // mem[2]  = 32'h002081b3; // add x3, x1, x2
    // mem[3]  = 32'h40218233; // sub x4, x3, x2
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
//==================OPERATION_1=======================================================================================
  assign op1 = (op1_sel) ? pc_reg : rs1_data;
//==================OPERATION_2=======================================================================================
  assign op2 = (op2_sel) ? ((inst[6:0] == STYPE) ? st_imm : imm_ex)
                         : rs2_data;
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
  // always_comb begin : sign_extend
  //   read_data_ex = read_data;
  //   if(inst[6:0] == ILTYPE)
  //   case (alu_op)
  //     4'b0011: read_data_ex = {24'b0, read_data_ex[7:0]};  // lbu
  //     4'b0100: read_data_ex = {16'b0, read_data_ex[15:0]}; // lhu
  //     default: read_data_ex = read_data_ex & 32'hFFFFFFFF; // stay still
  //   endcase
  // end
//==================BRCOMP=========================================================================================
  brcomp    b1 (.rs1_i       (rs1_data),
                .rs2_i       (rs2_data),
                .br_unsign_i (br_unsign),
                .br_less     (br_less),
                .br_equal    (br_equal)
               );
//==================WRITEBACK=========================================================================================
  always_comb begin : write_back
    case (wb_sel)
    2'b00:   wb_data_o = ((inst[11:7]) == 5'b00000) ? 32'b0 : rd_data_o;
    2'b01:   wb_data_o = pc_reg;
    2'b10:   wb_data_o = read_data;
    default: wb_data_o = rd_data_o;
  endcase
end
  always_comb begin
    $strobe("--------------------------------------------------------");
    $strobe("ins = %h | opcode = %b | wb = %h        | op = %h ", inst, inst[6:0], wb_sel, alu_op);
    $strobe("rs1_addr = %h  | rs1 = %h   | rs2_addr = %h | rs2 = %h", inst[19:15], op1, inst[24:20], rs2_data);
    $strobe("rd_addr = %h   | data = %h  | rdes_addr = %h ", inst[11:7], wb_data_o, rdes_addr);
    $strobe("st_imm_addr = %b, st_imm = %h, rd_address = %h", st_imm_addr, st_imm, rd_address);
    $strobe("wr_data = %h, read_data = %h, bmask = %h, men_wr = %h", wr_data, read_data, bmask, mem_wren);
  end
endmodule
