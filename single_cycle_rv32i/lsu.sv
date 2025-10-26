//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Load Store Unit
// File            : lsu.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 23/10/2025
//============================================================================================================
import package_param::*;
module lsu (
  input  wire        i_clk,
  input  wire        i_rst_n,

  input  wire [31:0] i_lsu_addr,
  input  wire [31:0] i_st_data,
  input  wire        i_lsu_wren,

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
  localparam DMEM_BASE     = 32'h0000_0000; // 0x000 - 0x7FF
  localparam PERI_OUT_BASE = 32'h1000_0800; // 0x800 - 0x9FF
  localparam PERI_IN_BASE  = 32'h1001_0000; // 0xA00 - 0xBFF

  reg  [31:0] lsu;
  reg  [31:0] ledr;
  reg  [31:0] ledg;
  reg  [ 6:0] hex0_3;
  reg  [ 6:0] hex4_7;
  reg  [31:0] lcd;
  reg  [31:0] sw;
  reg  [31:0] dmem;

  wire [11:0] dmem_ptr;
  wire [15:0] out_ptr;
  wire [11:0] in_ptr;

  reg  [31:0] ledr_reg;
  reg  [31:0] ledg_reg;
  reg  [31:0] hex03_reg;
  reg  [31:0] hex47_reg;
  reg  [31:0] lcd_reg;

  reg [3:0]  bmask;
  wire        is_dmem;
  wire        is_out;
  wire        is_in;

  wire        is_byte;
  wire        is_hb;

  wire        is_ledr;
  wire        is_ledg;
  wire        is_hex03;
  wire        is_hex47;
  wire        is_lcd;
  wire        is_sw;
//====================================CODE====================================================================
  assign is_byte = ~(i_st_data[8]  & 1'b0);
  assign is_hb   = ~(i_st_data[16] & 1'b0);

  always_comb begin
    if( is_byte ) begin : bmask_sort                         // lbu
      case (i_lsu_addr[1:0])                    // check number of immediate
        2'b00:   bmask = 4'b0001;                 // byte 1
        2'b01:   bmask = 4'b0010;                 // byte 2
        2'b10:   bmask = 4'b0100;                 // byte 3
        2'b11:   bmask = 4'b1000;                 // byte 4
        default: bmask = 4'b0000;
      endcase
    end else if ( is_hb ) begin                           // lhu
      case (bmask[1:0])                    // check number of immediate
        2'b00,
        2'b01:   bmask = 4'b0011;               // byte 1, 2
        2'b10,
        2'b11:   bmask = 4'b1100;               // byte 3, 4
        default: bmask = 4'b0000;
      endcase
    end else begin                       // lw, sw
                 bmask   = 4'b1111;
        end
    end

  assign dmem_ptr  = i_lsu_addr[11:0];
  assign out_ptr   = i_lsu_addr[15:0];
  assign in_ptr    = i_lsu_addr[11:0];

  assign is_dmem   = ~(i_lsu_addr[28] |   i_lsu_addr[16] ); //0000 -> ~(a[28] | a[16])
  assign is_out    =  (i_lsu_addr[28] & ~(i_lsu_addr[16])); //1000 -> a[28] & ~a[16]
  assign is_in     =  (i_lsu_addr[28] &   i_lsu_addr[16] ); //1001 -> a[28] & a[16]

  assign is_ledr   = is_out && (~i_lsu_addr[14] & ~i_lsu_addr[13] & ~i_lsu_addr[12]); // 0x1000_0xxx
  assign is_ledg   = is_out && (~i_lsu_addr[14] & ~i_lsu_addr[13] & i_lsu_addr[12] ); // 0x1000_1xxx
  assign is_hex03  = is_out && (~i_lsu_addr[14] &  i_lsu_addr[13] & ~i_lsu_addr[12]); // 0x1000_2xxx
  assign is_hex47  = is_out && (~i_lsu_addr[14] &  i_lsu_addr[13] &  i_lsu_addr[12]); // 0x1000_3xxx
  assign is_lcd    = is_out && ( i_lsu_addr[14] & ~i_lsu_addr[13] & ~i_lsu_addr[12]); // 0x1000_4xxx
  assign is_sw     = is_in  && ( i_lsu_addr[16] & ~i_lsu_addr[13]                  ); // 0x1001_0xxx

  memory memory (
                .i_clk  (i_clk),
                .i_rst_n(i_rst_n),
                .i_addr (dmem_ptr),
                .i_wdata(i_st_data),
                .i_bmask(bmask),
                .i_wren (i_lsu_wren),
                .o_rdata(dmem)
              );

  always_ff @(posedge i_clk or negedge i_rst_n) begin : lsu_store
    if (!i_rst_n) begin : reset
        ledr_reg  <= 32'b0;
        ledg_reg  <= 32'b0;
        hex03_reg <= 32'b0;
        hex47_reg <= 32'b0;
        lcd_reg   <= 32'b0;
    end else if (1'b1) begin
      if (is_out) begin : peri_data
        if( is_ledr ) begin
          ledr_reg  <= i_st_data;
        end else if ( is_ledg ) begin
          ledg_reg  <= i_st_data;
        end else if ( is_hex03 ) begin
          hex03_reg <= i_st_data;
        end else if ( is_hex47 ) begin
          hex47_reg <= i_st_data;
        end else if ( is_lcd ) begin
          lcd_reg   <= i_st_data;
        end
      end else if ( is_in ) begin
          sw        <= i_io_sw;
      end else if ( is_dmem) begin
          o_ld_data <= dmem;
      end
    end
  end

  always_comb begin : lsu_load
    if (is_out) begin
      if( is_ledr ) begin
        o_io_ledr = ledr_reg;
      end else if ( is_ledg ) begin
        o_io_ledg = ledg_reg;
      end else if ( is_hex03 ) begin
        o_io_hex0 = hex03_reg[6:0];
        o_io_hex1 = hex03_reg[13:7];
        o_io_hex2 = hex03_reg[20:14];
        o_io_hex3 = hex03_reg[27:21];
      end else if ( is_hex47 ) begin
        o_io_hex4 = hex47_reg[6:0];
        o_io_hex5 = hex47_reg[13:7];
        o_io_hex6 = hex47_reg[20:14];
        o_io_hex7 = hex47_reg[27:21];
      end else if ( is_lcd ) begin
        o_io_lcd  = lcd_reg;
      end
     end
    end

endmodule
