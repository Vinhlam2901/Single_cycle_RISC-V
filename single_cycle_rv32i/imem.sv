//===========================================================================================
// Project         : Single Cycle of RISV - V
// Module          : Instrution Memory
// File            : imem.sv
// Author          : Chau Tran Vinh Lam - vinhlamchautran572@gmail.com
// Create date     : 9/9/2025
// Updated date    : 9/9/2025
//===========================================================================================
module imem (
    input  wire [31:0] addr_i,
    output reg  [31:0] inst_o
);

    reg [31:0] mem [0:4096];         //2kB

    initial begin
        //$readmemh("../00_src/single_cycle_rv32i/code.hex", mem);
        mem[0] = 32'h3e800093; // add $1, $2, $3
        mem[4] = 32'h00300113; // sub $4, $3, $5
        mem[8] = 32'h002081b3; // sub $4, $3, $5
        mem[12] = 32'h40310233; // sub $4, $3, $5
    end
    always_comb begin
        if (addr_i[31:2] < 31)
            inst_o = mem[addr_i];
        else
            inst_o = 32'h00000013; // NOP
    end
endmodule
