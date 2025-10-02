module vending_machine_tb;

    // Định nghĩa tín hiệu
    reg i_clk;
    reg i_nickle;
    reg i_dime;
    reg i_quarter;
    wire o_soda;
    wire [2:0] o_change;

    // Khởi tạo mô-đun vending_machine
    vending_machine uut (
        .i_clk(i_clk),
        .i_nickle(i_nickle),
        .i_dime(i_dime),
        .i_quarter(i_quarter),
        .o_soda(o_soda),
        .o_change(o_change)
    );

    // Khởi tạo đồng hồ (clock) với tần số 50GHz (Chu kỳ = 20ns)
    always begin
        #5 i_clk = ~i_clk;  // Tạo xung đồng hồ mỗi 10ns để đạt 50GHz (20ns chu kỳ)
    end

    // Khởi tạo tín hiệu và các testcase
    initial begin
        // Khởi tạo giá trị ban đầu
        i_clk = 1;
        i_nickle = 0;
        i_dime = 0;
        i_quarter = 0;

        // Tạo dump file để quan sát tín hiệu
        $dumpfile("vending_machine_tb.vcd");
        $dumpvars(0, vending_machine_tb);
        $dumpvars(0, vending_machine_tb.i_clk);
        $dumpvars(0, vending_machine_tb.o_change, vending_machine_tb.o_soda);
        $dumpvars(0, vending_machine_tb.i_nickle, vending_machine_tb.i_dime, vending_machine_tb.i_quarter);
        $dumpvars(0, vending_machine_tb.uut.sum, vending_machine_tb.uut.io_sum);
        $dumpvars(0, vending_machine_tb.uut.coin_value, vending_machine_tb.uut.sum_ld);
        $dumpvars(0, vending_machine_tb.uut.sum_eq, vending_machine_tb.uut.sum_lt);
        $dumpvars(0, vending_machine_tb.uut.current_state, vending_machine_tb.uut.next_state);
        $dumpvars(0, vending_machine_tb.uut.o_sub, vending_machine_tb.uut.sum_rst);
        $dumpvars(0, vending_machine_tb.uut.sub_ld, vending_machine_tb.uut.disp_en);
        $dumpvars(0, vending_machine_tb.uut.op2, vending_machine_tb.uut.sum_cout);
        $dumpvars(0, vending_machine_tb.uut.op1);
        // Test Case 2: Nhận 1 Nickel (5 cent) - Chỉ xuất hiện tại xung cạnh lên của i_clk
        #10;
        i_dime = 1;  // Xung cạnh lên (posedge i_clk)
        #10;            // Duy trì xung trong 10ns (1 chu kỳ đồng hồ)
        i_dime = 0;   // Kết thúc xung
        // Test Case 3: Nhận 1 Dime (10 cent) - Chỉ xuất hiện tại xung cạnh lên của i_clk
        #10;
        i_quarter = 1;     // Xung cạnh lên (posedge i_clk)
        #10;            // Duy trì xung trong 10ns (1 chu kỳ đồng hồ)
        i_quarter = 0;     // Kết thúc xung

        #20;
        i_nickle = 1;
        #10;
        i_nickle = 0;
        i_dime = 1;
        #10;
        i_dime = 0;
        i_quarter = 1;
        #10;
        i_quarter = 0;
        // 5 + 25 = 20 change 10
        #20;
        i_nickle = 1;
        #10;
        i_nickle = 0;
        #10;
        i_quarter = 1;
        #10;
        i_quarter = 0;
        // 5 + 10 + 5
        #20;
        i_nickle = 1;
        #10;
        i_nickle = 0;
        #10;
        i_dime = 1;
        #10;
        i_dime = 0;
        #10;
        i_nickle = 1;
        #10;
        i_nickle = 0;
        // Kết thúc mô phỏng
        #100;
        $finish;
    end

endmodule
