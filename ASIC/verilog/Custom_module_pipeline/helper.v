/*
module dq #(  parameter width=8, parameter depth=2)  (clk, q, d);
  input  clk;
  input  [width-1:0] d;
  output [width-1:0] q;

  integer i;
  reg [width-1:0] delay_line [depth-1:0];
  always @(posedge clk) begin
    delay_line[0] <= d;
    for(i=1; i<depth; i=i+1) begin
      delay_line[i] <= delay_line[i-1];
    end
  end
  assign q = delay_line[depth-1];
endmodule

module dd #( parameter width = 8) (clk, d,q);
  input  clk;
  input  [width-1:0] d;
  output  [width-1:0] q;

  reg [width-1:0] delay_line ;

  always @(posedge clk) begin
    delay_line <= d;
  end
  assign q = delay_line;
endmodule
*/



module dq #(  parameter width=8, parameter depth=2)  (clk, q, d);
  input  clk;
  input  [width-1:0] d;
  output [width-1:0] q;

  integer i;
  reg [width-1:0] delay_line [depth-1:0];
  always @(posedge clk) begin
    delay_line[0] <= {width{1'b1}} ^ d;
    
    for(i=1; i<depth; i=i+1) begin
      delay_line[i] <= delay_line[i-1];
    end
  end
  assign q = {width{1'b1}} ^ delay_line[depth-1];
endmodule

module dd #( parameter width = 8) (clk, d,q);
  input  clk;
  input  [width-1:0] d;
  output [width-1:0] q;

  reg [width-1:0] delay_line ;

  always @(posedge clk) begin
    delay_line <= {width{1'b1}} ^ d;
        
  end
  
  assign q = {width{1'b1}} ^ delay_line;
endmodule