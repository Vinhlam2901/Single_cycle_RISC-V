module imem (
    input      [31:0] Address,
    output reg [31:0] Instruction
);

    reg [31:0] mem [31:0];

    initial begin
        $readmemh("code.txt", mem);  // Đường dẫn tương đối
    end
    always @(*) begin
        if (Address[31:2] < 31)
            Instruction = mem[Address[31:2]];
        else
            Instruction = 32'h00000013; // NOP
    end

endmodule
