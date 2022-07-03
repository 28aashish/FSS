
//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3.1 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
//Design      : design_BRAM_A_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_BRAM_A_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_we,
    BRAM_PORTB_0_addr,
    BRAM_PORTB_0_clk,
    BRAM_PORTB_0_din,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_en,
    BRAM_PORTB_0_we,
    );
  input wire [6:0]BRAM_PORTA_0_addr;
  input wire BRAM_PORTA_0_clk;
  input wire [31:0]BRAM_PORTA_0_din;
  output wire [31:0]BRAM_PORTA_0_dout;
  input wire BRAM_PORTA_0_en;
  input wire [0:0]BRAM_PORTA_0_we;

  input wire [6:0]BRAM_PORTB_0_addr;
  input wire BRAM_PORTB_0_clk;
  input wire [31:0]BRAM_PORTB_0_din;
  output wire [31:0]BRAM_PORTB_0_dout;
  input wire BRAM_PORTB_0_en;
  input wire [0:0]BRAM_PORTB_0_we;

  design_BRAM_A design_BRAM_A_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we),
        .BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
        .BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
        .BRAM_PORTB_0_din(BRAM_PORTB_0_din),
        .BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
        .BRAM_PORTB_0_en(BRAM_PORTB_0_en),
        .BRAM_PORTB_0_we(BRAM_PORTB_0_we));
endmodule            
//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3.1 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
//Design      : design_CTRL_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_CTRL_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_we);
  input wire [9:0]BRAM_PORTA_0_addr;
  input wire BRAM_PORTA_0_clk;
  input wire [59:0]BRAM_PORTA_0_din;
  output wire [59:0]BRAM_PORTA_0_dout;
  input wire BRAM_PORTA_0_en;
  input wire [0:0]BRAM_PORTA_0_we;

  design_CTRL design_CTRL_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule

//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3.1 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
//Design      : design_MAC_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_MAC_wrapper
   (M_AXIS_RESULT_0_tdata,
    M_AXIS_RESULT_0_tready,
    M_AXIS_RESULT_0_tvalid,
    S_AXIS_A_0_tdata,
    S_AXIS_A_0_tready,
    S_AXIS_A_0_tvalid,
    S_AXIS_B_0_tdata,
    S_AXIS_B_0_tready,
    S_AXIS_B_0_tvalid,
    S_AXIS_C_0_tdata,
    S_AXIS_C_0_tready,
    S_AXIS_C_0_tvalid,
    S_AXIS_OPERATION_0_tdata,
    S_AXIS_OPERATION_0_tready,
    S_AXIS_OPERATION_0_tvalid,
    aclk_0);
  output wire [31:0]M_AXIS_RESULT_0_tdata;
  input wire M_AXIS_RESULT_0_tready;
  output wire M_AXIS_RESULT_0_tvalid;
  input wire [31:0]S_AXIS_A_0_tdata;
  output wire S_AXIS_A_0_tready;
  input wire S_AXIS_A_0_tvalid;
  input wire [31:0]S_AXIS_B_0_tdata;
  output wire S_AXIS_B_0_tready;
  input wire S_AXIS_B_0_tvalid;
  input wire [31:0]S_AXIS_C_0_tdata;
  output wire S_AXIS_C_0_tready;
  input wire S_AXIS_C_0_tvalid;
  input wire [7:0]S_AXIS_OPERATION_0_tdata;
  output wire S_AXIS_OPERATION_0_tready;
  input wire S_AXIS_OPERATION_0_tvalid;
  input wire aclk_0;


  design_MAC design_MAC_i
       (.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
        .M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
        .M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid),
        .S_AXIS_A_0_tdata(S_AXIS_A_0_tdata),
        .S_AXIS_A_0_tready(S_AXIS_A_0_tready),
        .S_AXIS_A_0_tvalid(S_AXIS_A_0_tvalid),
        .S_AXIS_B_0_tdata(S_AXIS_B_0_tdata),
        .S_AXIS_B_0_tready(S_AXIS_B_0_tready),
        .S_AXIS_B_0_tvalid(S_AXIS_B_0_tvalid),
        .S_AXIS_C_0_tdata(S_AXIS_C_0_tdata),
        .S_AXIS_C_0_tready(S_AXIS_C_0_tready),
        .S_AXIS_C_0_tvalid(S_AXIS_C_0_tvalid),
        .S_AXIS_OPERATION_0_tdata(S_AXIS_OPERATION_0_tdata),
        .S_AXIS_OPERATION_0_tready(S_AXIS_OPERATION_0_tready),
        .S_AXIS_OPERATION_0_tvalid(S_AXIS_OPERATION_0_tvalid),
        .aclk_0(aclk_0));
endmodule

//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3.1 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
//Design      : design_DIV_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_DIV_wrapper
   (M_AXIS_RESULT_0_tdata,
    M_AXIS_RESULT_0_tready,
    M_AXIS_RESULT_0_tvalid,
    S_AXIS_A_0_tdata,
    S_AXIS_A_0_tready,
    S_AXIS_A_0_tvalid,
    S_AXIS_B_0_tdata,
    S_AXIS_B_0_tready,
    S_AXIS_B_0_tvalid,
    aclk_0);
  output wire [31:0]M_AXIS_RESULT_0_tdata;
  input wire M_AXIS_RESULT_0_tready;
  output wire M_AXIS_RESULT_0_tvalid;
  input wire [31:0]S_AXIS_A_0_tdata;
  output wire S_AXIS_A_0_tready;
  input wire S_AXIS_A_0_tvalid;
  input wire [31:0]S_AXIS_B_0_tdata;
  output wire S_AXIS_B_0_tready;
  input wire S_AXIS_B_0_tvalid;
  input wire aclk_0;

  design_DIV design_DIV_i
       (.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
        .M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
        .M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid),
        .S_AXIS_A_0_tdata(S_AXIS_A_0_tdata),
        .S_AXIS_A_0_tready(S_AXIS_A_0_tready),
        .S_AXIS_A_0_tvalid(S_AXIS_A_0_tvalid),
        .S_AXIS_B_0_tdata(S_AXIS_B_0_tdata),
        .S_AXIS_B_0_tready(S_AXIS_B_0_tready),
        .S_AXIS_B_0_tvalid(S_AXIS_B_0_tvalid),
        .aclk_0(aclk_0));
endmodule

    