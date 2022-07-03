from io import StringIO
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

def make_config():
    config=open("./OpenRAM_config/CTRL.py", 'w')
    stringer="""# Data word size
word_size = {0}

# Number of words in the memory
num_words = {1}

# Technology to use in $OPENRAM_TECH
tech_name = "sky130A"

# You can use the technology nominal corner only
# nominal_corner_only = True

process_corners = ["SS", "TT", "FF"]
# process_corners = ["TT"]

# Voltage corners to characterize
supply_voltages = [ 1.8 ]
# supply_voltages = [ 3.0, 3.3, 3.5 ]
num_rw_ports=1
# Temperature corners to characterize
# temperatures = [ 0, 25 100]

# Output directory for the results
output_path = "CTRL"
# Output file base name
output_name = "CTRL_{{0}}_{{1}}_{{2}}".format(word_size,num_words,tech_name)

# Disable analytical models for full characterization (WARNING: slow!)
# analytical_delay = False
"""
    config.write(stringer.format(CTRL_WIDTH,2**ADDR_WIDTH))
    config.close()
    config=open("./OpenRAM_config/DATA.py", 'w')
    stringer="""# Data word size
word_size = 32

# Number of words in the memory
num_words = {0}

# Technology to use in $OPENRAM_TECH
tech_name = "sky130A"

# You can use the technology nominal corner only
# nominal_corner_only = True

process_corners = ["SS", "TT", "FF"]
# process_corners = ["TT"]

# Voltage corners to characterize
supply_voltages = [ 1.8 ]
# supply_voltages = [ 3.0, 3.3, 3.5 ]
num_rw_ports={1}
# Temperature corners to characterize
# temperatures = [ 0, 25 100]

# Output directory for the results
output_path = "DATA"
# Output file base name
output_name = "DATA_{{0}}_{{1}}_{{2}}".format(word_size,num_words,tech_name)

# Disable analytical models for full characterization (WARNING: slow!)
# analytical_delay = False
"""
    config.write(stringer.format(2**ADDR_WIDTH_DATA_BRAM,NUM_PORT))
    config.close()
def alterLUD():
    file_name=str("./verilog/autoFiles/LUDHardware.v")
#"""    
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('M_AXIS_RESULT_tdata', 'output_ans', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('M_AXIS_RESULT_tready', 'output_ans_ack', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('M_AXIS_RESULT_tvalid', 'output_ans_stb', line))  
#            
#
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_A_tdata', 'input_a', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_A_tready', 'input_a_ack', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_A_tvalid', 'input_a_stb', line))  
#
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_B_tdata', 'input_b', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_B_tready', 'input_b_ack', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_B_tvalid', 'input_b_stb', line))    
#
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_C_tdata', 'input_c', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_C_tready', 'input_c_ack', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_C_tvalid', 'input_c_stb', line))    
#            
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_OPERATION_tdata', 'input_op', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_OPERATION_tready', 'input_op_ack', line))  
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('S_AXIS_OPERATION_tvalid', 'input_op_stb', line))    
#    with open(file_name, "r") as sources:
#        lines = sources.readlines()
#    with open(file_name, "w") as sources:
#        for line in lines:
#            sources.write(re.sub('.aclk\(CLK_100\)', '.aclk(CLK_100),.rstn(locked)', line))   
#"""
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('design_BRAM_A_wrapper', 'DATA_{0}_{1}_{2}'.format("""32""",2**ADDR_WIDTH_DATA_BRAM,"""sky130A"""), line))      

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_addr','addr0', line))                 
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_clk','clk0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_din','din0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_dout','dout0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_en','csb0', line))                                          
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_we','web0', line))    

    file_name=str("./verilog/autoFiles/hardwareTester.v")
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('design_CTRL_wrapper', 'CTRL_{0}_{1}_{2}'.format(CTRL_WIDTH,2**ADDR_WIDTH,"""sky130A"""), line))      

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_addr','addr0', line))                 
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_clk','clk0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_din','din0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_dout','dout0', line))      
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_en','csb0', line))                                          
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('BRAM_PORTA_we','web0', line))    

def CustomMem():
    Mem=open("./verilog/Custom_module/Memory.v", 'w')
    stringer="""
module CTRL_{0}_{1}_sky130A(
// Port 0: RW
    clk0,csb0,web0,addr0,din0,dout0
  );

  parameter DATA_WIDTH = {0} ;
  parameter ADDR_WIDTH = {2} ;
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


module DATA_32_{3}_sky130A(
// Port 0: RW
    clk0,csb0,web0,addr0,din0,dout0
  );

  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = {4} ;
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

    """
    Mem.write(stringer.format(CTRL_WIDTH,2**ADDR_WIDTH,ADDR_WIDTH,2**ADDR_WIDTH_DATA_BRAM,ADDR_WIDTH_DATA_BRAM))
    Mem.close()

def baseSDC():
    SDCC=open("./base.sdc", 'w')
    SDCC.write("""
###############################################################################
current_design LUDH_TEST_WRAPPER
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name CLK_100  -period 20.0000 [get_ports {CLK_100}]
    """)
    stinger="""set_input_delay 15.0000 -clock [get_clocks clk1] -add_delay [get_ports {{[*]}}]"""


def LUDHardware_verilog():
    vhdFile  = open("./verilog/autoFiles/LUDHardware.v", 'w')
    if NUM_PORT==4:
        stringer="""
module LUDHardware 
    #(
        ADDR_WIDTH = {0},
        CTRL_WIDTH = {1},
        AU_SEL_WIDTH = {2},
        BRAM_SEL_WIDTH = {3}
    ) 
    (
        input CLK_100,
        input CLK_200,
        input locked,
        input [CTRL_WIDTH-1:0] CTRL_Signal,

//These ports will be connected to the ZYNQ processing system
    """
    else :
        stringer="""
module LUDHardware 
    #(
        ADDR_WIDTH = {0},
        CTRL_WIDTH = {1},
        AU_SEL_WIDTH = {2},
        BRAM_SEL_WIDTH = {3}
    ) 
    (
        input CLK_100,
        input locked,
        input [CTRL_WIDTH-1:0] CTRL_Signal,

//These ports will be connected to the ZYNQ processing system"""
    vhdFile.write(stringer.format(ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH))
    stringer="""
        input [ADDR_WIDTH-1:0]bram_ZYNQ_block_{0}_addr,
        input [31:0]bram_ZYNQ_block_{0}_din,
        output [31:0]bram_ZYNQ_block_{0}_dout,
        input bram_ZYNQ_block_{0}_en,
        input bram_ZYNQ_block_{0}_we,        

        """
    for idx in range(65, 65 + NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx)))
    vhdFile.write("""

        input bram_ZYNQ_sel
        
    );

    wire RST;
        """)
    
    stringer="""wire [31:0]inputLocations[{0}:0];"""
    vhdFile.write(stringer.format(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT))
    stringer="""
    wire [ADDR_WIDTH-1:0] block_{0}_port{1}_addr;
    wire [31:0] block_{0}_port{1}_din;
    wire [31:0] block_{0}_port{1}_dout;
    wire block_{0}_port{1}_en;
    wire block_{0}_port{1}_we;
    """
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))
    if NUM_PORT==4:
        stringer="""
    wire [ADDR_WIDTH-1:0] bram_{0}_port{1}_addr;
    wire [31:0] bram_{0}_port{1}_din;
    wire [31:0] bram_{0}_port{1}_dout;
    wire bram_{0}_port{1}_en;
    wire bram_{0}_port{1}_we;
    """
        for id0 in range(65, 65 + NUM_BRAM):
            for id1 in range(97, 97 + NUM_PORT):
                vhdFile.write(stringer.format(chr(id0),chr(id1)))
    
    
    stringer=""" 
    wire [31:0] mac_{0}_result_tdata;
    wire [31:0] mac_{0}_a_tdata;
    wire [31:0]mac_{0}_b_tdata;
    wire [31:0] mac_{0}_c_tdata;
    wire [7:0] mac_{0}_operation_tdata;

    wire mac_{0}_a_signInv;

    wire [31:0]mac_{0}_a_tdataIN;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
    stringer=""" 
    wire [31:0] div_{0}_result_tdata;
    wire [31:0] div_{0}_a_tdata;
    wire [31:0] div_{0}_b_tdata;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
    stringer="""
    wire [AU_SEL_WIDTH-1:0] mac_{0}_a_sel;
    wire [AU_SEL_WIDTH-1:0] mac_{0}_b_sel;
    wire [AU_SEL_WIDTH-1:0] mac_{0}_c_sel;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
        
    stringer="""
    wire [AU_SEL_WIDTH-1:0] div_{0}_a_sel;
    wire [AU_SEL_WIDTH-1:0] div_{0}_b_sel;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))      
    if NUM_PORT==4:
        stringer="""
        wire [BRAM_SEL_WIDTH-1 : 0] bram_{0}_{1}_sel;"""
    else :
        stringer="""
        wire [BRAM_SEL_WIDTH-1 : 0] block_{0}_{1}_sel;"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))  
    
    vhdFile.write("""

    //-Mux signals for connection to ZYNQ system
    
    """)    
    stringer="""


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_{0}_addr;
    wire [31:0] bram_mux_out_block_{0}_din;
    wire [31:0] bram_decoder_in_block_{0};  
    wire bram_mux_out_block_{0}_en;
    wire bram_mux_out_block_{0}_we;

    """
    if NUM_PORT%2==0:
            stringer+="""wire bram_mux_out_block_{0}_clock;"""

    for id0 in range(65, 65 + NUM_BRAM):
        vhdFile.write(stringer.format(chr(id0)))

    for id0 in range(65, 65 + NUM_BRAM):
        if NUM_PORT==4:
            stringer="""
    quadPortBRAM #({1},32) BRAM_{0}
    (
        CLK_100,
        CLK_200,
        RST,
        """
            vhdFile.write(stringer.format(chr(id0),ADDR_WIDTH_DATA_BRAM))
            for id1 in range(65, 65 + 4):
                stringer="""
        bram_{0}_port{2}_addr,
        bram_{0}_port{2}_din,
        bram_{0}_port{2}_dout,
        bram_{0}_port{2}_en,
        bram_{0}_port{2}_we,
                
                """
                vhdFile.write(stringer.format(chr(id0),chr(id1),chr(id1+97-65)))
            for id1 in range(65, 65 + 2):
                stringer="""
        block_{0}_port{2}_addr,
        block_{0}_port{2}_din,
        block_{0}_port{2}_dout,
        block_{0}_port{2}_en,
        block_{0}_port{2}_we    
            
            """
                vhdFile.write(stringer.format(chr(id0),chr(id1),chr(id1+97-65)))
                if(id1==65):
                    vhdFile.write(""",""")
            vhdFile.write("""
        );
            """)
        stringer="""
    design_BRAM_A_wrapper block_{0} (    
        """
        #vhdFile.write(stringer.format(chr(id0)))
        stringer+="""
        .BRAM_PORTA_addr(bram_mux_out_block_{0}_addr),
        .BRAM_PORTA_clk(CLK_{1}00),
        .BRAM_PORTA_din(bram_mux_out_block_{0}_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_{0}),
        .BRAM_PORTA_en(bram_mux_out_block_{0}_en),
        .BRAM_PORTA_we(bram_mux_out_block_{0}_we)"""
        if NUM_PORT>1:
            stringer+=""",

        .BRAM_PORTB_addr(block_{0}_portb_addr),
        .BRAM_PORTB_clk(CLK_{1}00),
        .BRAM_PORTB_din(block_{0}_portb_din),
        .BRAM_PORTB_dout(block_{0}_portb_dout),
        .BRAM_PORTB_en(block_{0}_portb_en),
        .BRAM_PORTB_we(block_{0}_portb_we)
            """
        #vhdFile.write(stringer.format(chr(id0), 2 if 4 == NUM_PORT else 1 ))
        stringer+="""
    );
    bram_ZYNQ_mux #(ADDR_WIDTH) bram_ZYNQ_mux_{0} 
        ( bram_ZYNQ_block_{0}_addr,
          bram_ZYNQ_block_{0}_din,
          bram_ZYNQ_block_{0}_en,
          bram_ZYNQ_block_{0}_we,
          block_{0}_porta_addr,
          block_{0}_porta_din,
          block_{0}_porta_en,
          block_{0}_porta_we,
          bram_mux_out_block_{0}_addr,
          bram_mux_out_block_{0}_din,
          bram_mux_out_block_{0}_en,
          bram_mux_out_block_{0}_we,
          bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder #(32) bram_ZYNQ_decoder_{0}
        ( bram_decoder_in_block_{0},
          bram_ZYNQ_block_{0}_dout,
          block_{0}_porta_dout,
          bram_ZYNQ_sel
          );
    
    """
    for id0 in range(65, 65 + NUM_BRAM):
            vhdFile.write(stringer.format(chr(id0), 2 if 4 == NUM_PORT else 1 ))
    vhdFile.write("""
    wire [31:0]LOCKED32 ={32{locked}};        
        """)
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    mac MAC_{0} (CLK_100,mac_{0}_a_tdata & LOCKED32,mac_{0}_b_tdata & LOCKED32,mac_{0}_c_tdata & LOCKED32,mac_{0}_operation_tdata[0] & locked, mac_{0}_result_tdata);        
        """
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    wire [31:0] DIVDER_{0};     
    assign DIVDER_{0} = locked ? div_A_b_tdata : 32'h00000001;       
    div DIV_{0} (CLK_100,div_{0}_a_tdata & LOCKED32,DIVDER_{0},div_{0}_result_tdata);
        """
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
// input locations
    
    """)
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    assign inputLocations[{0}] = mac_{1}_result_tdata;"""
        vhdFile.write(stringer.format(id0-65,chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    assign inputLocations[{0}] = div_{1}_result_tdata;"""
        vhdFile.write(stringer.format(id0-65+NUM_MAC_DIV_S,chr(id0)))

    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            if NUM_PORT==4:
                stringer="""
    assign inputLocations[{0}] = bram_{1}_port{2}_dout;"""
            else :
                stringer="""
    assign inputLocations[{0}] = block_{1}_port{2}_dout;"""
            vhdFile.write(stringer.format((id0-65)*NUM_PORT+(id1-97)+NUM_MAC_DIV_S*2,chr(id0),chr(id1)))
    stringer="""
    assign inputLocations[{0}] = 0;     
    """
    vhdFile.write(stringer.format(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT))

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    MUX_AU_IN MUX_MAC_IN_{0}_b(
        mac_{0}_b_sel,
        """
        stringer0="""
        inputLocations[{0}],"""
        for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
            stringer+=stringer0.format(id1)
        stringer+="""
                mac_{0}_b_tdata
    );

    MUX_AU_IN MUX_MAC_IN_{0}_c 
    (
        mac_{0}_c_sel,
"""
        for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
            stringer+=stringer0.format(id1)
        stringer+="""
                mac_{0}_c_tdata
    );

    MUX_AU_IN MUX_MAC_IN_{0}_a 
    (
        mac_{0}_a_sel,
"""
        for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
            stringer+=stringer0.format(id1)
        stringer+="""
        mac_{0}_a_tdataIN
    );
    assign mac_{0}_a_signInv = !mac_{0}_a_tdataIN[31];
    assign mac_{0}_a_tdata = {{mac_{0}_a_signInv , mac_{0}_a_tdataIN[30:0]}};
    """
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""

    MUX_AU_IN MUX_DIV_IN_{0}_a (
        div_{0}_a_sel,"""
        stringer0="""
        inputLocations[{0}],"""
        for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
            stringer+=stringer0.format(id1)
        stringer+="""div_{0}_a_tdata
    );

    MUX_AU_IN MUX_DIV_IN_{0}_b (
        div_{0}_b_sel,"""
        for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
            stringer+=stringer0.format(id1)
        stringer+="""div_{0}_b_tdata
    );
"""     
        vhdFile.write(stringer.format(chr(id0)))
#################################
    for id0 in range(65, 65 + NUM_BRAM):
        stringer0="""
        inputLocations[{0}],"""
        if NUM_PORT==4:
            stringer="""
    MUX_BRAM_IN MUX_BRAM_{0}_a_in (
        bram_{0}_a_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""
            bram_{0}_porta_din
    );
    MUX_BRAM_IN MUX_BRAM_{0}_b_in (
        bram_{0}_b_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""
        bram_{0}_portb_din
    );
    MUX_BRAM_IN MUX_BRAM_{0}_c_in (
        bram_{0}_c_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""
            bram_{0}_portc_din
    );
    MUX_BRAM_IN MUX_BRAM_{0}_d_in(
        bram_{0}_d_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""bram_{0}_portd_din
    );


    """
        else :
            stringer="""
    MUX_BRAM_IN MUX_BRAM_{0}_a_in (
        block_{0}_a_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""block_{0}_porta_din
    );
    """
        if NUM_PORT==2:
            stringer +="""

    MUX_BRAM_IN MUX_BRAM_{0}_b_in (
        block_{0}_b_sel,"""
            for id1 in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
                stringer+=stringer0.format(id1)
            stringer+="""
        block_{0}_portb_din

    );
        
        """
        vhdFile.write(stringer.format(chr(id0),NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT-1))
    if NUM_PORT==4:
        stringer="""
    assign bram_{0}_port{1}_addr = CTRL_Signal[CTRL_WIDTH-{2}*ADDR_WIDTH-{3} : CTRL_WIDTH-{3}*ADDR_WIDTH-{2}];
    assign bram_{0}_port{1}_we = CTRL_Signal[CTRL_WIDTH-{3}*ADDR_WIDTH-{3}];"""
    else :
        stringer="""
    assign block_{0}_port{1}_addr = CTRL_Signal[CTRL_WIDTH-{2}*ADDR_WIDTH-{3} : CTRL_WIDTH-{3}*ADDR_WIDTH-{2}];
    assign block_{0}_port{1}_we = CTRL_Signal[CTRL_WIDTH-{3}*ADDR_WIDTH-{3}];"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*NUM_PORT+id1-97,(id0-65)*NUM_PORT+id1-97+1))      


    stringer="""
    assign mac_{0}_{1}_sel = CTRL_Signal[CTRL_WIDTH-{4}*ADDR_WIDTH-{2}*AU_SEL_WIDTH-{5} : CTRL_WIDTH-{4}*ADDR_WIDTH-{3}*AU_SEL_WIDTH-{4}];"""
    
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        for id1 in range(97, 97 + 3):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*3+id1-97,(id0-65)*3+id1-97+1,NUM_BRAM*NUM_PORT,NUM_PORT*NUM_BRAM+1))   

    stringer="""
    assign div_{0}_{1}_sel = CTRL_Signal[CTRL_WIDTH-{4}*ADDR_WIDTH-{2}*AU_SEL_WIDTH-{5} : CTRL_WIDTH-{4}*ADDR_WIDTH-{3}*AU_SEL_WIDTH-{4}];"""

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        for id1 in range(97, 97 + 2):
            vhdFile.write(stringer.format(chr(id0),chr(id1),NUM_MAC_DIV_S*3+(id0-65)*2+id1-97,NUM_MAC_DIV_S*3+(id0-65)*2+id1-97+1,NUM_BRAM*NUM_PORT,NUM_BRAM*NUM_PORT+1))      

    stringer="""
    assign block_{0}_{1}_sel = CTRL_Signal[CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{2}*BRAM_SEL_WIDTH-{5} : CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{3}*BRAM_SEL_WIDTH-{4}];"""
    if NUM_PORT == 4:
        stringer="""
    assign bram_{0}_{1}_sel = CTRL_Signal[CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{2}*BRAM_SEL_WIDTH-{5} : CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{3}*BRAM_SEL_WIDTH-{4}];"""

    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*NUM_PORT+id1-97,(id0-65)*NUM_PORT+id1-97+1,NUM_PORT*NUM_BRAM,NUM_BRAM*NUM_PORT+1,NUM_MAC_DIV_S*5))
    vhdFile.write("""

    //--  CTRL_Signal(0) is actually a complete signal which is required by this module during debugging

    """)
    if NUM_PORT==4:
        stringer="""
    assign bram_{0}_port{1}_en = locked;"""
    else :
        stringer="""
    assign block_{0}_port{1}_en = locked;"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))
    vhdFile.write("""
    
    assign RST = !locked;

    """)
    stringer="""

    assign mac_{0}_operation_tdata = 0;// --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
    
endmodule""")
    vhdFile.close()


if __name__ == "__main__":
    os.makedirs("./OpenRAM_config", exist_ok=True)
    os.makedirs("./verilog", exist_ok=True)
    os.makedirs("./verilog/autoFiles", exist_ok=True)
    os.makedirs("./verilog/Custom_module", exist_ok=True)
    # Opening JSON file
    f = open('IO.json')
    
    # returns JSON object as
    # a dictionary
    data = json.load(f)
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
    LUDHardware_verilog()
    make_config()
    LUDHardware_verilog()
    alterLUD()
#    baseSDC()
    CustomMem()

