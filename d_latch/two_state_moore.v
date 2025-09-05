module two_state_moore (
    data_in,
    data_out,
    rst,
    clk
);
  input [1:0] data_in;
  input rst, clk;
  output data_out;
  reg data_out;
  reg current_state, next_state;
  parameter st0 = 1'b0, st1 = 1'b1;
  //state register
  always @(posedge clk or negedge rst) begin
    if (~rst) current_state = 1'b0;
    else current_state = next_state;
  end

  //Combinational next stage logic
  always @(data_in or current_state) begin
    case (current_state)
      st0:
      case (data_in)
        2'b01:   next_state = st0;
        2'b10:   next_state = st0;
        default: next_state = st1;
      endcase
      st1:
      case (data_in)
        2'b11:   next_state = st1;
        default: next_state = st0;
      endcase
    endcase
  end

  //Combinational output
  always @(current_state) begin
    case (current_state)
      st0: data_out = 1'b1;
      st1: data_out = 1'b0;
      default: data_out = 1'b0;
    endcase
  end
endmodule
