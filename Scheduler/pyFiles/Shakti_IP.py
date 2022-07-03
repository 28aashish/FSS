from fileinput import filename
from io import StringIO
import fileinput
#import pysed
import os
import math
import json


import re, shutil, tempfile

NUM_PORT=2
NUM_BRAM=8
NUM_MAC_DIV_S=4
ADDR_WIDTH=12
ADDR_WIDTH_DATA_BRAM=10
CTRL_WIDTH=357
AU_SEL_WIDTH=5
BRAM_SEL_WIDTH=5
MAC_LAT=5
DIV_LAT=5
Xpara_Name="XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR"


def sed_inplace(filename, pattern, repl, multiline = False):
    '''
    Perform the pure-Python equivalent of in-place `sed` substitution: e.g.,
    `sed -i -e 's/'${pattern}'/'${repl}' "${filename}"`.
    '''
    re_flags = 0
    if multiline:
        re_flags = re.M

    # For efficiency, precompile the passed regular expression.
    pattern_compiled = re.compile(pattern, re_flags)

    # For portability, NamedTemporaryFile() defaults to mode "w+b" (i.e., binary
    # writing with updating). This is usually a good thing. In this case,
    # however, binary writing imposes non-trivial encoding constraints trivially
    # resolved by switching to text writing. Let's do that.
    with tempfile.NamedTemporaryFile(mode='w', delete=False) as tmp_file:
        with open(filename) as src_file:
            if multiline:
                content = src_file.read()
                tmp_file.write(pattern_compiled.sub(repl, content))
            else:
                for line in src_file:
                    tmp_file.write(pattern_compiled.sub(repl, line))

    # Overwrite the original file with the munged temporary file in a
    # manner preserving file attributes (e.g., permissions).
    shutil.copystat(filename, tmp_file.name)
    shutil.move(tmp_file.name, filename)

def make_tcl():
    tcl=open("./tcl/init_single.tcl", 'w')
    tcl.write("""
set memver [ get_ipdefs -filter {NAME == blk_mem_gen} ]    
set fpver [ get_ipdefs -filter {NAME == floating_point} ]
######################################################################
######################## Design BRAM_A ###############################
######################################################################
###################
""")
    stringer="""###### {0} is the depth
##############
create_ip -vlnv $memver -module_name design_BRAM_A
set_property -dict [list CONFIG.Memory_Type {{True_Dual_Port_RAM}} CONFIG.Write_Width_A {{32}} CONFIG.Read_Width_A {{32}} CONFIG.Write_Width_B {{32}} CONFIG.Read_Width_B {{32}}  CONFIG.Write_Depth_A {{{0}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.Register_PortB_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Enable_B {{Use_ENB_Pin}} CONFIG.Use_RSTA_Pin {{false}} CONFIG.Use_RSTB_Pin {{false}} CONFIG.Port_B_Clock {{100}} CONFIG.Port_B_Write_Rate {{50}} CONFIG.Port_B_Enable_Rate {{100}}] [get_ips design_BRAM_A]
set_property generate_synth_checkpoint false [get_files design_BRAM_A.xci]
generate_target {{synthesis simulation}} [get_files design_BRAM_A.xci]
"""
    if NUM_PORT==1:
        stringer="""###### {0} is the depth
##############
create_ip -vlnv $memver -module_name design_BRAM_A
set_property -dict [list CONFIG.Memory_Type {{Single_port_RAM}} CONFIG.Write_Width_A {{32}} CONFIG.Read_Width_A {{32}} CONFIG.Write_Width_B {{32}} CONFIG.Read_Width_B {{32}}  CONFIG.Write_Depth_A {{{0}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Enable_B {{Use_ENB_Pin}} CONFIG.Use_RSTA_Pin {{false}}] [get_ips design_BRAM_A]
set_property generate_synth_checkpoint false [get_files design_BRAM_A.xci]
generate_target {{synthesis simulation}} [get_files design_BRAM_A.xci]
"""
    tcl.write(stringer.format(2**ADDR_WIDTH_DATA_BRAM))
    stringer="""######################################################################
######################### Design CTRL ################################
######################################################################
###################
###### Write_Width_A is {0}
###### {1} is the depth
##############
create_ip -vlnv $memver -module_name design_CTRL
set_property -dict [list  CONFIG.Memory_Type {{Single_port_RAM}}  CONFIG.Write_Width_A {{{0}}} CONFIG.Read_Width_A {{{0}}} CONFIG.Write_Width_B {{{0}}} CONFIG.Read_Width_B {{{0}}} CONFIG.Write_Depth_A {{{1}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Use_RSTA_Pin {{false}}] [get_ips design_CTRL]
set_property generate_synth_checkpoint false [get_files design_CTRL.xci]
generate_target {{synthesis simulation}} [get_files design_CTRL.xci]


"""
    tcl.write(stringer.format(CTRL_WIDTH,2**ADDR_WIDTH))
    stringer="""######################################################################
######################### Design MAC ################################
######################################################################
###################
###### CONFIG.Operation_Type {{FMA}} 
###### CONFIG.C_Mult_Usage {{Full_Usage}}
###### CONFIG.Axi_Optimize_Goal {{Performance}}
###### CONFIG.Result_Precision_Type {{Single}} 
###### CONFIG.C_Latency {0}
##############
create_ip -vlnv $fpver -module_name design_MAC
set_property -dict [list CONFIG.Operation_Type {{FMA}} CONFIG.C_Mult_Usage {{Full_Usage}} CONFIG.Axi_Optimize_Goal {{Performance}} CONFIG.Result_Precision_Type {{Single}} CONFIG.C_Result_Exponent_Width {{8}} CONFIG.C_Result_Fraction_Width {{24}} CONFIG.Maximum_Latency {{false}} CONFIG.C_Latency {{{0}}} CONFIG.C_Rate {{1}}] [get_ips design_MAC]
set_property generate_synth_checkpoint false [get_files design_MAC.xci]
generate_target {{synthesis simulation}} [get_files design_MAC.xci]


######################################################################
######################### Design DIV ################################
######################################################################
###################
###### CONFIG.Operation_Type {{Divide}}
###### CONFIG.C_Mult_Usage {{Full_Usage}}
###### CONFIG.Axi_Optimize_Goal {{Performance}}
###### CONFIG.Result_Precision_Type {{Single}} 
###### CONFIG.C_Latency {1}
##############
create_ip -vlnv $fpver -module_name design_DIV
set_property -dict [list CONFIG.Operation_Type {{Divide}} CONFIG.Axi_Optimize_Goal {{Performance}} CONFIG.Result_Precision_Type {{Single}} CONFIG.C_Result_Exponent_Width {{8}} CONFIG.C_Result_Fraction_Width {{24}} CONFIG.C_Mult_Usage {{No_Usage}} CONFIG.Maximum_Latency {{false}} CONFIG.C_Latency {{{1}}} CONFIG.C_Rate {{1}}] [get_ips design_DIV]
set_property generate_synth_checkpoint false [get_files design_DIV.xci]
generate_target {{synthesis simulation}} [get_files design_DIV.xci]
"""
    tcl.write(stringer.format(MAC_LAT,DIV_LAT))
    tcl.close()
def make_verilog_wrapper():
    try:
        wrapper=open("./verilog/design_IP_wrappers.v", 'w')
        stringer="""
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
  input wire [{0}:0]BRAM_PORTA_0_addr;
  input wire BRAM_PORTA_0_clk;
  input wire [31:0]BRAM_PORTA_0_din;
  output wire [31:0]BRAM_PORTA_0_dout;
  input wire BRAM_PORTA_0_en;
  input wire [0:0]BRAM_PORTA_0_we;

  design_BRAM_A design_BRAM_A_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule
"""
        if(NUM_PORT>1):
            stringer="""
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
  input wire [{0}:0]BRAM_PORTA_0_addr;
  input wire BRAM_PORTA_0_clk;
  input wire [31:0]BRAM_PORTA_0_din;
  output wire [31:0]BRAM_PORTA_0_dout;
  input wire BRAM_PORTA_0_en;
  input wire [0:0]BRAM_PORTA_0_we;

  input wire [{0}:0]BRAM_PORTB_0_addr;
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
"""
        stringer+="""//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
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
  input wire [{1}:0]BRAM_PORTA_0_addr;
  input wire BRAM_PORTA_0_clk;
  input wire [{2}:0]BRAM_PORTA_0_din;
  output wire [{2}:0]BRAM_PORTA_0_dout;
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

    """
        wrapper.write(stringer.format(ADDR_WIDTH_DATA_BRAM-1,ADDR_WIDTH-1,CTRL_WIDTH-1))
        wrapper.close()
    except IOError as err: 
        print("I/O error({0})".format(err))

def adjust(file_name):
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub(Xpara_Name, 'base', line))

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('Xil_Out32', 'write_word', line))

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('Xil_In32', 'read_word', line))

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            sources.write(re.sub('xil_printf', 'printf', line))

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            sources.write(re.sub('4\*', '', line))

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            sources.write(re.sub('%7.4e', '0x%x', line))


    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            if not(re.findall("^#include", line)):
                sources.write(line)

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            if not(re.findall("platform", line)):
                sources.write(line)



    dummy_file = file_name + '.bak'
    write_obj=open(dummy_file, 'w') 
    line="""
#define {0} 0x00050000
#include "uart.h"
#include "utils.h" """
    if file_name == str('./C_files/SW.c') :
        line+="""
#include "int_to_float.h" //Already included in the main file in xilinx sdk **new** 2018.+ version
#include "float_to_int.h" //Already included in the main file in xilinx sdk **new** 2018.+ version
uint32_t *base=(uint32_t *){0};
#include "FPGALoad_INST.h"
#include "FPGALoad_A.h" 
"""
       
    write_obj.write(line.format(Xpara_Name))
    # open original file in read mode and dummy file in write mode
    with open(file_name, 'r') as read_obj, open(dummy_file, 'w') as write_obj:
        # Write given line to the dummy file
        write_obj.write(line.format(Xpara_Name) + '\n')
        # Read lines from original file one by one and append them to the dummy file
        for line in read_obj:
            write_obj.write(line)
    # remove original file
    os.remove(file_name)
    # Rename dummy file as the original file
    os.rename(dummy_file, file_name)



def make_adjustment_C_files():
    adjust("./C_files/SW.c")
    adjust("./C_files/FPGALoad_A.h")
    adjust("./C_files/FPGALoad_INST.h")

def make_adjustment_V_files():

    file_name="./verilog/myip_AXI_LUD_wrapper.v"
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            if not(re.findall("clk_1x", line)):
                sources.write(line)
    file_name="./verilog/myip_AXI_LUD.v"
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            if not(re.findall("input wire clk_1x", line)):
                sources.write(line)                
    file_name="./verilog/myip_AXI_LUD.v"
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:            
            sources.write(re.sub('clk_1x', 'S_AXI_ACLK', line))

if __name__ == "__main__":
    os.makedirs("./tcl", exist_ok=True)
    os.makedirs("./verilog", exist_ok=True)
    # Opening JSON file
    f = open('IO.json')
    
    # returns JSON object as
    # a dictionary
    data = json.load(f)
    Xpara_Name=str(data["Xpara_Name"])
    NUM_PORT=data['NUM_PORT']
    NUM_BRAM=data['NUM_BRAM']
    NUM_MAC_DIV_S=data['NUM_MAC_DIV_S']
    ADDR_WIDTH=data['ADDR_WIDTH']
    ADDR_WIDTH_DATA_BRAM=data['ADDR_WIDTH_DATA_BRAM']
    CTRL_WIDTH=data['CTRL_WIDTH']
    AU_SEL_WIDTH=data['AU_SEL_WIDTH']
    BRAM_SEL_WIDTH=data['BRAM_SEL_WIDTH']
    MAC_LAT=data['MAC_LAT']
    DIV_LAT=data['DIV_LAT']
    # Iterating through the json
    # list 
    # Closing file
    f.close()
#    make_tcl()
    make_verilog_wrapper()
    make_adjustment_C_files()
#    make_adjustment_V_files()