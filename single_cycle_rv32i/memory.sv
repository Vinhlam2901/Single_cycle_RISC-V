//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Memory
// File            : memory.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 21/10/2025
// Updated date    : 21/10/2025
//=============================================================================================================
module memory (
 input  wire        i_clk,
 input  wire        i_reset,
 input  reg  [15:0] i_addr,
 input  reg  [31:0] i_wdata,
 input  reg  [3:0]  i_bmask,
 input  reg         i_wren,
 output reg [31:0] o_rdata
);
  integer  i;
  reg [31:0] mem [0: 65535]; // 2kB
  reg [31:0] mem_st;

  always_comb begin
    case (i_bmask)
      4'b0001: mem_st = {{24{1'b0}}, i_wdata[ 7:0 ]              };
      4'b0010: mem_st = {{16{1'b0}}, i_wdata[ 7:0 ], {{ 8{1'b0}}}};
      4'b0100: mem_st = {{ 8{1'b0}}, i_wdata[ 7:0 ], {{16{1'b0}}}};
      4'b1000: mem_st = {            i_wdata[ 7:0 ], {{24{1'b0}}}};
      4'b0011: mem_st = {{16{1'b0}}, i_wdata[15:0 ]              };
      4'b1100: mem_st = {            i_wdata[31:16], {{16{1'b0}}}};
      4'b1111: mem_st = i_wdata;
      default: mem_st = 32'b0;
    endcase
  end

  always_ff @(posedge i_clk or negedge i_reset) begin : mem_store
    if (~i_reset) begin : reset
      for(i = 0; i <= 65535; i = i + 1) begin
        mem[i] <= 32'b0;
      end
    end else if (i_wren) begin
      mem[i_addr] <= mem_st;
    end
  end

  always_comb begin : mem_load
    o_rdata = mem[i_addr];
  end
endmodule
