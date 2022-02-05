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
    
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('M_AXIS_RESULT_tdata', 'output_ans', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('M_AXIS_RESULT_tready', 'output_ans_ack', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('M_AXIS_RESULT_tvalid', 'output_ans_stb', line))  
            

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_A_tdata', 'input_a', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_A_tready', 'input_a_ack', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_A_tvalid', 'input_a_stb', line))  

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_B_tdata', 'input_b', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_B_tready', 'input_b_ack', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_B_tvalid', 'input_b_stb', line))    

    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_C_tdata', 'input_c', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_C_tready', 'input_c_ack', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_C_tvalid', 'input_c_stb', line))    
            
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_OPERATION_tdata', 'input_op', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_OPERATION_tready', 'input_op_ack', line))  
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('S_AXIS_OPERATION_tvalid', 'input_op_stb', line))    
    with open(file_name, "r") as sources:
        lines = sources.readlines()
    with open(file_name, "w") as sources:
        for line in lines:
            sources.write(re.sub('.aclk\(CLK_100\)', '.aclk(CLK_100),.rstn(locked)', line))   


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
    make_config()
    alterLUD()
#    baseSDC()
    CustomMem()

