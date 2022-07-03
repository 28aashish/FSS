// width, depth, int(round(ceil(math.log2(depth)))
module fifo #(parameter width = 32, parameter depth = 16, parameter address_bits = 16 )(clk, rst, data_in, data_out, data_in_stb, data_in_ack, data_out_stb, data_out_ack);

    input clk;
    input rst;

    input [width-1:0] data_in;
    input data_in_stb;
    output data_in_ack;

    output reg [width-1:0] data_out;
    output data_out_stb;
    input data_out_ack;

    wire input_stb;

    
    wire same;
    reg s_output_stb;
    wire full;
    wire empty;
    wire read;
    wire write;
    reg [address_bits-1:0] a_out;
    reg [address_bits-1:0] a_in;
    reg [width-1:0] memory [0:depth-1];

    always @ (posedge clk) begin
        if (write) begin
          memory[a_in] <= data_in;
        end

        if (read) begin
          data_out <= memory[a_out];
        end
    end


    always @ (posedge clk) begin

        s_output_stb <= 0;
        if (read) begin
          //data is available on clock following read
          s_output_stb <= 1;
          if (a_out == (depth - 1)) begin
            a_out <= 0;
          end else begin
            a_out <= a_out + 1;
          end
        end
    
        //if data has not been read, extend strobe
        if (s_output_stb &~ data_out_ack) begin
          s_output_stb <= 1;
        end

        if (write) begin
          if (a_in == (depth - 1)) begin
            a_in <= 0;
          end else begin
            a_in <= a_in + 1;
          end
        end

        if (rst) begin
          a_out <= 0;
          a_in <= 0;
          s_output_stb <= 0;
        end

    end 

    assign same = a_out[address_bits-2:0] == a_in[address_bits-2:0] ? 1 : 0;
     
    assign full = same && (~a_out[address_bits-1]^a_in[address_bits-1]);
    assign empty = same && (a_out[address_bits-1]^a_in[address_bits-1]);
    
    
    assign data_in_ack = ~full;
    assign data_out_stb = s_output_stb;
    assign write = data_in_ack & data_in_stb;
    assign read  = (~s_output_stb | data_out_ack) & ~empty;
    
endmodule

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

   input aclk;
   input rstn;

  reg       op;

  wire [31:0]A;
  wire [31:0]B;
  wire [31:0]C;
  wire OP_into;

  wire [31:0]Z;

fifo #(32,16,5) MAC_module_inputA (aclk, !rstn, input_a, A, input_a_stb, input_a_ack, ,1'b1);
fifo #(32,16,5) MAC_module_inputB (aclk, !rstn, input_b, B, input_b_stb, input_b_ack, ,1'b1);
fifo #(32,16,5) MAC_module_inputC (aclk, !rstn, input_c, C, input_c_stb, input_c_ack, ,1'b1);
fifo #(1,16,5) MAC_module_inputOP (aclk, !rstn, input_op, OP_into, input_op_stb, input_op_ack, ,1'b1);


mac MAC_UNIT (aclk,A,B,C,OP_into,Z);

fifo #(32,16,5) MAC_module_outputans (aclk, !rstn, Z, output_ans, 1'b1,,output_ans_stb,output_ans_ack);

endmodule

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

  wire [31:0]A;
  wire [31:0]B;

  wire [31:0]Z;

fifo #(32,16,5) DIV_module_inputA (aclk, !rstn, input_a, A, input_a_stb, input_a_ack, ,1'b1);
fifo #(32,16,5) DIV_module_inputB (aclk, !rstn, input_b, B, input_b_stb, input_b_ack, ,1'b1);

div DIV_MODULE (aclk,A,B,Z);

fifo #(32,16,5) DIV_module_outputans (aclk, !rstn, Z, output_ans, 1'b1,,output_ans_stb,output_ans_ack);

endmodule