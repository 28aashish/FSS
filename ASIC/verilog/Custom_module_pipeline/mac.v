//This file was automatically generated by the python 'pipeliner' script
//This module has a latency of 9(multiplication)+7(Addition)=16 clocks
module mac(clk,a,b,c,op,z);
  input clk;
  input [31:0] a;
  input [31:0] b;
  input [31:0] c;
  input op;
  output [31:0] z;
  

  wire [31:0] ab;
  wire sign;
  wire [32:0] c0,c1,c2,c3,c4,c5,c6,c7,c8,c9;

  mul multiply (clk, a, b,ab);
  

  dd #(33) dd_s0 (clk, {op,c}, c0);
  dd #(33) dd_s1 (clk, c0, c1);
  dd #(33) dd_s2 (clk, c1, c2);
  dd #(33) dd_s3 (clk, c2, c3);
  dd #(33) dd_s4 (clk, c3, c4);
  dd #(33) dd_s5 (clk, c4, c5);
  dd #(33) dd_s6 (clk, c5, c6);
  dd #(33) dd_s7 (clk, c6, c7);
  dd #(33) dd_s8 (clk, c7, c8);
  dd #(33) dd_s9 (clk, c8, c9);

  assign sign =  ~c9[32] ^ c9[31];
  add add_sub (clk, ab, {sign,c9[30:0]},z);


endmodule