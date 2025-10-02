module sum_register (
    input  wire       i_clk,
    input  wire       i_sum_rst,
    input  wire       i_sum_ld,
    input  wire [2:0] i_sum,
    output reg  [2:0] o_sum
);
  always_ff @( posedge i_clk or negedge i_sum_rst ) begin : sum_register
    if(~i_sum_rst) begin
        o_sum <= 3'b0;
    end else if (i_sum_ld) begin
        o_sum <= i_sum;
    end else begin
      o_sum <= o_sum;
      end
  end
endmodule
