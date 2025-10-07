//===========================================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Load Store Unit
// File            : lsu.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 4/10/2025
//=============================================================================================================
module lsu (
  input  wire        clk_i,
  input  wire        rst_ni,
  input  wire        mem_wren,
  input  wire [11:0] rd_addr_i,  // memory addr 2^12 = 4096
  input  wire [31:0] wr_data,
  input  wire [3:0]  bmask_i,
  output reg  [31:0] rd_data
);
//
  reg  [7:0] lsu             [0: 4095]; // 0 - FFF
  localparam DMEM_BASE     = 12'h000; // 0x000 - 0x7FF
  localparam PERI_OUT_BASE = 12'h800; // 0x800 - 0x9FF
  localparam PERI_IN_BASE  = 12'hA00; // 0xA00 - 0xBFF
  localparam RESV_BASE     = 12'hC00; // 0xC00 - 0xFFF


  wire [11:0] rd_addr_fix;
  wire [10:0] dmem_addr;

  reg  [31:0] lcd_7, lcd_6, lcd_5, lcd_4, lcd_3, lcd_2, lcd_1, lcd_0;
  reg  [31:0] hex_7, hex_6, hex_5, hex_4, hex_3, hex_2, hex_1, hex_0;
  reg  [31:0] led_r;
  reg  [31:0] led_g;

  reg  [7:0] key;
  reg  [7:0] sw;


  assign rd_addr_fix = rd_addr_i >> 2;
  assign dmem_addr = rd_addr_fix[10:0];

  always_ff @(posedge clk_i or negedge rst_ni) begin : lsu_store
    if (!rst_ni) begin
        lsu[rd_addr_fix] <= 32'b0;
    end else if (mem_wren) begin
      if(rd_addr_fix < PERI_OUT_BASE) begin
      case (bmask_i)
        4'b0001: lsu[dmem_addr    ] <= wr_data[7:0];
        4'b0010: lsu[dmem_addr + 1] <= wr_data[7:0];
        4'b0100: lsu[dmem_addr + 2] <= wr_data[7:0];
        4'b1000: lsu[dmem_addr + 3] <= wr_data[7:0];
        4'b0011: begin
                 lsu[dmem_addr    ] <= wr_data[7:0];
                 lsu[dmem_addr + 1] <= wr_data[15:8];
                 end
        4'b1100: begin
                 lsu[dmem_addr + 2] <= wr_data[23:16];
                 lsu[dmem_addr + 3] <= wr_data[31:24];
                end
        4'b1111: begin
                 lsu[dmem_addr    ] <= wr_data[7:0];
                 lsu[dmem_addr + 1] <= wr_data[15:8];
                 lsu[dmem_addr + 2] <= wr_data[23:16];
                 lsu[dmem_addr + 3] <= wr_data[31:24];
                end
        default: lsu[dmem_addr]     <= wr_data[7:0];
      endcase
      end else if (rd_addr_fix < PERI_IN_BASE && rd_addr_fix > PERI_OUT_BASE) begin
        case (rd_addr_i_fix)
        //========================LCD===================================
        12'h800: lcd_7[ 7:0 ] <= wr_data[ 7:0 ];
        12'h801: lcd_7[15:8 ] <= wr_data[15:8 ];
        12'h802: lcd_7[23:16] <= wr_data[23:16];
        12'h803: lcd_7[31:24] <= wr_data[31:24];

        12'h804: lcd_6[ 7:0 ] <= wr_data[ 7:0 ];
        12'h805: lcd_6[15:8 ] <= wr_data[15:8 ] ;
        12'h806: lcd_6[23:16] <= wr_data[23:16];
        12'h807: lcd_6[31:24] <= wr_data[31:24];

        12'h808: lcd_5[ 7:0 ] <= wr_data[ 7:0 ];
        12'h809: lcd_5[15:8 ] <= wr_data[15:8 ] ;
        12'h80A: lcd_5[23:16] <= wr_data[23:16];
        12'h80B: lcd_5[31:24] <= wr_data[31:24];

        12'h80C: lcd_4[ 7:0 ] <= wr_data[ 7:0 ];
        12'h80D: lcd_4[15:8 ] <= wr_data[15:8 ] ;
        12'h80E: lcd_4[23:16] <= wr_data[23:16];
        12'h80F: lcd_4[31:24] <= wr_data[31:24];

        12'h810: lcd_3[ 7:0 ] <= wr_data[ 7:0 ];
        12'h811: lcd_3[15:8 ] <= wr_data[15:8 ] ;
        12'h812: lcd_3[23:16] <= wr_data[23:16];
        12'h813: lcd_3[31:24] <= wr_data[31:24];

        12'h814: lcd_2[ 7:0 ] <= wr_data[ 7:0 ];
        12'h815: lcd_2[15:8 ] <= wr_data[15:8 ] ;
        12'h816: lcd_2[23:16] <= wr_data[23:16];
        12'h817: lcd_2[31:24] <= wr_data[31:24];

        12'h818: lcd_1[ 7:0 ] <= wr_data[ 7:0 ];
        12'h819: lcd_1[15:8 ] <= wr_data[15:8 ] ;
        12'h81A: lcd_1[23:16] <= wr_data[23:16];
        12'h81B: lcd_1[31:24] <= wr_data[31:24];

        12'h81C: lcd_0[ 7:0 ] <= wr_data[ 7:0 ];
        12'h81D: lcd_0[15:8 ] <= wr_data[15:8 ] ;
        12'h81E: lcd_0[23:16] <= wr_data[23:16];
        12'h81F: lcd_0[31:24] <= wr_data[31:24];
        //========================HEX===================================
        // 8 FIRST BIT USABLE
        12'h820: hex_7[7:0]   <= wr_data[7:0];
        12'h824: hex_6[7:0]   <= wr_data[7:0];
        12'h840: led_r[7:0]   <= wr_data[7:0];
        12'h828: hex_5[7:0]   <= wr_data[7:0];
        12'h82C: hex_4[7:0]   <= wr_data[7:0];
        12'h830: hex_3[7:0]   <= wr_data[7:0];
        12'h834: hex_2[7:0]   <= wr_data[7:0];
        12'h838: hex_1[7:0]   <= wr_data[7:0];
        12'h83C: hex_0[7:0]   <= wr_data[7:0];
        //========================LED_R===================================
        12'h840: led_r[7:0]   <= wr_data[7:0];
        12'h844: led_g[7:0]   <= wr_data[7:0];
        default: ;
      endcase
      end
    end
  end

  // READ logic (asynchronous read)
  always_comb begin
    if(rd_addr_fix < PERI_OUT_BASE) begin : lsu_load
    case (bmask_i)
      4'b0001: rd_data = {{24{lsu[dmem_addr][7]}}, lsu[dmem_addr]};
      4'b0010: rd_data = {{24{lsu[dmem_addr][7]}}, lsu[dmem_addr + 1]};
      4'b0100: rd_data = {{24{lsu[dmem_addr][7]}}, lsu[dmem_addr + 2]};
      4'b1000: rd_data = {{24{lsu[dmem_addr][7]}}, lsu[dmem_addr + 3]};
      4'b0011: rd_data = {{16{lsu[dmem_addr][7]}}, lsu[dmem_addr + 1], lsu[dmem_addr + 2]};
      4'b1100: rd_data = {{16{lsu[dmem_addr][7]}}, lsu[dmem_addr + 3], lsu[dmem_addr + 3]};
      4'b1111: rd_data = {lsu[dmem_addr], lsu[dmem_addr + 1], lsu[dmem_addr + 2], lsu[dmem_addr + 3]};
      default: rd_data = {lsu[dmem_addr], lsu[dmem_addr + 1], lsu[dmem_addr + 2], lsu[dmem_addr + 3]};
    endcase
    end else if (rd_addr_fix > PERI_OUT_BASE && rd_addr_fix < RESV_BASE) begin
      if(bmask_i == 4'b1111) begin
      case (rd_addr_i_fix)
        //========================LCD==========================================
        // LOAD WORD
        12'h800,12'h801,12'h802,12'h803: rd_data = lcd_7;
        12'h804,12'h805,12'h806,12'h807: rd_data = lcd_6;
        12'h808,12'h809,12'h80A,12'h80B: rd_data = lcd_5;
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = lcd_4;
        12'h810,12'h811,12'h812,12'h813: rd_data = lcd_3;
        12'h814,12'h815,12'h816,12'h817: rd_data = lcd_2;
        12'h818,12'h819,12'h81A,12'h81B: rd_data = lcd_1;
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = lcd_0;
        //========================HEX==========================================
        12'h820:                         rd_data = hex_7;
        12'h824:                         rd_data = hex_6;
        12'h840:                         rd_data = led_r;
        12'h828:                         rd_data = hex_5;
        12'h82C:                         rd_data = hex_4;
        12'h830:                         rd_data = hex_3;
        12'h834:                         rd_data = hex_2;
        12'h838:                         rd_data = hex_1;
        12'h83C:                         rd_data = hex_0;
        //========================LED_R===================================
        12'h840:                         rd_data = led_r;
        12'h844:                         rd_data = led_g;
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b0011) begin
      case (rd_addr_i_fix)
        //========================LCD==========================================
        // LOAD HALF WORD
        12'h800,12'h801,12'h802,12'h803: rd_data = {{16{1'b0}}, lcd_7[15:0]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{16{1'b0}}, lcd_6[15:0]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{16{1'b0}}, lcd_5[15:0]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{16{1'b0}}, lcd_4[15:0]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{16{1'b0}}, lcd_3[15:0]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{16{1'b0}}, lcd_2[15:0]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{16{1'b0}}, lcd_1[15:0]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{16{1'b0}}, lcd_0[15:0]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{16{1'b0}}, hex_7[15:0]};
        12'h824:                         rd_data = {{16{1'b0}}, hex_6[15:0]};
        12'h840:                         rd_data = {{16{1'b0}}, led_r[15:0]};
        12'h828:                         rd_data = {{16{1'b0}}, hex_5[15:0]};
        12'h82C:                         rd_data = {{16{1'b0}}, hex_4[15:0]};
        12'h830:                         rd_data = {{16{1'b0}}, hex_3[15:0]};
        12'h834:                         rd_data = {{16{1'b0}}, hex_2[15:0]};
        12'h838:                         rd_data = {{16{1'b0}}, hex_1[15:0]};
        12'h83C:                         rd_data = {{16{1'b0}}, hex_0[15:0]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{16{1'b0}}, led_r[15:0]};
        12'h844:                         rd_data = {{16{1'b0}}, led_g[15:0]};
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b1100) begin
      case (rd_addr_i_fix)
        //========================LCD==========================================
        // LOAD HALF WORD
        12'h800,12'h801,12'h802,12'h803: rd_data = {{16{1'b0}}, lcd_7[31:16]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{16{1'b0}}, lcd_6[31:16]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{16{1'b0}}, lcd_5[31:16]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{16{1'b0}}, lcd_4[31:16]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{16{1'b0}}, lcd_3[31:16]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{16{1'b0}}, lcd_2[31:16]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{16{1'b0}}, lcd_1[31:16]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{16{1'b0}}, lcd_0[31:16]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{16{1'b0}}, hex_7[31:16]};
        12'h824:                         rd_data = {{16{1'b0}}, hex_6[31:16]};
        12'h840:                         rd_data = {{16{1'b0}}, led_r[31:16]};
        12'h828:                         rd_data = {{16{1'b0}}, hex_5[31:16]};
        12'h82C:                         rd_data = {{16{1'b0}}, hex_4[31:16]};
        12'h830:                         rd_data = {{16{1'b0}}, hex_3[31:16]};
        12'h834:                         rd_data = {{16{1'b0}}, hex_2[31:16]};
        12'h838:                         rd_data = {{16{1'b0}}, hex_1[31:16]};
        12'h83C:                         rd_data = {{16{1'b0}}, hex_0[31:16]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{16{1'b0}}, led_r[31:16]};
        12'h844:                         rd_data = {{16{1'b0}}, led_g[31:16]};
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b0001) begin
      case (rd_addr_i_fix)
        //========================LCD=========================================
        // LOAD BYTE
        12'h800,12'h801,12'h802,12'h803: rd_data = {{24{1'b0}}, lcd_7[7:0]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{24{1'b0}}, lcd_6[7:0]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{24{1'b0}}, lcd_5[7:0]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{24{1'b0}}, lcd_4[7:0]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{24{1'b0}}, lcd_3[7:0]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{24{1'b0}}, lcd_2[7:0]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{24{1'b0}}, lcd_1[7:0]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{24{1'b0}}, lcd_0[7:0]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{24{1'b0}}, hex_7[7:0]};
        12'h824:                         rd_data = {{24{1'b0}}, hex_6[7:0]};
        12'h840:                         rd_data = {{24{1'b0}}, led_r[7:0]};
        12'h828:                         rd_data = {{24{1'b0}}, hex_5[7:0]};
        12'h82C:                         rd_data = {{24{1'b0}}, hex_4[7:0]};
        12'h830:                         rd_data = {{24{1'b0}}, hex_3[7:0]};
        12'h834:                         rd_data = {{24{1'b0}}, hex_2[7:0]};
        12'h838:                         rd_data = {{24{1'b0}}, hex_1[7:0]};
        12'h83C:                         rd_data = {{24{1'b0}}, hex_0[7:0]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{24{1'b0}}, led_r[7:0]};
        12'h844:                         rd_data = {{24{1'b0}}, led_g[7:0]};
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b0010) begin
      case (rd_addr_i_fix)
        //========================LCD=========================================
        // LOAD BYTE
        12'h800,12'h801,12'h802,12'h803: rd_data = {{24{1'b0}}, lcd_7[15:8]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{24{1'b0}}, lcd_6[15:8]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{24{1'b0}}, lcd_5[15:8]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{24{1'b0}}, lcd_4[15:8]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{24{1'b0}}, lcd_3[15:8]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{24{1'b0}}, lcd_2[15:8]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{24{1'b0}}, lcd_1[15:8]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{24{1'b0}}, lcd_0[15:8]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{24{1'b0}}, hex_7[15:8]};
        12'h824:                         rd_data = {{24{1'b0}}, hex_6[15:8]};
        12'h840:                         rd_data = {{24{1'b0}}, led_r[15:8]};
        12'h828:                         rd_data = {{24{1'b0}}, hex_5[15:8]};
        12'h82C:                         rd_data = {{24{1'b0}}, hex_4[15:8]};
        12'h830:                         rd_data = {{24{1'b0}}, hex_3[15:8]};
        12'h834:                         rd_data = {{24{1'b0}}, hex_2[15:8]};
        12'h838:                         rd_data = {{24{1'b0}}, hex_1[15:8]};
        12'h83C:                         rd_data = {{24{1'b0}}, hex_0[15:8]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{24{1'b0}}, led_r[15:8]};
        12'h844:                         rd_data = {{24{1'b0}}, led_g[15:8]};
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b0100) begin
      case (rd_addr_i_fix)
        //========================LCD===========================================
        // LOAD BYTE
        12'h800,12'h801,12'h802,12'h803: rd_data = {{24{1'b0}}, lcd_7[23:16]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{24{1'b0}}, lcd_6[23:16]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{24{1'b0}}, lcd_5[23:16]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{24{1'b0}}, lcd_4[23:16]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{24{1'b0}}, lcd_3[23:16]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{24{1'b0}}, lcd_2[23:16]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{24{1'b0}}, lcd_1[23:16]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{24{1'b0}}, lcd_0[23:16]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{24{1'b0}}, hex_7[23:16]};
        12'h824:                         rd_data = {{24{1'b0}}, hex_6[23:16]};
        12'h840:                         rd_data = {{24{1'b0}}, led_r[23:16]};
        12'h828:                         rd_data = {{24{1'b0}}, hex_5[23:16]};
        12'h82C:                         rd_data = {{24{1'b0}}, hex_4[23:16]};
        12'h830:                         rd_data = {{24{1'b0}}, hex_3[23:16]};
        12'h834:                         rd_data = {{24{1'b0}}, hex_2[23:16]};
        12'h838:                         rd_data = {{24{1'b0}}, hex_1[23:16]};
        12'h83C:                         rd_data = {{24{1'b0}}, hex_0[23:16]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{24{1'b0}}, led_r[23:16]};
        12'h844:                         rd_data = {{24{1'b0}}, led_g[23:16]};
        default: rd_data = 32'b0;
      endcase
      end else if (bmask_i == 4'b1000) begin
      case (rd_addr_i_fix)
        //========================LCD===========================================
        // LOAD BYTE
        12'h800,12'h801,12'h802,12'h803: rd_data = {{24{1'b0}}, lcd_7[31:24]};
        12'h804,12'h805,12'h806,12'h807: rd_data = {{24{1'b0}}, lcd_6[31:24]};
        12'h808,12'h809,12'h80A,12'h80B: rd_data = {{24{1'b0}}, lcd_5[31:24]};
        12'h80C,12'h80D,12'h80E,12'h80F: rd_data = {{24{1'b0}}, lcd_4[31:24]};
        12'h810,12'h811,12'h812,12'h813: rd_data = {{24{1'b0}}, lcd_3[31:24]};
        12'h814,12'h815,12'h816,12'h817: rd_data = {{24{1'b0}}, lcd_2[31:24]};
        12'h818,12'h819,12'h81A,12'h81B: rd_data = {{24{1'b0}}, lcd_1[31:24]};
        12'h81C,12'h81D,12'h81E,12'h81F: rd_data = {{24{1'b0}}, lcd_0[31:24]};
        //========================HEX==========================================
        12'h820:                         rd_data = {{24{1'b0}}, hex_7[31:24]};
        12'h824:                         rd_data = {{24{1'b0}}, hex_6[31:24]};
        12'h840:                         rd_data = {{24{1'b0}}, led_r[31:24]};
        12'h828:                         rd_data = {{24{1'b0}}, hex_5[31:24]};
        12'h82C:                         rd_data = {{24{1'b0}}, hex_4[31:24]};
        12'h830:                         rd_data = {{24{1'b0}}, hex_3[31:24]};
        12'h834:                         rd_data = {{24{1'b0}}, hex_2[31:24]};
        12'h838:                         rd_data = {{24{1'b0}}, hex_1[31:24]};
        12'h83C:                         rd_data = {{24{1'b0}}, hex_0[31:24]};
        //========================LED_R===================================
        12'h840:                         rd_data = {{24{1'b0}}, led_r[31:24]};
        12'h844:                         rd_data = {{24{1'b0}}, led_g[31:24]};
        default: rd_data = 32'b0;
      endcase
      end 
  end
  end

endmodule
