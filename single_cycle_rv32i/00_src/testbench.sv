module testbench();
  // Khai báo các tín hiệu cần thiết cho single_cycle module
  reg         i_clk;
  reg         i_rst_n;
  reg  [31:0] i_io_sw;
  
  wire [31:0] o_io_ledr;
  wire [31:0] o_io_ledg;
  wire [31:0] o_io_lcd;
  wire [6:0]  o_io_hex0;
  wire [6:0]  o_io_hex1;
  wire [6:0]  o_io_hex2;
  wire [6:0]  o_io_hex3;
  wire [6:0]  o_io_hex4;
  wire [6:0]  o_io_hex5;
  wire [6:0]  o_io_hex6;
  wire [6:0]  o_io_hex7;
  wire [31:0] o_pc_debug;
  wire        o_insn_vld;

  // Khởi tạo module single_cycle
  single_cycle uut (
      .i_clk(i_clk),
      .i_rst_n(i_rst_n),
      .i_io_sw(i_io_sw),
      .o_io_ledr(o_io_ledr),
      .o_io_ledg(o_io_ledg),
      .o_io_lcd(o_io_lcd),
      .o_io_hex0(o_io_hex0),
      .o_io_hex1(o_io_hex1),
      .o_io_hex2(o_io_hex2),
      .o_io_hex3(o_io_hex3),
      .o_io_hex4(o_io_hex4),
      .o_io_hex5(o_io_hex5),
      .o_io_hex6(o_io_hex6),
      .o_io_hex7(o_io_hex7),
      .o_pc_debug(o_pc_debug),
      .o_insn_vld(o_insn_vld)
  );

  // Khởi tạo tín hiệu
  initial begin
    i_clk = 0;
    i_rst_n = 0;
    i_io_sw = 32'b0;

    // Reset tín hiệu tại thời điểm ban đầu
    #5 i_rst_n = 1;  // Set reset = 1 sau 5 time units

    // Cấp giá trị cho switch
    #10 i_io_sw = 32'h12345678;

    // Cấp tín hiệu khác nếu cần
    #50 i_io_sw = 32'h87654321;
  end

  // Tạo xung đồng hồ
  always begin
    #5 i_clk = ~i_clk;  // Tạo đồng hồ với chu kỳ 10 thời gian
  end

  // Tracking tín hiệu quan trọng trong mô phỏng
  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      // Khi reset, không in ra gì
      $display("Reset is active, no output.");
    end else begin
      // In tất cả các giá trị quan trọng trong mô phỏng tại mỗi chu kỳ đồng hồ
      $display("Time = %0t", $time);
      $display("PC = %h, Instruction = %h, Opcode = %h, func = %h", o_pc_debug, uut.inst, uut.inst[6:0], uut.inst[14:12]);
      $display("op1 = %h, op2 = %h, rd = %h", uut.op1, uut.op2, uut.rd_data_o);
      $display("equal = %h, less = %h", uut.br_equal, uut.br_less);
      $display("LEDs: o_io_ledr = %h, o_io_ledg = %h", o_io_ledr, o_io_ledg);
      $display("LCD = %h", o_io_lcd);
      $display("Hex outputs: %h %h %h %h %h %h %h %h", o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7);
      $display("Instruction Valid: %b", o_insn_vld);
      $display("------------------------------------------------------");
    end
  end

  // Chạy mô phỏng
  initial begin
    #200 $finish;  // Kết thúc mô phỏng sau 200 time units
  end

endmodule
