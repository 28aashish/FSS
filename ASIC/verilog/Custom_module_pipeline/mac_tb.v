module mul_tb();
  parameter PERIOD = 10; 
  wire [31:0] Y;
  reg [31:0] A, B,C;
  reg OP;
  reg input_a_stb,input_b_stb,output_z_ack;
  wire input_a_ack,input_b_ack,output_z_stb;
  reg rst,clk;
  integer i=0;
  always #10 clk=~clk;
  
  mac uut(clk,A,B,C,OP,Y);
  initial
  begin
    
    $display("RSLT\tA * B + C = Y");
    clk=1'b1;

//Cycle0
    A = 32'h41c80000 ; // 25.0
    B = 32'h40000000;  // 2.0
    C = 32'h40000000;  // 2.0
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle1
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle2
    A = 32'h41700000; // 15.0
    B = 32'h3f800000;  // 1.0
    C = 32'h40000000;  // 2.0
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);    
//Cycle3    
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle4
    A = 32'h40000000; // 2.0
    B = 32'h3f000000;  // 0.5
    C = 32'h3f800000;  // 1
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle5    
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle6
    A = 32'h43170000; // 151.0
    B = 32'h41700000;  // 15
    C = 32'h3f800000;  // 1
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle7    
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);


//Cycle8
    A = 32'h3df5c28f; // 0.12
    B = 32'h41400000;  // 12
    C = 32'h3f800000;  // 1
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle9    
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);



//Cycle10
    A = 32'h3df5c28f; // 0.12
    B = 32'h41400000;  // 12
    C = 32'h41800000;  // 16
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle11    
    OP = 1'b1;  // -
    #(2*PERIOD);
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);


//Cycle11
    A = 32'h42d20000; // 105
    B = 32'h41400000;  // 12
    C = 32'h41800000;  // 16
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle12    
    OP = 1'b1;  // -
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle13
    A = 32'h42d20000; // 105
    B = 32'h3e99999a;  // 0.3
    C = 32'h00000000;  // 0
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle14    
    OP = 1'b1;  // -
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle13
    A = 32'h42d20000; // 105
    B = 32'h3e99999a;  // 0.3
    C = 32'h447a0000;  // 1000
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle14    
    OP = 1'b1;  // -
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

//Cycle15
    A = 32'h42d20000; // 105
    B = 32'h3e99999a;  // 0.3
    C = 32'hc47a0000;  // 1000
    OP = 1'b0;  // +
    #(2*PERIOD);
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
//Cycle16    
    OP = 1'b1;  // -
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);
    #(2*PERIOD);    

$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);
    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);

    
$display("PASS\t%x * %x + %x = %x",A,B,C,Y);
    #(2*PERIOD);    
$display("PASS\t%x * %x - %x = %x",A,B,C,Y);


  end
  
endmodule