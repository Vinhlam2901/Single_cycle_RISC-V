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
  input  wire        i_reset,

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

  reg  [31:0] ledr;
  reg  [31:0] ledg;
  reg  [ 6:0] hex0_3;
  reg  [ 6:0] hex4_7;
  reg  [31:0] lcd;
  reg  [31:0] dmem;

  wire [15:0] dmem_ptr;
  wire [15:0] out_ptr;
  wire [11:0] in_ptr;

  // next signals cho I/O
  reg [31:0] ledr_next, ledg_next, lcd_next;
  reg [6:0]  hex0_next, hex1_next, hex2_next, hex3_next;
  reg [6:0]  hex4_next, hex5_next, hex6_next, hex7_next;

  reg [31:0] st_wdata;
  reg [31:0] ld_data;
  reg [15:0] halfword_out;
  reg [7:0]  byte_out;

  reg [3:0]  bmask;
  reg        mem_wren;
  wire        is_dmem;
  wire        is_out;
  wire        is_in;

  reg        is_byte;
  reg        is_hb;
  reg        is_word;

  wire        is_ledr;
  wire        is_ledg;
  wire        is_hex03;
  wire        is_hex47;
  wire        is_lcd;
  wire        is_sw;
//====================================CODE====================================================================

  always_comb begin
    is_byte = 1'b0;
    is_hb   = 1'b0;
    is_word = 1'b0;
    if(i_lsu_addr[0] && (i_st_data[31:8] === 24'b0)) begin
      is_byte = 1'b1;
    end else if (~i_lsu_addr[0] && (i_st_data[15:0] === 16'b0)) begin
      is_hb = 1'b1;
    end else begin
      is_word = 1'b1;
    end
    if( is_byte ) begin : bmask_sort
      case (i_lsu_addr[1:0])                      // check number of immediate
        2'b00:   bmask = 4'b0001;                 // byte 1
        2'b01:   bmask = 4'b0010;                 // byte 2
        2'b10:   bmask = 4'b0100;                 // byte 3
        2'b11:   bmask = 4'b1000;                 // byte 4
        default: bmask = 4'b0000;
      endcase
    end else if ( is_hb ) begin
      case (i_lsu_addr[1:0])                      // check number of immediate
        2'b01,
        2'b11:   bmask = 4'b0000;
        2'b00:   bmask = 4'b0011;                 // byte 1, 2
        2'b10:   bmask = 4'b1100;                 // byte 3, 4
        default: bmask = 4'b0000;
      endcase
    end else if (is_word) begin
                 bmask   = 4'b1111;
    end
  end

  assign dmem_ptr  = i_lsu_addr[15:0];

  assign is_dmem   = ~i_lsu_addr[28]; //0000 -> bit 28 == 0
  assign is_out    =  (i_lsu_addr[28] && ~(i_lsu_addr[16])); //1000 -> a[28] & ~a[16]
  assign is_in     =  (i_lsu_addr[28] &&   i_lsu_addr[16] ); //1001 -> a[28] & a[16]

  assign is_ledr   = is_out && (~i_lsu_addr[14] && ~i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_0xxx  // bug
  assign is_ledg   = is_out && (~i_lsu_addr[14] && ~i_lsu_addr[13] &&  i_lsu_addr[12]); // 0x1000_1xxx
  assign is_hex03  = is_out && (~i_lsu_addr[14] &&  i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_2xxx
  assign is_hex47  = is_out && (~i_lsu_addr[14] &&  i_lsu_addr[13] &&  i_lsu_addr[12]); // 0x1000_3xxx
  assign is_lcd    = is_out && ( i_lsu_addr[14] && ~i_lsu_addr[13] && ~i_lsu_addr[12]); // 0x1000_4xxx
  assign is_sw     = is_in  && ( i_lsu_addr[16] && ~i_lsu_addr[13]                  ); // 0x1001_0xxx

  memory memory (
                .i_clk  (i_clk),
                .i_reset(i_reset),
                .i_addr (dmem_ptr),
                .i_wdata(st_wdata),
                .i_bmask(bmask),
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
        case (bmask)
          4'b0000: mem_wren = 1'b0;
          4'b0001: st_wdata = {{24{1'b0}}, i_st_data[7:0]               };
          4'b0010: st_wdata = {{16{1'b0}}, i_st_data[7:0],  {8{1'b0}}   };
          4'b0100: st_wdata = {{8{1'b0}} , i_st_data[7:0],  {{16{1'b0}}}};
          4'b1000: st_wdata = {            i_st_data[7:0],  {{24{1'b0}}}};
          4'b0011: st_wdata = {{16{1'b1}}, i_st_data[15:0]              };
          4'b1100: st_wdata = {            i_st_data[15:0], {{16{1'b0}}}};
          4'b1111: st_wdata =              i_st_data;
          default: begin
            st_wdata = 32'b0;
            mem_wren = 1'b0;
          end
        endcase
      end else begin
        ld_data = dmem;
      end
    end else if (i_lsu_wren && is_ledr) begin
        ledr_next = i_st_data;
    end else if (i_lsu_wren && is_ledr) begin
        ledg_next = i_st_data;
    end else if (i_lsu_wren && is_hex03) begin
          case (bmask)
            4'b0000: begin
              hex0_next = 7'b0;
              hex1_next = 7'b0;
              hex2_next = 7'b0;
              hex3_next = 7'b0;
            end
            4'b0001: hex0_next = i_st_data[6:0];
            4'b0010: hex1_next = i_st_data[6:0];
            4'b0100: hex2_next = i_st_data[6:0];
            4'b1000: hex3_next = i_st_data[6:0];
            4'b0011: begin
              hex0_next = i_st_data[6:0];
              hex1_next = i_st_data[14:8];
              hex2_next = 7'b0;
              hex3_next = 7'b0;
            end
            4'b1100: begin
              hex0_next = 7'b0;
              hex1_next = 7'b0;
              hex2_next = i_st_data[6:0];
              hex3_next = i_st_data[14:8];
            end
            4'b1111: begin
              hex0_next = i_st_data[6:0];
              hex1_next = i_st_data[14:8];
              hex2_next = i_st_data[22:16];
              hex3_next = i_st_data[30:24];
            end
            default: begin
              hex0_next = 7'b0;
              hex1_next = 7'b0;
              hex2_next = 7'b0;
              hex3_next = 7'b0;
            end
          endcase
      end else if (is_hex47) begin
        if(i_lsu_wren && (bmask == 4'b1111)) begin
          hex4_next = i_st_data[6:0];
          hex5_next = i_st_data[14:8];
          hex6_next = i_st_data[22:16];
          hex7_next = i_st_data[30:24];
        end
      end else if (i_lsu_wren && is_lcd) begin
        lcd_next = i_st_data;
      end else if (~i_lsu_wren) begin
        ld_data = i_io_sw;
      end
    end
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        o_io_ledr <= 32'b0;
        o_io_ledg <= 32'b0;
        o_io_lcd  <= 32'b0;
        o_io_hex0 <= 7'b0; o_io_hex1 <= 7'b0;
        o_io_hex2 <= 7'b0; o_io_hex3 <= 7'b0;
        o_io_hex4 <= 7'b0; o_io_hex5 <= 7'b0;
        o_io_hex6 <= 7'b0; o_io_hex7 <= 7'b0;
    end else begin
        o_io_ledr <= ledr_next;
        o_io_ledg <= ledg_next;
        o_io_lcd  <= lcd_next;
        o_io_hex0 <= hex0_next; o_io_hex1 <= hex1_next;
        o_io_hex2 <= hex2_next; o_io_hex3 <= hex3_next;
        o_io_hex4 <= hex4_next; o_io_hex5 <= hex5_next;
        o_io_hex6 <= hex6_next; o_io_hex7 <= hex7_next;
    end
  end

  always_comb begin
    halfword_out = i_lsu_addr[1] ? {ld_data[31:16], {16{1'b0}}} : {{16{1'b0}}, ld_data[15:0]};

    case (i_lsu_addr[1:0])
        2'b00:   byte_out = ld_data[ 7:0 ];
        2'b01:   byte_out = ld_data[15:8 ];
        2'b10:   byte_out = ld_data[23:16];
        2'b11:   byte_out = ld_data[31:24];
        default: byte_out = 8'b0;
    endcase
  end

  always_comb begin
      case (bmask)
          4'b0001,
          4'b0010,
          4'b0100,
          4'b1000: o_ld_data = (i_st_data[31]) ? ({{24{byte_out[7]}}, byte_out}) : ({24'b0, byte_out});
          4'b0011,
          4'b1100: o_ld_data = (i_st_data[31]) ? ({{16{halfword_out[15]}}, halfword_out}) : {16'b0, halfword_out};
          4'b1111: o_ld_data = ld_data;
          default: o_ld_data = 32'b0;
      endcase
  end
endmodule
