
module dmem (
  input  wire          clk_i,
  input  wire          rst_ni,
  input  wire          mem_wren,
  input  wire  [8:0]   rd_addr_i,  // memory addr = rs1 + imm, max = 511
  input  wire  [31:0]  wr_data,    // reg -> mem  = rs2
  input  wire  [4:0]   bmask_i,
  output reg   [31:0]  rd_data     // mem -> reg
);
  reg [31:0] mem [0:511];        //2k
  wire [8:0] rd_addr_fix;
  // rd_addr_i = rs1 + imm
  // alu: rd_data_o =  rs1 + imm
  // load: rd_data = mem[rd_addr]
  // store: wr_data = mem[rd_addr] = rs2
  // 1 o nho co 4 byte, nen can chia 4 rd_addr
  assign rd_addr_fix = rd_addr_i >> 2;
  always @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      mem[rd_addr_i[8:0]] <= 32'b0;
    end
  end
  always_comb begin
    if (mem_wren) begin    // store
      case (bmask_i)
        4'b0001:  mem[rd_addr_fix] = {24'b0, wr_data[7 :0]        };        // sb byte 1
        4'b0010:  mem[rd_addr_fix] = {16'b0, wr_data[7 :0], 8'b0  }; // sb byte 2
        4'b0100:  mem[rd_addr_fix] = {8'b0,  wr_data[7 :0], 16'b0 }; // sb byte 3
        4'b1000:  mem[rd_addr_fix] = {       wr_data[7 :0], 24'b0 };        // sb byte 4
        4'b0011:  mem[rd_addr_fix] = {16'b0, wr_data[15:0]        };        // sh byte 1, 2
        4'b1100:  mem[rd_addr_fix] = {       wr_data[15:0], 16'b0 };       // sh byte 3, 4
        // sw
        4'b1111:  mem[rd_addr_fix] =         wr_data[31:0];
        default:  mem[rd_addr_fix] =         wr_data[31:0];
      endcase
    end else if (mem_wren == 1'b0) begin
      case (bmask_i)
        4'b0001:  rd_data = {{24{mem[rd_addr_fix][7 ]}}, mem[rd_addr_fix][7:0  ]};        // sb byte 1
        4'b0010:  rd_data = {{24{mem[rd_addr_fix][15]}}, mem[rd_addr_fix][15:8 ]}; // sb byte 2
        4'b0100:  rd_data = {{24{mem[rd_addr_fix][23]}}, mem[rd_addr_fix][23:16]}; // sb byte 3
        4'b1000:  rd_data = {{24{mem[rd_addr_fix][31]}}, mem[rd_addr_fix][31:24]};         // sb byte 4
        4'b0011:  rd_data = {{24{mem[rd_addr_fix][15]}}, mem[rd_addr_fix][15:0 ]};         // sh byte 1, 2
        4'b1100:  rd_data = {{24{mem[rd_addr_fix][31]}}, mem[rd_addr_fix][31:16]};        // sh byte 3, 4
        // sw
        4'b1111:  rd_data = mem[rd_addr_fix];
        default: rd_data = mem[rd_addr_fix];
      endcase
    end
  end
  always_comb begin
    $display("mem = %h", mem[rd_addr_fix]);
  end
endmodule
