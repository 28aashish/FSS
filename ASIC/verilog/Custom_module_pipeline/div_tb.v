module div_tb();
  parameter PERIOD = 10; 
  wire [31:0] Y;
  reg [31:0] A, B;
  reg input_a_stb,input_b_stb,output_z_ack;
  wire input_a_ack,input_b_ack,output_z_stb;
  reg rst,clk;
  integer i=0;
  always #10 clk=~clk;
  
  div uut(
         clk,
      A,
        B,
        Y);
  initial
  begin
    
    $display("RSLT\tA / B = Y");
    A = 32'h41c80000 ; // 25.0
    B = 32'h40000000;  // 2.0
    clk=1'b1;
    #(2*PERIOD);
    #(2*PERIOD);

    #700
    if ( Y == 32'h41480000 ) //12.5
      $display("PASS\t%x / %x = %x",A,B,Y);
    else
      $display("FAIL\t%x / %x = %x",A,B,Y);    
  end
endmodule