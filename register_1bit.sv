  module register_1bit (
      input       clk_i,
      input       nrst_i,
      input       en_i,
      input       d_i,
      output reg  q_o
  ); //da hal check va khong co loi

    always @(posedge clk_i or negedge nrst_i) begin
      if (~nrst_i) begin
        q_o <= 0;
      end else if (en_i) begin
        q_o <= d_i;
      end else begin
         q_o <= q_o;
      end
    end
  endmodule

