module alu_tb;

  // Inputs
  reg [31:0] i_op_a;
  reg [31:0] i_op_b;
  reg br_unsign_i;
  reg [3:0] i_alu_op;

  // Outputs
  wire [31:0] o_alu_data;

  // Instantiate the ALU
  alu uut (
    .i_op_a(i_op_a),
    .i_op_b(i_op_b),
    .br_unsign_i(br_unsign_i),
    .i_alu_op(i_alu_op),
    .o_alu_data(o_alu_data)
  );

  // Testbench procedure
  initial begin
    // Initialize inputs
    i_op_a = 32'b0;
    i_op_b = 32'b0;
    br_unsign_i = 0;
    i_alu_op = 4'b0000;  // default: add operation

    // Test Add (ALU OP: 0000)
    #10;
    i_op_a = 32'd10;  // Operand A = 10
    i_op_b = 32'd20;  // Operand B = 20
    i_alu_op = 4'b0000; // ALU Operation for ADD
    #10;
    $display("ADD result: %d, Expected: 30", o_alu_data);

    // Test Addi (Immediate ADD operation, ALU OP: 0000)
    #10;
    i_op_a = 32'hFF010000;   // Operand A = 5
    i_op_b = 32'hFFFFFF0F;  // Operand B = 15 (simulating immediate value)
    i_alu_op = 4'b0000; // ADD operation (addi case)
    #10;
    $display("ADDI result: %d, Expected: 20", o_alu_data);

    // Test XOR (ALU OP: 0101)
    #10;
    i_op_a = 32'b10101010101010101010101010101010;  // Operand A = 0x55555555
    i_op_b = 32'b01010101010101010101010101010101;  // Operand B = 0xAAAAAAAA
    i_alu_op = 4'b0101;  // XOR operation
    #10;
    $display("XOR result: %b, Expected: 11111111111111111111111111111111", o_alu_data);

    // Test Xori (Immediate XOR operation, ALU OP: 0101)
    #10;
    i_op_a = 32'b10101010101010101010101010101010;  // Operand A = 0x55555555
    i_op_b = 32'b01010101010101010101010101010101;  // Operand B = 0xAAAAAAAA (simulating immediate)
    i_alu_op = 4'b0101;  // XOR operation (xori case)
    #10;
    $display("XORI result: %b, Expected: 11111111111111111111111111111111", o_alu_data);

    // End simulation
    $stop;
  end
endmodule
