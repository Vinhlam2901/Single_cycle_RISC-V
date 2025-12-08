module pipelined_tb;

  reg         clk;
  reg         reset;
  reg  [31:0] io_sw;
  wire [31:0] io_ledr;
  wire [31:0] io_ledg;
  wire [31:0] io_lcd;
  // Các chân Hex không quan trọng lắm trong test này nên tôi rút gọn
  wire [6:0]  hex_dump [0:7]; 
  wire        ctrl_sig;
  wire        mispred;
  wire [31:0] pc_debug;
  wire        insn_vld;

  // Instantiate CPU
  pipelined_non_fwd uut (
    .i_clk      (clk),
    .i_reset    (reset),
    .i_io_sw    (io_sw),
    .o_io_ledr  (io_ledr),
    .o_io_ledg  (io_ledg),
    .o_io_lcd   (io_lcd),
    .o_io_hex0  (hex_dump[0]), .o_io_hex1(hex_dump[1]),
    .o_io_hex2  (hex_dump[2]), .o_io_hex3(hex_dump[3]),
    .o_io_hex4  (hex_dump[4]), .o_io_hex5(hex_dump[5]),
    .o_io_hex6  (hex_dump[6]), .o_io_hex7(hex_dump[7]),
    .o_ctrl     (ctrl_sig),
    .o_mispred  (mispred),
    .o_pc_debug (pc_debug),
    .o_insn_vld (insn_vld)
  );

  // Load Memory
  initial begin
    // Đảm bảo đường dẫn đúng tới file hex full bạn vừa tạo
    $readmemh("../02_test/full_isa_test.hex", uut.mem);
  end

  // Clock Gen
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // === ASCII PRINTER ===
  // Phần này sẽ theo dõi LEDR và LCD, nếu có thay đổi sẽ in ký tự ra
  // Giả sử bài test ghi từng ký tự vào 8 bit thấp của LEDR
  always @(io_ledr) begin
      if (io_ledr != 0) begin
          $write("%c", io_ledr[7:0]); // In ký tự ASCII ra console (không xuống dòng)
      end
  end

  // Test Logic
  initial begin
    reset = 0;
    io_sw = 0;
    
    $display("=================================================");
    $display("      FULL ISA TEST SUITE STARTING...");
    $display("      Output Text will appear below:");
    $display("=================================================");
    
    #10 reset = 1;

    // Bài test này rất dài, cần chạy lâu (ví dụ 50,000 chu kỳ hoặc hơn)
    // Bạn có thể tăng số này nếu chạy chưa hết
    repeat (100000) @(posedge clk); 
    
    $display("\n=================================================");
    $display("      TIMEOUT / FINISHED");
    $display("=================================================");
    $stop;
  end

endmodule