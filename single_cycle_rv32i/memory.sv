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
 input  wire        i_rst_n,
 input  reg  [11:0] i_addr,
 input  reg  [31:0] i_wdata,
 input  reg  [3:0]  i_bmask,
 input  reg         i_wren,
 output wire [31:0] o_rdata
);

  reg  [31:0] mem [0: 511]; // 2kB

  always_ff @(posedge i_clk or negedge i_rst_n) begin : mem_store
    if (~i_rst_n) begin : reset
        mem[i_addr] <= 32'b0;
    end else if (i_wren) begin
      case (i_bmask)
        4'b0001: mem[i_addr][ 7:0 ] <= i_wdata[ 7:0 ];
        4'b0010: mem[i_addr][15:8 ] <= i_wdata[ 7:0 ];
        4'b0100: mem[i_addr][23:16] <= i_wdata[ 7:0 ];
        4'b1000: mem[i_addr][31:24] <= i_wdata[ 7:0 ];
        4'b0011: mem[i_addr][15:0 ] <= i_wdata[15:0 ];
        4'b1100: mem[i_addr][31:16] <= i_wdata[31:16];
        4'b1111: mem[i_addr][31:0 ] <= i_wdata;
        default: mem[i_addr][31:0 ] <= 32'b0;
      endcase
    end
  end
  assign o_rdata = mem[i_addr];
endmodule
