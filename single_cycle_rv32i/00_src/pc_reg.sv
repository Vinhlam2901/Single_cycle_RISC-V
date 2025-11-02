//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Program Counter Register
// File            : pc_reg.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 13/9/2025
//===========================================================================================
module pc_reg (
  input  wire          clk_i,
  input  wire          nrst_i,
  input  wire          pc_en_i,

  input  wire  [31:0]  pc_ins_i,
  output reg   [31:0]  pc_o
);
  reg [31:0] next_pc;
  always_ff @(posedge clk_i or negedge nrst_i) begin
    if (~nrst_i) begin
        pc_o <= 32'b0;
    end else if (pc_en_i) begin
        pc_o <= next_pc;
    end
  end
  // always_comb begin : pc_instruction
  //   next_pc = (pc_en_i) ? pc_ins_i + 32'd4 : pc_ins_i;
  // end
endmodule
