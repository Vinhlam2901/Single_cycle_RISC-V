module five_state_moore #(
    parameter st0 = 3'd0,
    parameter st1 = 3'd1, 
    parameter st2 = 3'd2, 
    parameter st3 = 3'd3, 
    parameter st4 = 3'd4
) (
    input      [1:0] data_in,
    input            reset, 
    input            clock,
    output reg       data_out
);
  reg [2:0] pres_state, next_state;

//FSM register
always @(posedge clock or negedge reset)begin
    if(!reset)
        pres_state = st0;
    else pres_state = next_state;
end 
// FSM combinational block
always @(pres_state) begin: fsm
    case (pres_state)
    st0: case(data_in)
            2'b00: next_state = st0;
            2'b01: next_state = st4;   
            2'b10: next_state = st1;   
            2'b11: next_state = st2;   
        endcase
    st1: case(data_in)
            2'b00:   next_state = st0;
            2'b10:   next_state = st2;   
        default: next_state = st1;
        endcase
    st2: case(data_in)
            2'b0x: next_state = st1;   
            2'b1x: next_state = st3;   
        endcase
    st3: case(data_in)
            2'bx1:   next_state = st4;
            default: next_state = st3;  
        endcase
    st4: case(data_in)
            2'b11:   next_state = st4;
            default: next_state = st0; 
        endcase
    default: next_state = st0;
    endcase
end // fsm
// Moore output definition using pres_state only
always @(pres_state) begin
    case(pres_state)
      st0:     data_out = 1'b1;
      st1:     data_out = 1'b0;    
      st2:     data_out = 1'b1;
      st3:     data_out = 1'b0;    
      st4:     data_out = 1'b1;    
      default: data_out = 1'b0;
    endcase
end // outputs
endmodule // Moore