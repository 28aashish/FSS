module tb_design_DIV_wrapper();
  parameter PERIOD = 10; 
  wire [31:0] Y;
  reg [31:0] A, B;
  reg input_a_stb,input_b_stb,output_z_ack;
  wire input_a_ack,input_b_ack,output_z_stb;
  reg rst,clk;
  integer i=0;
  always #10 clk=~clk;
  
  design_DIV_wrapper uut(
          Y,
        output_z_ack,
        output_z_stb,

        A,
        input_a_ack,
        input_a_stb,
        
        B,
        input_b_stb,
        input_b_ack,
        clk,
        rst);
  initial
  begin
    
    $display("RSLT\tA / B = Y");
    A = 32'h41c80000 ; // 25.0
    B = 32'h40000000;  // 2.0
    input_a_stb=1'b1;
    input_b_stb=1'b1;
    rst=1'b0;
    clk=1'b1;
    #(2*PERIOD);
    #(2*PERIOD);
    rst=1'b1;

    while(output_z_stb == 1'b0)
      begin
        #(2*PERIOD)
        $display("Waiting %d cycle",i++);
      end

//    #5000
    if ( Y == 32'h41480000 ) //12.5
      $display("PASS\t%x / %x = %x",A,B,Y);
    else
      $display("FAIL\t%x / %x = %x",A,B,Y);    
  end
endmodule

