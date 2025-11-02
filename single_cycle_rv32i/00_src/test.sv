module test();
  reg [31:0] inst;
  reg [31:0] inst_reg;  // Để thay đổi giá trị của inst trong mô phỏng
    
  
  assign inst_reg = 32'b0;  // Gán giá trị inst từ reg inst_reg
  initial begin
      assign inst = inst_reg;  // Gán giá trị inst từ reg inst_reg
    // inst_reg = 32'b0;  // Ban đầu gán giá trị 0
    // #5 inst_reg = 32'b11000110000000000000000000000000; // Thay đổi giá trị của inst sau 5 đơn vị thời gian
    // In ra opcode
    $display("Branch instruction detected: opcode = %h", inst);
  end
endmodule
