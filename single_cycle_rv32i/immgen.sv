//====================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Immediate Generator
// File            : immgen.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 9/9/2025
//=====================================================================================================
import package_param::*;
module immgen (
    input  wire [31:0] inst_i,
    output reg [31:0]  imm_o
);
  bit is_msb;
  reg [6:0] opcode;
  assign opcode = inst_i[6:0];
  always_comb begin : immgen_init
    case (opcode)
      IITYPE,
      ILTYPE,
      ITYPE  : imm_o = (is_msb) ? {{20{inst_i[31]}}, inst_i[31:20]}:
                                  {{20'h00000}, inst_i[31:20]};
      STYPE  : imm_o =            {{20{inst_i[31]}},  inst_i[31:25], inst_i[11:7]};
      BTYPE  : imm_o = (is_msb) ? {{20{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0}:
                                  {{20'h00000}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
      IJTYPE : imm_o =            {{20{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
      U1TYPE,
      U2TYPE : imm_o =            {{20{inst_i[31]}}, inst_i[31:12]};
      default: imm_o = 32'd0;
    endcase
  end
  always_comb begin : immgen_msb_extend
    case (opcode)
      //Itype msb extend when func3 == 0, 5, 2
      //-> is_msb = ~(fun3[2].func3[0]) + (func3[2].func3[0].~func3[1])
      IITYPE,
      ITYPE  : is_msb = ~(inst_i[14] & inst_i[12]) | (inst_i[14] & inst_i[12] & ~inst_i[13]);
      //btype msb extend when func3 == 0, 1, 4, 5
      //-> is_msb = ~func3[1]
      BTYPE  : is_msb = ~inst_i[13];
      default: is_msb = 1'b0;
    endcase
  end
endmodule
