/// A*B +/- zC
//
module design_MAC_wrapper(
        output_ans,
        output_ans_ack,
        output_ans_stb,

        input_a,
        input_a_ack,
        input_a_stb,
        
        input_b,
        input_b_stb,
        input_b_ack,

        input_c,
        input_c_stb,
        input_c_ack,

        input_op,
        input_op_stb,
        input_op_ack,

        aclk,
        rstn
        );

        input     clk;
        input     rst;

  input     [31:0] input_a;
  input     input_a_stb;
  output    input_a_ack;

  input     [31:0] input_b;
  input     input_b_stb;
  output    input_b_ack;
  
  input     [31:0] input_c;
  input     input_c_stb;
  output    input_c_ack;
  
  input     input_op;
  input     input_op_stb;
  output    input_op_ack;
  
  output    [31:0] output_ans;
  output    output_ans_stb;
  input     output_ans_ack;

  reg       s_output_ans_stb;
  reg       [31:0] s_output_ans;
  reg       s_input_a_ack;
  reg       s_input_b_ack;
  reg       s_input_c_ack;
  reg       s_input_op_ack;

  reg       [4:0] state;
  reg       a_s;
  reg       [31:0] a;
  reg       [9:0] a_e;
  reg       [26:0] a_m;

  reg       [31:0] b;
  reg       b_s;
  reg       [9:0] b_e;
  reg       [26:0] b_m;
  
  reg       [31:0] c;
  reg       c_s;
  reg       [9:0] c_e;
  reg       [26:0] c_m;
  
  reg       [31:0] ab;
  reg       ab_s;
  reg       [9:0] ab_e;
  reg       [26:0] ab_m;

  reg       [47:0] product;
  reg       ab_guard, ab_round_bit, ab_sticky;

  reg       [27:0] sum;
  reg       guard, round_bit, sticky;
  

  reg       [31:0] ans;
  reg       ans_s;
  reg       [9:0] ans_e;
  reg       [26:0] ans_m;
 
  reg       op;

 parameter      get_value         = 5'd0,
                unpack         = 5'd1,
                ab_special_cases        = 5'd2,
                ab_normalise_a = 5'd3,
                ab_normalise_b   = 5'd4,
                ab_multiply_0   = 5'd5,
                ab_multiply_1    = 5'd6,
                ab_normalise_1    = 5'd7,
                ab_normalise_2    = 5'd8,
                ab_round   = 5'd9,
                ab_pack   = 5'd10,
                ans_special_cases         = 5'd11,
                ans_align          = 5'd12,
                add_0         = 5'd13,
                add_1         = 5'd14,
                normalise_1         = 5'd15,
                normalise_2         = 5'd16,
                round         = 5'd17,
                pack         = 5'd18,
                put_ans         = 5'd19;

  always @(posedge clk)
  begin
    if (!rst) begin
                state <= get_value;
                s_input_a_ack <= 0;
                s_input_b_ack <= 0;
                s_input_c_ack <= 0;
                s_input_op_ack <= 0;
                s_output_ans_stb <= 0;

                a_s <= 1'b0;
                b_s <= 1'b0;
                c_s <= 1'b0;

                a <= {32{1'b0}};
                b <= {32{1'b0}};
                c <= {32{1'b0}};

                a_e <= {10{1'b0}};
                b_e <= {10{1'b0}};
                c_e <= {10{1'b0}};

                a_m <= {27{1'b0}};
                b_m <= {27{1'b0}};
                c_m <= {27{1'b0}};

                product <= {48{1'b0}};

                ab_guard <=1'b0;
                ab_round_bit <=1'b0;
                ab_sticky <=1'b0;

                sum <= {28{1'b0}};
  
                guard <=1'b0;
                round_bit <=1'b0;
                sticky <=1'b0;

                ans <={32{1'b0}};
                ans_s <={1'b0};
                ans_e <={10{1'b0}};
                ans_m <={27{1'b0}};

                op <= 1'b0;

        end    
    else
      begin
    case(state)
    // State 00
        get_value:
                begin
                        s_input_a_ack <= 1;
                        s_input_b_ack <= 1;
                        s_input_c_ack <= 1;
                        s_input_op_ack <= 1;
                        if (s_input_a_ack && input_a_stb && s_input_b_ack && input_b_stb && s_input_c_ack && input_c_stb &&s_input_op_ack && input_op_stb) begin
                                a <= input_a;
                                b <= input_b;
                                c <= input_c;
                                op <= input_op;
                                s_input_a_ack <= 0;                        
                                s_input_b_ack <= 0;                        
                                s_input_c_ack <= 0;                        
                                s_input_op_ack <= 0;                        
                                state<=unpack;
                        end
                end
    // State 01              
        unpack:
                begin
                        a_m <= a[22 : 0];
                        b_m <= b[22 : 0];
                        c_m <= {c[22 : 0],3'd0};

                        a_e <= a[30 : 23] - 127;
                        b_e <= b[30 : 23] - 127;
                        c_e <= c[30 : 23] - 127;

                        a_s <= a[31];
                        b_s <= b[31];
                        c_s <= c[31];

                        state <= ab_special_cases;
                end
    // State 02
        ab_special_cases:
                begin
                //if a is NaN or b is NaN return NaN 
                if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin
                        ab[31] <= 1;
                        ab[30:23] <= 255;
                        ab[22] <= 1;
                        ab[21:0] <= 0;
                        state <= ans_special_cases;
                //if a is inf return inf
                end else if (a_e == 128) begin
                        ab[31] <= a_s ^ b_s;
                        ab[30:23] <= 255;
                        ab[22:0] <= 0;
                        //if b is zero return NaN
                        if (($signed(b_e) == -127) && (b_m == 0)) begin
                          ab[31] <= 1;
                          ab[30:23] <= 255;
                          ab[22] <= 1;
                          ab[21:0] <= 0;
                        end
                        state <= ans_special_cases;
                //if b is inf return inf
                end else if (b_e == 128) begin
                        ab[31] <= a_s ^ b_s;
                        ab[30:23] <= 255;
                        ab[22:0] <= 0;
                        //if a is zero return NaN
                        if (($signed(a_e) == -127) && (a_m == 0)) begin
                          ab[31] <= 1;
                          ab[30:23] <= 255;
                          ab[22] <= 1;
                          ab[21:0] <= 0;
                        end
                        state <= ans_special_cases;
                //if a is zero return zero
                end else if (($signed(a_e) == -127) && (a_m == 0)) begin
                        ab[31] <= a_s ^ b_s;
                        ab[30:23] <= 0;
                        ab[22:0] <= 0;
                        state <= ans_special_cases;
                //if b is zero return zero
                end else if (($signed(b_e) == -127) && (b_m == 0)) begin
                        ab[31] <= a_s ^ b_s;
                        ab[30:23] <= 0;
                        ab[22:0] <= 0;
                        state <= ans_special_cases;
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
                        state <= ab_normalise_a;
                end
              end
    // State 03
        ab_normalise_a:
                begin
                  if (a_m[23]) begin
                    state <= ab_normalise_b;
                  end else begin
                    a_m <= a_m << 1;
                    a_e <= a_e - 1;
                  end
                end
    // State 04                
        ab_normalise_b:
                begin
                  if (b_m[23]) begin
                    state <= ab_multiply_0;
                  end else begin
                    b_m <= b_m << 1;
                    b_e <= b_e - 1;
                  end
                end
    // State 05                
        ab_multiply_0:
                begin
                        ab_s <= a_s ^ b_s;
                        ab_e <= a_e + b_e + 1;
                        product <= a_m * b_m;
                        state <= ab_multiply_1;
                end
    // State 06
        ab_multiply_1:
                begin
                        ab_m <= product[47:24];
                        ab_guard <= product[23];
                        ab_round_bit <= product[22];
                        ab_sticky <= (product[21:0] != 0);
                        state <= ab_normalise_1;
                end
    // State 07                
        ab_normalise_1:
                begin
                  if (ab_m[23] == 0) begin
                    ab_e <= ab_e - 1;
                    ab_m <= ab_m << 1;
                    ab_m[0] <= ab_guard;
                    ab_guard <= ab_round_bit;
                    ab_round_bit <= 0;
                  end else begin
                    state <= ab_normalise_2;
                  end
                end
    // State 08
        ab_normalise_2:
                begin
                  if ($signed(ab_e) < -126) begin
                    ab_e <= ab_e + 1;
                    ab_m <= ab_m >> 1;
                    ab_guard <= ab_m[0];
                    ab_round_bit <= ab_guard;
                    ab_sticky <= ab_sticky | ab_round_bit;
                  end else begin
                    state <= ab_round;
                  end
                end
    // State 09                
        ab_round:
                begin
                  if (ab_guard && (ab_round_bit | ab_sticky | ab_m[0])) begin
                    ab_m <= ab_m + 1;
                    if (ab_m == 24'hffffff) begin
                      ab_e <=ab_e + 1;
                    end
                  end
                  state <= ab_pack;
                end
    // State 10                
        ab_pack:
                begin
                ab[22 : 0] <= ab_m[22:0];
                ab_m <={ab_m,3'b0};
                ab[30 : 23] <= ab_e[7:0] + 127;
                ab[31] <= ab_s;
                if ($signed(ab_e) == -126 && ab_m[23] == 0) begin
                  ab[30 : 23] <= 0;
                end
                //if overflow occurs, return inf
                if ($signed(ab_e) > 127) begin
                  ab[22 : 0] <= 0;
                  ab[30 : 23] <= 255;
                  ab[31] <= ab_s;
                end
                state <= ans_special_cases;
                end
    // State 11
        ans_special_cases:
                begin
                //if ab is NaN or c is NaN return NaN 
                if ((ab_e == 128 && ab_m != 0) || (c_e == 128 && c_m != 0)) begin
                  ans[31] <= 1;
                  ans[30:23] <= 255;
                  ans[22] <= 1;
                  ans[21:0] <= 0;
                  state <= put_ans;
                //if ab is inf return inf
                end else if (ab_e == 128) begin
                  ans[31] <= ab_s;
                  ans[30:23] <= 255;
                  ans[22:0] <= 0;
                  //if ab is inf and signs don't match return nan
                  if ((c_e == 128) && (ab_s != c_s)) begin
                      ans[31] <= c_s;
                      ans[30:23] <= 255;
                      ans[22] <= 1;
                      ans[21:0] <= 0;
                  end
                  state <= put_ans;
                //if c is inf return inf
                end else if (c_e == 128) begin
                  ans[31] <= b_s;
                  ans[30:23] <= 255;
                  ans[22:0] <= 0;
                  state <= put_ans;
                //if ab is zero return b
                end else if ((($signed(ab_e) == -127) && (ab_m == 0)) && (($signed(c_e) == -127) && (c_m == 0))) begin
                  ans[31] <= ab_s & c_s;
                  ans[30:23] <= c_e[7:0] + 127;
                  ans[22:0] <= c_m[26:3];
                  state <= put_ans;
                //if ab is zero return c
                end else if (($signed(ab_e) == -127) && (ab_m == 0)) begin
                  ans[31] <= c_s;
                  ans[30:23] <= c_e[7:0] + 127;
                  ans[22:0] <= c_m[26:3];
                  state <= put_ans;
                //if c is zero return ab
                end else if (($signed(c_e) == -127) && (c_m == 0)) begin
                  ans[31] <= ab_s;
                  ans[30:23] <= ab_e[7:0] + 127;
                  ans[22:0] <= ab_m[26:3];
                  state <= put_ans;
                end else begin
                  //Denormalised Number
                  if ($signed(ab_e) == -127) begin
                    ab_e <= -126;
                  end else begin
                    ab_m[26] <= 1;
                  end
                  //Denormalised Number
                  if ($signed(c_e) == -127) begin
                    c_e <= -126;
                  end else begin
                    c_m[26] <= 1;
                  end
                  state <= ans_align;
                end
              end
    // State 12
        ans_align:
                begin
                  if ($signed(ab_e) > $signed(c_e)) begin
                    c_e <= c_e + 1;
                    c_m <= c_m >> 1;
                    c_m[0] <= c_m[0] | c_m[1];
                  end else if ($signed(ab_e) < $signed(c_e)) begin
                    ab_e <= ab_e + 1;
                    ab_m <= ab_m >> 1;
                    ab_m[0] <= ab_m[0] | ab_m[1];
                  end else begin
                    state <= add_0;
                  end
                end
    // State 13                
        add_0:
              begin
                ans_e <= ab_e;
                if (op)
                        begin
                                if (ab_s == c_s) 
                                        begin
                                        sum <= ab_m + c_m;
                                        ans_s <= ab_s;
                                        end                     
                                else
                                        begin
                                          if (ab_m >= c_m) begin
                                            sum <= ab_m - c_m;
                                            ans_s <= ab_s;
                                          end else begin
                                            sum <= c_m - ab_m;
                                            ans_s <= c_s;
                                          end                                        
                                        end
                        end                
                else
                        begin
                                 if (ab_s != c_s) 
                                        begin
                                        sum <= ab_m + c_m;
                                        ans_s <= ab_s;
                                        end                     
                                else
                                        begin
                                          if (ab_m >= c_m) begin
                                            sum <= ab_m - c_m;
                                            ans_s <= ab_s;
                                          end else begin
                                            sum <= c_m - ab_m;
                                            ans_s <= c_s;
                                          end                                        
                                        end                               
                        end
                state <= add_1;
              end
    // State 14
        add_1:
              begin
                if (sum[27]) begin
                  ans_m <= sum[27:4];
                  guard <= sum[3];
                  round_bit <= sum[2];
                  sticky <= sum[1] | sum[0];
                  ans_e <= ans_e + 1;
                end else begin
                  ans_m <= sum[26:3];
                  guard <= sum[2];
                  round_bit <= sum[1];
                  sticky <= sum[0];
                end
                state <= normalise_1;
              end
    // State 15
        normalise_1:
                begin
                  if (ans_m[23] == 0 && $signed(ans_e) > -126) begin
                    ans_e <= ans_e - 1;
                    ans_m <= ans_m << 1;
                    ans_m[0] <= guard;
                    guard <= round_bit;
                    round_bit <= 0;
                  end else begin
                    state <= normalise_2;
                  end
                end
    // State 16
        normalise_2:
              begin
                if ($signed(ans_e) < -126) begin
                  ans_e <= ans_e + 1;
                  ans_m <= ans_m >> 1;
                  guard <= ans_m[0];
                  round_bit <= guard;
                  sticky <= sticky | round_bit;
                end else begin
                  state <= round;
                end
              end
    // State 17
        round:
                begin
                  if (guard && (round_bit | sticky | ans_m[0])) begin
                    ans_m <= ans_m + 1;
                    if (ans_m == 24'hffffff) begin
                      ans_e <=ans_e + 1;
                    end
                  end
                  state <= pack;
                end
    // State 18
        pack:
                begin
                  ans[22 : 0] <= ans_m[22:0];
                  ans[30 : 23] <= ans_e[7:0] + 127;
                  ans[31] <= ans_s;
                  if ($signed(ans_e) == -126 && ans_m[23] == 0) begin
                    ans[30 : 23] <= 0;
                  end
                  if ($signed(ans_e) == -126 && ans_m[23:0] == 24'h0) begin
                    ans[31] <= 1'b0; // FIX SIGN BUG: -a + a = +0.
                  end
                  //if overflow occurs, return inf
                  if ($signed(ans_e) > 127) begin
                    ans[22 : 0] <= 0;
                    ans[30 : 23] <= 255;
                    ans[31] <= ans_s;
                  end
                  state <= put_ans;
                end        
    // State 19                
        put_ans:
                begin
                  s_output_ans_stb <= 1;
                  s_output_ans <= ans;
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
  assign input_c_ack = s_input_c_ack;
  assign input_c_ack = s_input_op_ack;
  assign output_ans_stb = s_output_ans_stb;
  assign output_ans = s_output_ans;

endmodule