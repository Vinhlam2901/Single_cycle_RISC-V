module sub_tb;
  // Khai báo tín hiệu kết nối với DUT
  reg  [2:0] i_sum;
  reg  [2:0] i_20;
  reg        i_cin;
  wire [2:0] o_i_sub;
  wire       o_cout;

  // Gọi module cần test
  subtract20_3bit uut (
    .i_sum(i_sum),
    .i_20(i_20),
    .i_cin(i_cin),
    .o_i_sub(o_i_sub),
    .o_cout(o_cout)
  );

  // Test logic
  initial begin
    $dumpfile("sub.vcd");
    $dumpvars(0, sub_tb);
    $dumpvars(0, sub_tb.i_sum, sub_tb.i_20, sub_tb.i_cin, sub_tb.o_i_sub, sub_tb.o_cout);
    // Hiển thị tiêu đề
    $display("Time | i_cin | i_sum | i_20 | o_i_sub | o_cout");
    $display("--------------------------------------------------");

    // Test tru: 0 - 20 = -20
    i_cin  = 1;
    i_sum  = 3'b000;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);

    // Test tru: 5 - 20 = -15
    i_cin  = 1;
    i_sum  = 3'b001;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);
    // 10 - 20 = -10
    i_cin  = 1;
    i_sum  = 3'b010;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);
    // 15 - 20 = -5
    i_cin  = 1;
    i_sum  = 3'b011;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);
    // 20 - 20 = 0
    i_cin  = 1;
    i_sum  = 3'b100;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);
    // 25 - 20 = 5
    i_cin  = 1;
    i_sum  = 3'b101;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);
    // 30 - 20 = 10
    i_cin  = 1;
    i_sum  =3'b110;
    i_20   = 3'b100;
    #10;
    $display("%4t |   %d   |  %d   |   %d   |   %d    |   %d", $time, i_cin, i_sum, i_20, o_i_sub, o_cout);


    $finish;
  end
endmodule
