module ff_rst_en (
    input      data_i,
    input      clk_i,
    input      rst_i,
    input      en_i,
    output reg q_o
);
  always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i)    q_o <= 1'b0;
    else if (en_i) q_o <= data_i;
  end
endmodule
