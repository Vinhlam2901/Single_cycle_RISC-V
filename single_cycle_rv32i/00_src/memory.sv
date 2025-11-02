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
  reg [31:0] mem [0: 16383]; // 2kB
  reg [31:0] mem_st;
  wire [13:0] i_addr_fix;

  assign i_addr_fix = i_addr >> 2;

  always_comb begin
    case (i_bmask)
      4'b0001: mem_st = {mem_st[31:24], mem_st[23:16], mem_st[15:8], i_wdata[ 7:0]};
      4'b0010: mem_st = {mem_st[31:24], mem_st[23:16], i_wdata[ 7:0], mem_st[7:0]};
      4'b0100: mem_st = {mem_st[31:24], i_wdata[ 7:0], mem_st[15:8], mem_st[7:0]};
      4'b1000: mem_st = {i_wdata[ 7:0], mem_st[23:16], mem_st[15:8], mem_st[7:0]};
      4'b0011: mem_st = {mem_st[31:16], i_wdata[15:0]};
      4'b1100: mem_st = {i_wdata[31:16], mem_st[15:0]};
      4'b1111: mem_st = i_wdata;
      default: mem_st = 32'b0;
    endcase
  end

  always_ff @(posedge i_clk or negedge i_reset) begin : mem_store
    if (~i_reset) begin : reset
      for(i = 0; i <= 16383; i = i + 1) begin
        mem[i] <= 32'b0;
      end
    end else if (i_wren) begin
      mem[i_addr_fix] <= mem_st;
    end
  end

  always_comb begin : mem_load
    o_rdata = mem[i_addr_fix];
  end
endmodule
