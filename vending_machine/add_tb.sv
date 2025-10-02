module add_tb;
  // Khai báo tín hiệu kết nối với DUT
  reg  [2:0] i_sum;
  reg  [2:0] i_coin;
  reg        i_cin;
  wire [2:0] o_i_sum;
  wire       o_cout;

  // Gọi module cần test
  adder_3bit uut (
    .i_sum(i_sum),
    .i_coin(i_coin),
    .i_cin(i_cin),
    .o_i_sum(o_i_sum),
    .o_cout(o_cout)
  );

  // Test logic
  initial begin
    $dumpfile("add.vcd");
    $dumpvars(0, add_tb);
    $dumpvars(0, add_tb.i_sum, add_tb.i_coin, add_tb.i_cin, add_tb.o_i_sum, add_tb.o_cout);
    // Hiển thị tiêu đề
    $display("Time | i_cin | i_sum | i_coin | o_i_sum | o_cout");
    $display("--------------------------------------------------");

    // Test cộng: 0 + 5 = 5
    i_cin  = 0;
    i_sum  = 3'b011;
    i_coin = 3'b010;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);

    // Test cộng: 7 + 1 = 8 (tràn bit)
    i_cin  = 0;
    i_sum  = 3'b111;
    i_coin = 3'b001;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 1 + 2 = 3
    i_cin  = 0;
    i_sum  = 3'b001;
    i_coin = 3'b010;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 4 + 5 = 1 du 1
    i_cin  = 0;
    i_sum  = 3'b100;
    i_coin = 3'b101;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 3 + 7 = 2 du 1
    i_cin  = 0;
    i_sum  = 3'b011;
    i_coin = 3'b111;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 7 + 0 = 3
    i_cin  = 0;
    i_sum  = 3'b111;
    i_coin = 3'b000;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 7 + 0 + 1= 0 du 1
    i_cin  = 1;
    i_sum  = 3'b111;
    i_coin = 3'b000;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 1 + 4 + 1 = 6
    i_cin  = 1;
    i_sum  = 3'b001;
    i_coin = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);
    // 4 + 5 + 1 = 2 du 1
    i_cin  = 1;
    i_sum  = 3'b100;
    i_coin = 3'b101;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_coin, o_i_sum, o_cout);


    $finish;
  end
endmodule
