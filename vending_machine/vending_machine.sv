module vending_machine (
    input  wire       i_clk,
    input  wire       i_nickle,
    input  wire       i_dime,
    input  wire       i_quarter,
    output reg        o_soda,
    output wire [2:0] o_change
);
//====================DECLARATION===================================================
  reg        disp_en, sum_rst;
  reg        sum_ld, sub_ld;
  reg  [2:0] current_state, next_state;
  reg  [3:0] coin_value, op1;
  wire       sum_eq, sum_lt;
  wire       sum_cout, sub_cout, cout;
  wire [2:0] sum;
  wire [2:0] o_sub;
  wire [2:0] io_sum;
  parameter s0   = 3'b000, s1  = 3'b001,
            add  = 3'b010, disp = 3'b011;

//===================STATE_MACHINE================================================
  // register state
  always_ff @( posedge i_clk ) begin : register_state
    current_state <= next_state;
  end
  //combinational next state logic
  always_comb begin : state_transition
    case (current_state)
        s0: next_state = s1;
        s1: begin
            case (1'b1)
              sum_lt == 1'b0                           : next_state = disp;  // sum > 20
              sum_cout == 1'b1                        : next_state = disp;  // sum > 20
              (i_nickle == 1'b1 || i_dime == 1'b1 || i_quarter == 1'b1) : next_state = add;   // c = 1
              sum_lt == 1'b1                       : next_state = s1;    // sum < 20
              default: next_state = s1;
            endcase
        end
        add: begin
            if(sum_lt == 1'b0) begin
                next_state = disp;
            end else  begin
                next_state = s1;
            end
        end
        //sub:    next_state = disp;
        disp:   next_state = s0;
        default:next_state = s0;
    endcase
  end
  // combinational output
  always_comb begin : datapath_ouput
    case (current_state)
        s0:begin
            sum_rst = 1'b0;
            sum_ld  = 1'b1;
            sub_ld  = 1'b0;
            o_soda  = 1'b0;
            disp_en = 1'b0;
        end
        s1: begin
            sum_rst = 1'b1;
            sum_ld  = 1'b1;
            o_soda  = 1'b0;
            disp_en = 1'b0;
        end
        add: begin
            sum_rst = 1'b1;
            sum_ld  = 1'b1;
            o_soda  = 1'b0;
            disp_en = 1'b0;
        end
        disp: begin
            sum_rst = 1'b1;
            sum_ld  = 1'b1;
            o_soda  = 1'b1;
            disp_en = 1'b1;
        end
        default: begin
            sum_rst = 1'b0;
            sub_ld  = 1'b0;
            o_soda  = 1'b0;
        end
    endcase
  end
//===================================DATAPATH=====================================================
  always_comb begin
    if (i_nickle == 1'b1) begin
        coin_value = 4'b0001;
    end else if (i_dime == 1'b1) begin
        coin_value = 4'b0010;
    end else if (i_quarter == 1'b1) begin
        coin_value = 4'b0101;
    end else begin
        coin_value = 4'b0;
    end
    if (disp_en == 1'b1) begin
        coin_value = 4'b0000;
    end
  end
  assign op1 = ((i_nickle == 1'b0) && (i_dime == 1'b0) && (i_quarter == 1'b0)) ? 4'b0 : coin_value;
  adder_3bit a1 (
    .i_sum(sum),        // reg ouput is adder input
    .i_coin(op1),
    .i_cin(1'b0),
    .o_i_sum(io_sum),   // adder output
    .o_cout(sum_cout)
  );

  sum_register sr1 (
    .i_clk(i_clk),
    .i_sum_rst(sum_rst),
    .i_sum_ld(sum_ld),
    .i_sum(io_sum),     // adder output is reg input
    .o_sum(sum)         // reg output
  );
  compare_3bit c1 (
    .i_sum(io_sum),
    .i_20(3'b100),
    .sum_eq(sum_eq),
    .sum_lt(sum_lt)
  );
  subtract20_4bit st1 (
    .i_sum(io_sum),
    .i_20(4'b0100),
    .i_cin(1'b1),
    .o_i_sub(o_sub),
    .o_cout(sub_cout)
  );
  assign o_change = (disp_en) ? o_sub : 3'b0;
endmodule
