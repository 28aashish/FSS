
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
    BRAM_PORTA_0_we);
  input [9:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [31:0]BRAM_PORTA_0_din;
  output [31:0]BRAM_PORTA_0_dout;
  input BRAM_PORTA_0_en;
  input [0:0]BRAM_PORTA_0_we;

  wire [9:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [31:0]BRAM_PORTA_0_din;
  wire [31:0]BRAM_PORTA_0_dout;
  wire BRAM_PORTA_0_en;
  wire [0:0]BRAM_PORTA_0_we;

  design_BRAM_A design_BRAM_A_i
       (.addra(BRAM_PORTA_0_addr),
        .clka(BRAM_PORTA_0_clk),
        .dina(BRAM_PORTA_0_din),
        .douta(BRAM_PORTA_0_dout),
        .ena(BRAM_PORTA_0_en),
        .wea(BRAM_PORTA_0_we));
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
  input [11:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [306:0]BRAM_PORTA_0_din;
  output [306:0]BRAM_PORTA_0_dout;
  input BRAM_PORTA_0_en;
  input [0:0]BRAM_PORTA_0_we;

  wire [11:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [306:0]BRAM_PORTA_0_din;
  wire [306:0]BRAM_PORTA_0_dout;
  wire BRAM_PORTA_0_en;
  wire [0:0]BRAM_PORTA_0_we;

  design_CTRL design_CTRL_i
       (.addra(BRAM_PORTA_0_addr),
        .clka(BRAM_PORTA_0_clk),
        .dina(BRAM_PORTA_0_din),
        .douta(BRAM_PORTA_0_dout),
        .ena(BRAM_PORTA_0_en),
        .wea(BRAM_PORTA_0_we));
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
  output [31:0]M_AXIS_RESULT_0_tdata;
  input M_AXIS_RESULT_0_tready;
  output M_AXIS_RESULT_0_tvalid;
  input [31:0]S_AXIS_A_0_tdata;
  output S_AXIS_A_0_tready;
  input S_AXIS_A_0_tvalid;
  input [31:0]S_AXIS_B_0_tdata;
  output S_AXIS_B_0_tready;
  input S_AXIS_B_0_tvalid;
  input [31:0]S_AXIS_C_0_tdata;
  output S_AXIS_C_0_tready;
  input S_AXIS_C_0_tvalid;
  input [7:0]S_AXIS_OPERATION_0_tdata;
  output S_AXIS_OPERATION_0_tready;
  input S_AXIS_OPERATION_0_tvalid;
  input aclk_0;

  wire [31:0]M_AXIS_RESULT_0_tdata;
  wire M_AXIS_RESULT_0_tready;
  wire M_AXIS_RESULT_0_tvalid;
  wire [31:0]S_AXIS_A_0_tdata;
  wire S_AXIS_A_0_tready;
  wire S_AXIS_A_0_tvalid;
  wire [31:0]S_AXIS_B_0_tdata;
  wire S_AXIS_B_0_tready;
  wire S_AXIS_B_0_tvalid;
  wire [31:0]S_AXIS_C_0_tdata;
  wire S_AXIS_C_0_tready;
  wire S_AXIS_C_0_tvalid;
  wire [7:0]S_AXIS_OPERATION_0_tdata;
  wire S_AXIS_OPERATION_0_tready;
  wire S_AXIS_OPERATION_0_tvalid;
  wire aclk_0;

  design_MAC design_MAC_i
       (.m_axis_result_tdata(M_AXIS_RESULT_0_tdata),
        .m_axis_result_tready(M_AXIS_RESULT_0_tready),
        .m_axis_result_tvalid(M_AXIS_RESULT_0_tvalid),
        .s_axis_a_tdata(S_AXIS_A_0_tdata),
        .s_axis_a_tready(S_AXIS_A_0_tready),
        .s_axis_a_tvalid(S_AXIS_A_0_tvalid),
        .s_axis_b_tdata(S_AXIS_B_0_tdata),
        .s_axis_b_tready(S_AXIS_B_0_tready),
        .s_axis_b_tvalid(S_AXIS_B_0_tvalid),
        .s_axis_c_tdata(S_AXIS_C_0_tdata),
        .s_axis_c_tready(S_AXIS_C_0_tready),
        .s_axis_c_tvalid(S_AXIS_C_0_tvalid),
        .s_axis_operation_tdata(S_AXIS_OPERATION_0_tdata),
        .s_axis_operation_tready(S_AXIS_OPERATION_0_tready),
        .s_axis_operation_tvalid(S_AXIS_OPERATION_0_tvalid),
        .aclk(aclk_0));
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
  output [31:0]M_AXIS_RESULT_0_tdata;
  input M_AXIS_RESULT_0_tready;
  output M_AXIS_RESULT_0_tvalid;
  input [31:0]S_AXIS_A_0_tdata;
  output S_AXIS_A_0_tready;
  input S_AXIS_A_0_tvalid;
  input [31:0]S_AXIS_B_0_tdata;
  output S_AXIS_B_0_tready;
  input S_AXIS_B_0_tvalid;
  input aclk_0;

  wire [31:0]M_AXIS_RESULT_0_tdata;
  wire M_AXIS_RESULT_0_tready;
  wire M_AXIS_RESULT_0_tvalid;
  wire [31:0]S_AXIS_A_0_tdata;
  wire S_AXIS_A_0_tready;
  wire S_AXIS_A_0_tvalid;
  wire [31:0]S_AXIS_B_0_tdata;
  wire S_AXIS_B_0_tready;
  wire S_AXIS_B_0_tvalid;
  wire aclk_0;

  design_DIV design_DIV_i
       (.m_axis_result_tdata(M_AXIS_RESULT_0_tdata),
        .m_axis_result_tready(M_AXIS_RESULT_0_tready),
        .m_axis_result_tvalid(M_AXIS_RESULT_0_tvalid),
        .s_axis_a_tvalid(S_AXIS_A_0_tdata),
        .s_axis_a_tready(S_AXIS_A_0_tready),
        .s_axis_a_tdata(S_AXIS_A_0_tvalid),
        .s_axis_b_tvalid(S_AXIS_B_0_tdata),
        .s_axis_b_tready(S_AXIS_B_0_tready),
        .s_axis_b_tdata(S_AXIS_B_0_tvalid),
        .aclk(aclk_0));
endmodule

    