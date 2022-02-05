
module CTRL_72_4096_sky130A(
// Port 0: RW
    clk0,csb0,web0,addr0,din0,dout0
  );

  parameter DATA_WIDTH = 72 ;
  parameter ADDR_WIDTH = 12 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
  input  clk0; // clock
  input   csb0; // active low chip select
  input  web0; // active low write control
  input [ADDR_WIDTH-1:0]  addr0;
  input [DATA_WIDTH-1:0]  din0;
  output reg [DATA_WIDTH-1:0] dout0;

  reg [DATA_WIDTH-1:0]    mem [0:RAM_DEPTH-1];

  // All inputs are registers
  always @(posedge clk0)
  begin
    if ( !csb0 && !web0 ) 
        mem[addr0]<= din0;
    if (!csb0 && web0)
       dout0 <= mem[addr0];

  end

endmodule


module DATA_32_1024_sky130A(
// Port 0: RW
    clk0,csb0,web0,addr0,din0,dout0
  );

  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = 10 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
  input  clk0; // clock
  input   csb0; // active low chip select
  input  web0; // active low write control
  input [ADDR_WIDTH-1:0]  addr0;
  input [DATA_WIDTH-1:0]  din0;
  output reg [DATA_WIDTH-1:0] dout0;

  reg [DATA_WIDTH-1:0]    mem [0:RAM_DEPTH-1];


  // All inputs are registers
  always @(posedge clk0)
  begin

    if ( !csb0 && !web0 ) 
        mem[addr0]<= din0;
    if (!csb0 && web0)
       dout0 <= mem[addr0];

  end

endmodule

    