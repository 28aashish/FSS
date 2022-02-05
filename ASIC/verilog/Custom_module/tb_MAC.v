`timescale 1ns / 1ps

module tb_design_MAC_wrapper();

  parameter PERIOD = 10; 
  wire [31:0] Y;
  reg [31:0] A, B, C;
  reg OP;
  reg input_a_stb,input_b_stb,input_c_stb,input_op_stb,output_z_ack;
  wire input_a_ack,input_b_ack,input_c_ack,input_op_ack,output_z_stb;
  reg rst,clk;
  integer i=0;
  always #10 clk=~clk;
  
  design_MAC_wrapper uut(
          Y,
        output_z_ack,
        output_z_stb,

        A,
        input_a_ack,
        input_a_stb,
        
        B,
        input_b_stb,
        input_b_ack,
    
        C,
        input_c_stb,
        input_c_ack,
    
        OP,
        input_op_stb,
        input_op_ack,
        clk,
        rst);
  initial
  begin
//    $dumpfile("dump.vcd"); 
//    $dumpvars(1, tb_design_MAC_wrapper);
//    $display("RSLT\tA * B  +- C = Y");
    A = 32'h41c80000; //25.0
    B = 32'hc0000000; //-2.0
    C = 32'h40000000; // 2.0
    OP = 1'b1; 
    input_a_stb=1'b1;
    input_b_stb=1'b1;
    input_c_stb=1'b1;
    input_op_stb=1'b1;
    rst=1'b0;
    clk=1'b1;
    #(2*PERIOD);
    rst=1'b1;

    
    while(output_z_stb == 1'b0)
      begin
        #(2*PERIOD)
       $display("Waiting %d cycle",i++);
      end
    //#5000
    if ( Y == 32'hc2400000) //-48.0
      begin
        if(OP==1'b1)
          $display("PASS\t%x * %x + %x = %x",A,B,C,Y);
        else
          $display("PASS\t%x * %x - %x = %x",A,B,C,Y);
      end
    else
      begin
        if(OP==1'b1)
          $display("FAIL\t%x * %x + %x = %x",A,B,C,Y);
        else
          $display("FAIL\t%x * %x - %x = %x",A,B,C,Y);
      end
  end
endmodule
