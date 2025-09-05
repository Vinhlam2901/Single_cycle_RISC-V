`timescale 1ns / 1ps

module rising_edge_ff_tb;

    reg clk;
    reg data;
    wire q;

    // Đơn vị cần kiểm tra
    rising_edge_ff dut (
        .clk(clk),
        .data(data),
        .q(q)
    );

    // Clock 10ns
    always #5 clk = ~clk;

    // Task kiểm tra giá trị q
    task check;
        input [0:0] expected;
        begin
            if (q !== expected)
                $display("❌ [FAIL] Time %0t: data = %b, expected q = %b, got q = %b", $time, data, expected, q);
            else
                $display("✅ [PASS] Time %0t: data = %b, q = %b", $time, data, q);
        end
    endtask

    initial begin
        $display("🔍 Bắt đầu mô phỏng falling_edge_ff_tb...");
        clk = 1;
        data = 0;
        #3;

        // Testcase 1
        data = 1; #10;  // Cạnh lên xảy ra ở đây
        check(1);

        // Testcase 2
        data = 0; #10;
        check(0);

        // Testcase 3 - cố tình thất bại
        data = 1; #10;
        check(0);  // ❌ cố tình sai: q = 1 nhưng mong đợi 0

        $display("✅ Mô phỏng kết thúc.");
        $finish;
    end

endmodule
