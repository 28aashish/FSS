module design_DIV_wrapper(
        output_ans,
        output_ans_ack,
        output_ans_stb,

        input_a,
        input_a_ack,
        input_a_stb,
        
        input_b,
        input_b_stb,
        input_b_ack,
        aclk,
        rstn
        );

  input    aclk;
  input     rstn;

  input     [31:0] input_a;
  input     input_a_stb;
  output    input_a_ack;

  input     [31:0] input_b;
  input     input_b_stb;
  output    input_b_ack;

  output    [31:0] output_ans;
  output    output_ans_stb;
  input     output_ans_ack;

  reg       s_output_ans_stb;
  reg       [31:0] s_output_ans;
  reg       s_input_a_ack;
  reg       s_input_b_ack;

  reg       [3:0] state;
  parameter get_value         = 4'd0,
            unpack        = 4'd1,
            special_cases = 4'd2,
            normalise_a   = 4'd3,
            normalise_b   = 4'd4,
            divide_0      = 4'd5,
            divide_1      = 4'd6,
            divide_2      = 4'd7,
            divide_3      = 4'd8,
            normalise_1   = 4'd9,
            normalise_2   = 4'd10,
            round         = 4'd11,
            pack          = 4'd12,
            put_z         = 4'd13;

  reg       [31:0] a, b, z;
  reg       [23:0] a_m, b_m, z_m;
  reg       [9:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, round_bit, sticky;
  reg       [50:0] quotient, divisor, dividend, remainder;
  reg       [5:0] count;

  always @(posedge aclk)
  begin
    if (!rstn) begin
      state <= get_value;
      s_input_a_ack <= 1'b0;
      s_input_b_ack <= 1'b0;
      s_output_ans_stb <= 1'b0;

      a <= {32{1'b0}};
      b <= {32{1'b0}};
      z <= {32{1'b0}};
      
      a_m<={24{1'b0}};
      b_m<={24{1'b0}};
      z_m<={24{1'b0}};

      a_e<={10{1'b0}};
      b_e<={10{1'b0}};
      z_e<={10{1'b0}};

      a_s<=1'b0;
      b_s<=1'b0;
      z_s<=1'b0;

      guard<=1'b0;
      round_bit<=1'b0;
      sticky<=1'b0;

      quotient<={51{1'b0}};
      divisor<={51{1'b0}};
      dividend<={51{1'b0}};
      remainder<={51{1'b0}};

      count <={6{1'b0}};      
    end
    else
      begin

    case(state)
//Stage 0
      get_value:
      begin
        s_input_a_ack <= 1;
        s_input_b_ack <= 1;
        if (s_input_a_ack && input_a_stb && s_input_b_ack && input_b_stb) begin
          a <= input_a;
          b <= input_b;
          s_input_a_ack <= 0;
          s_input_b_ack <= 0;
          state <= unpack;
        end
      end


//Stage 1
      unpack:
      begin
        a_m <= a[22 : 0];
        b_m <= b[22 : 0];
        a_e <= a[30 : 23] - 127;
        b_e <= b[30 : 23] - 127;
        a_s <= a[31];
        b_s <= b[31];
        state <= special_cases;
      end

//Stage 2
      special_cases:
      begin
        //if a is NaN or b is NaN return NaN 
        if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin
          z[31] <= 1;
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
          state <= put_z;
          //if a is inf and b is inf return NaN 
        end else if ((a_e == 128) && (b_e == 128)) begin
          z[31] <= 1;
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
          state <= put_z;
        //if a is inf return inf
        end else if (a_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          state <= put_z;
           //if b is zero return NaN
          if ($signed(b_e == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
            state <= put_z;
          end
        //if b is inf return zero
        end else if (b_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
        //if a is zero return zero
        end else if (($signed(a_e) == -127) && (a_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
           //if b is zero return NaN
          if (($signed(b_e) == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
            state <= put_z;
          end
        //if b is zero return inf
        end else if (($signed(b_e) == -127) && (b_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          state <= put_z;
        end else begin
          //Denormalised Number
          if ($signed(a_e) == -127) begin
            a_e <= -126;
          end else begin
            a_m[23] <= 1;
          end
          //Denormalised Number
          if ($signed(b_e) == -127) begin
            b_e <= -126;
          end else begin
            b_m[23] <= 1;
          end
          state <= normalise_a;
        end
      end

//Stage 3
      normalise_a:
      begin
        if (a_m[23]) begin
          state <= normalise_b;
        end else begin
          a_m <= a_m << 1;
          a_e <= a_e - 1;
        end
      end

//Stage 4
      normalise_b:
      begin
        if (b_m[23]) begin
          state <= divide_0;
        end else begin
          b_m <= b_m << 1;
          b_e <= b_e - 1;
        end
      end

//Stage 5
      divide_0:
      begin
        z_s <= a_s ^ b_s;
        z_e <= a_e - b_e;
        quotient <= 0;
        remainder <= 0;
        count <= 0;
        dividend <= a_m << 27;
        divisor <= b_m;
        state <= divide_1;
      end

//Stage 6
      divide_1:
      begin
        quotient <= quotient << 1;
        remainder <= remainder << 1;
        remainder[0] <= dividend[50];
        dividend <= dividend << 1;
        state <= divide_2;
      end

//Stage 7
      divide_2:
      begin
        if (remainder >= divisor) begin
          quotient[0] <= 1;
          remainder <= remainder - divisor;
        end
        if (count == 49) begin
          state <= divide_3;
        end else begin
          count <= count + 1;
          state <= divide_1;
        end
      end

//Stage 8
      divide_3:
      begin
        z_m <= quotient[26:3];
        guard <= quotient[2];
        round_bit <= quotient[1];
        sticky <= quotient[0] | (remainder != 0);
        state <= normalise_1;
      end

//Stage 9
      normalise_1:
      begin
        if (z_m[23] == 0 && $signed(z_e) > -126) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= guard;
          guard <= round_bit;
          round_bit <= 0;
        end else begin
          state <= normalise_2;
        end
      end

//Stage 10
      normalise_2:
      begin
        if ($signed(z_e) < -126) begin
          z_e <= z_e + 1;
          z_m <= z_m >> 1;
          guard <= z_m[0];
          round_bit <= guard;
          sticky <= sticky | round_bit;
        end else begin
          state <= round;
        end
      end

//Stage 11
      round:
      begin
        if (guard && (round_bit | sticky | z_m[0])) begin
          z_m <= z_m + 1;
          if (z_m == 24'hffffff) begin
            z_e <=z_e + 1;
          end
        end
        state <= pack;
      end

//Stage 12
      pack:
      begin
        z[22 : 0] <= z_m[22:0];
        z[30 : 23] <= z_e[7:0] + 127;
        z[31] <= z_s;
        if ($signed(z_e) == -126 && z_m[23] == 0) begin
          z[30 : 23] <= 0;
        end
        //if overflow occurs, return inf
        if ($signed(z_e) > 127) begin
          z[22 : 0] <= 0;
          z[30 : 23] <= 255;
          z[31] <= z_s;
        end
        state <= put_z;
      end

//Stage 13
      put_z:
      begin
        s_output_ans_stb <= 1;
        s_output_ans <= z;
        if (s_output_ans_stb && output_ans_ack) begin
          s_output_ans_stb <= 0;
          state <= get_value;
        end
      end

    endcase
  end
  end
  assign input_a_ack = s_input_a_ack;
  assign input_b_ack = s_input_b_ack;
  assign output_ans_stb = s_output_ans_stb;
  assign output_ans = s_output_ans;

endmodule