from io import StringIO
import os
import math
import json

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

def make_tcl():
    tcl=open("./init_single.tcl", 'w')
    tcl.write("""
set memver [ get_ipdefs -filter {NAME == blk_mem_gen} ]    
set fpver [ get_ipdefs -filter {NAME == floating_point} ]
    """)
    tcl.write("""######################################################################
######################## Design BRAM_A ###############################
######################################################################
###################
""")
    stringer="""
###### {0} is the depth
##############
create_bd_design "design_BRAM_A"
create_bd_cell -type ip -vlnv $memver blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type {{True_Dual_Port_RAM}} CONFIG.Write_Depth_A {{{0}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.Register_PortB_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Enable_B {{Use_ENB_Pin}} CONFIG.Use_RSTA_Pin {{false}} CONFIG.Use_RSTB_Pin {{false}} CONFIG.Port_B_Clock {{100}} CONFIG.Port_B_Write_Rate {{50}} CONFIG.Port_B_Enable_Rate {{100}}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_cells blk_mem_gen_0]
make_bd_intf_pins_external  [get_bd_cells blk_mem_gen_0]
save_bd_design
close_bd_design [get_bd_designs design_BRAM_A]

"""
    if NUM_PORT==1:
        stringer="""###### {0} is the depth
##############
create_bd_design "design_BRAM_A"
create_bd_cell -type ip -vlnv $memver blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type {{Single_port_RAM}} CONFIG.Write_Depth_A {{{0}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Enable_B {{Use_ENB_Pin}} CONFIG.Use_RSTA_Pin {{false}}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_cells blk_mem_gen_0]
make_bd_intf_pins_external  [get_bd_cells blk_mem_gen_0]
save_bd_design
close_bd_design [get_bd_designs design_BRAM_A]

"""
    tcl.write(stringer.format(2**ADDR_WIDTH_DATA_BRAM))
    stringer="""######################################################################
######################### Design CTRL ################################
######################################################################
###################
###### Write_Width_A is {0}
###### {1} is the depth
##############
create_bd_design "design_CTRL"
#update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv $memver blk_mem_gen_0
set_property -dict [list CONFIG.Write_Width_A {{{0}}} CONFIG.Write_Depth_A {{{1}}} CONFIG.Register_PortA_Output_of_Memory_Primitives {{false}} CONFIG.use_bram_block {{Stand_Alone}} CONFIG.Enable_32bit_Address {{false}} CONFIG.Use_Byte_Write_Enable {{false}} CONFIG.Byte_Size {{9}} CONFIG.Read_Width_A {{{0}}} CONFIG.Write_Width_B {{{0}}} CONFIG.Read_Width_B {{{0}}} CONFIG.Use_RSTA_Pin {{false}}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_cells blk_mem_gen_0]
make_bd_intf_pins_external  [get_bd_cells blk_mem_gen_0]
save_bd_design
close_bd_design [get_bd_designs design_CTRL]

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
create_bd_design "design_MAC"
create_bd_cell -type ip -vlnv $fpver floating_point_0
set_property -dict [list CONFIG.Operation_Type {{FMA}} CONFIG.C_Mult_Usage {{Full_Usage}} CONFIG.Axi_Optimize_Goal {{Performance}} CONFIG.Result_Precision_Type {{Single}} CONFIG.C_Result_Exponent_Width {{8}} CONFIG.C_Result_Fraction_Width {{24}} CONFIG.Maximum_Latency {{false}} CONFIG.C_Latency {{{0}}} CONFIG.C_Rate {{1}}] [get_bd_cells floating_point_0]
make_bd_pins_external  [get_bd_cells floating_point_0]
make_bd_intf_pins_external  [get_bd_cells floating_point_0]
save_bd_design
close_bd_design [get_bd_designs design_MAC]


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
create_bd_design "design_DIV"
create_bd_cell -type ip -vlnv $fpver floating_point_0
set_property -dict [list CONFIG.Operation_Type {{Divide}} CONFIG.Axi_Optimize_Goal {{Performance}} CONFIG.Result_Precision_Type {{Single}} CONFIG.C_Result_Exponent_Width {{8}} CONFIG.C_Result_Fraction_Width {{24}} CONFIG.C_Mult_Usage {{No_Usage}} CONFIG.Maximum_Latency {{false}} CONFIG.C_Latency {{{1}}} CONFIG.C_Rate {{1}}] [get_bd_cells floating_point_0]
make_bd_pins_external  [get_bd_cells floating_point_0]
make_bd_intf_pins_external  [get_bd_cells floating_point_0]
save_bd_design
close_bd_design [get_bd_designs design_DIV]
"""
    tcl.write(stringer.format(MAC_LAT,DIV_LAT))
def hardwareMUX_vhdl():
    MUX_AU_IN  = open("./autoFiles/HDFile/MUX_AU_IN.vhd", 'w')
    MUX_BRAM_IN  = open("./autoFiles/HDFile/MUX_BRAM_IN.vhd", 'w')
    MUX_AU_IN.write("""library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity MUX_AU_IN is
    port(
    """)
    MUX_BRAM_IN.write("""library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity MUX_BRAM_IN is
    port(""")
#NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT
    stringer="""
        SEL  : in  std_logic_vector({0}-1 downto 0);
        DIN  : in  dataArray({1} downto 0);
        DOUT : out std_logic_vector(31 downto 0)
    );
end entity;"""
    MUX_AU_IN.write(stringer.format(AU_SEL_WIDTH,NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT))
    MUX_BRAM_IN.write(stringer.format(BRAM_SEL_WIDTH,NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT-1))
    MUX_AU_IN.write(
"""
architecture behav of MUX_AU_IN is
begin
sel_process : process(SEL, DIN)
    begin
    case SEL is""")
    MUX_BRAM_IN.write(
"""
architecture behav of MUX_BRAM_IN is
begin
sel_process : process(SEL, DIN)
    begin
    case SEL is""")
    stringer="""
    when "{0}" => DOUT <= DIN({1});"""
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
        MUX_AU_IN.write(stringer.format(format(idx,'b').zfill(AU_SEL_WIDTH),idx))
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
        MUX_BRAM_IN.write(stringer.format(format(idx,'b').zfill(BRAM_SEL_WIDTH),idx))
    MUX_AU_IN.write("""
    when others => DOUT <= (others => 'X');
    end case;
end process;
end architecture;""")
    MUX_BRAM_IN.write("""
    when others => DOUT <= (others => 'X');
    end case;
end process;
end architecture;""")
def hardwareTester_vhdl():       
    vhdFile  = open("./autoFiles/HDFile/hardwareTester.vhd", 'w')
    stringer="""library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.types.all;

entity LUDH_Tester is
    generic(
        ADDR_WIDTH : integer := {0};
        CTRL_WIDTH : integer := {1}
    );
    port(
        CLK_100 : in std_logic;
        locked : in std_logic;
        RST : in std_logic;
        CTRL_SIGNAL : inout std_logic_vector(CTRL_WIDTH-1 downto 0);
        COMPLETED : out std_logic;
        START : in std_logic;
        
        --These ports will be connected to the ZYNQ processing system
        bram_ZYNQ_INST_addr : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        bram_ZYNQ_INST_din : in std_logic_vector(CTRL_WIDTH - 1 downto 0);
        bram_ZYNQ_INST_dout : out std_logic_vector(CTRL_WIDTH - 1 downto 0);
        bram_ZYNQ_INST_en : in std_logic;
        bram_ZYNQ_INST_we : in STD_LOGIC_VECTOR ( 0 to 0 ) ;
        
        --State is send as output for debugging purpose (gpio 31)
        debug_state : out std_logic_vector(1 downto 0)
    );
end entity;

architecture yoStyle of LUDH_Tester is
    --Component decleration ********************************************************************************************************************************************************************
    component design_CTRL_wrapper is
    port (
        BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( ADDR_WIDTH-1 downto 0 );
        BRAM_PORTA_clk : in STD_LOGIC;
        BRAM_PORTA_din : in STD_LOGIC_VECTOR ( CTRL_WIDTH-1 downto 0 );
        BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( CTRL_WIDTH-1 downto 0 );
        BRAM_PORTA_en : in STD_LOGIC;
        BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 )
    );
    end component design_CTRL_wrapper;
     --Component decleration ends ****************************************************************************************************************************************************************

    signal CTRL_SIGNAL_temp : std_logic_vector(CTRL_WIDTH-1 downto 0);

    signal ctrl_last: std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal ctrl_addr, ctrl_addr_in : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal run_test, test_completed, sync_start : std_logic;
    signal reg_en, complete_bit : std_logic := '0';
    signal reset_counter_reg : std_logic := '1';
    signal reset_counter : std_logic;
    signal pr_state,nxt_state : std_logic_vector(1 downto 0) := "00";
    
    --Mux signals
    signal muxout_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal muxout_din : std_logic_vector(CTRL_WIDTH - 1 downto 0);
    signal decoder_input : std_logic_vector(CTRL_WIDTH - 1 downto 0);
    signal muxout_en : std_logic;
    signal muxout_we : STD_LOGIC_VECTOR ( 0 to 0 );
    
begin

    --debug signals
    debug_state <= pr_state;

    complete_bit <= CTRL_SIGNAL(0);
    
    reg_en <= locked and run_test;

    COMPLETED <= test_completed; --This signal is such that it will be 0 only when LUD hardware is running. Else it will be 1
                                 --This is required for the individual cycle bram dump in test bench
    
    reset_counter <= RST or reset_counter_reg;
    
    --once operation is completed, the address will no longer be incremented
    ctrl_addr_in <= std_logic_vector(to_unsigned(to_integer(unsigned(ctrl_addr)) + 1, ADDR_WIDTH)) when (reg_en = '1') else (others => '0');

    ctrlAddrReg : entity myReg
    generic map(ADDR_WIDTH)
    port map(
        CLK => CLK_100,
        ARST => reset_counter,
        ENA => reg_en,
        DIN => ctrl_addr_in,
        DOUT => ctrl_addr
    );
    
    --This register ensures that the sync_start signal is 1 always at the rising edge of clock and not somewhere in between the clock.
--    sync_start_reg : entity myReg_single_bit
--    port map(
--        CLK => CLK_100,
--        ARST => RST,
--        ENA => '1',
--        DIN => START,
--        DOUT => sync_start
--    );
    sync_start <= START;
    
    --FSM
    --sync_start and complete_bit are the input to FSM. test_completed, reset_counter_reg, and run_test are the output to FSM
    process(CLK_100)
    begin
    if(CLK_100'event and CLK_100 = '1') then
        If(RST = '1') then
            pr_state <= "00";
        else
            pr_state <= nxt_state;
        end if;
    end if;
    end process;
    
    process(pr_state, sync_start, complete_bit)
    begin
    case pr_state is
    when "00" =>
        test_completed <= '1';
        run_test <= '0';
        reset_counter_reg <= '1';
        if(sync_start = '1') then
            nxt_state <= "01";
        else
            nxt_state <= "00";
        end if;
    when "01" =>
        test_completed <= '0';
        run_test <= '1';
        reset_counter_reg <= '0';
        if(sync_start = '1') then
            if(complete_bit = '1') then
                nxt_state <= "10";
            elsif(complete_bit = '0')then
                nxt_state <= "01";
            end if;
        else
            nxt_state <= "00";
        end if;
    when "10" =>
        test_completed <= '1';
        run_test <= '0';
        reset_counter_reg <= '0';
        if(sync_start = '1') then
            nxt_state <= "10";
        else
            nxt_state <= "00";
        end if;
    when others =>
        test_completed <= '1';
        run_test <= '0';
        reset_counter_reg <= '1';
        nxt_state <= "00";
    end case;
    end process;
    
    ctrlStorage : design_CTRL_wrapper
    port map (
    BRAM_PORTA_addr => muxout_addr ,
    BRAM_PORTA_clk => CLK_100,
    BRAM_PORTA_din => muxout_din ,
    BRAM_PORTA_dout => decoder_input ,
    BRAM_PORTA_en => muxout_en ,
    BRAM_PORTA_we => muxout_we
    );
    
    muxout_addr <= bram_ZYNQ_INST_addr when (sync_start = '0') else ctrl_addr(ADDR_WIDTH-1 downto 0);
    muxout_din <= bram_ZYNQ_INST_din when (sync_start = '0') else (others => '0');
    muxout_en <= bram_ZYNQ_INST_en when (sync_start = '0') else '1';
    muxout_we <= bram_ZYNQ_INST_we when (sync_start = '0') else "0";
    
    bram_ZYNQ_decoder_INST :entity bram_ZYNQ_decoder
    generic map (width => CTRL_WIDTH)
    port map(decoder_in => decoder_input,
          decoder_out_0 => bram_ZYNQ_INST_dout,
          decoder_out_1 => CTRL_SIGNAL_temp,
          sel => sync_start
    );
    
    CTRL_SIGNAL <= (others => '0') when (sync_start = '0') else CTRL_SIGNAL_temp;
end architecture;
    """
    vhdFile.write(stringer.format(ADDR_WIDTH,CTRL_WIDTH,ADDR_WIDTH-1,CTRL_WIDTH-1))
    vhdFile.close()

def LUDHardware_vhdl():
    vhdFile  = open("./autoFiles/HDFile/LUDHardware.vhd", 'w')
    if NUM_PORT==4:
        stringer="""
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.types.all;

entity LUDHardware is
    generic(
        ADDR_WIDTH : integer := {0};
        CTRL_WIDTH : integer := {1};
        AU_SEL_WIDTH : integer := {2};
        BRAM_SEL_WIDTH : integer := {3}
    );
    port(
        CLK_100 : in std_logic;
        CLK_200 : in std_logic;
        locked : in std_logic;
        CTRL_Signal : in std_logic_vector(CTRL_WIDTH-1 downto 0);
    --These ports will be connected to the ZYNQ processing system
    """
    else :
        stringer="""
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.types.all;

entity LUDHardware is
    generic(
        ADDR_WIDTH : integer := {0};
        CTRL_WIDTH : integer := {1};
        AU_SEL_WIDTH : integer := {2};
        BRAM_SEL_WIDTH : integer := {3}
    );
    port(
        CLK_100 : in std_logic;
        locked : in std_logic;
        CTRL_Signal : in std_logic_vector(CTRL_WIDTH-1 downto 0);
    --These ports will be connected to the ZYNQ processing system"""
    vhdFile.write(stringer.format(ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH))
    stringer="""
        bram_ZYNQ_block_{0}_addr : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        bram_ZYNQ_block_{0}_din : in std_logic_vector(31 downto 0);
        bram_ZYNQ_block_{0}_dout : out std_logic_vector(31 downto 0);
        bram_ZYNQ_block_{0}_en : in std_logic;
        bram_ZYNQ_block_{0}_we : in std_logic;
        
        """
    for idx in range(65, 65 + NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx)))
    vhdFile.write("""
                bram_ZYNQ_sel : in std_logic
        
    );
end entity;
architecture yoStyle of LUDHardware is

    --Component decleration *************************************************************************
    component design_BRAM_A_wrapper is
    port (
        """
    )
    stringer="""
        
        BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( {0} downto 0 );
        BRAM_PORTA_clk : in STD_LOGIC;
        BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTA_en : in STD_LOGIC;
        BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 );    
    
        BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( {0} downto 0 );
        BRAM_PORTB_clk : in STD_LOGIC;
        BRAM_PORTB_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTB_en : in STD_LOGIC;
        BRAM_PORTB_we : in STD_LOGIC_VECTOR ( 0 to 0 )   
	"""
    if NUM_PORT == 1:
        stringer="""
        BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( {0} downto 0 );
        BRAM_PORTA_clk : in STD_LOGIC;
        BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
        BRAM_PORTA_en : in STD_LOGIC;
        BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 )
    """
	
#    for idx in range(65, 65 + 2 if 1 < NUM_PORT else 1):
#        vhdFile.write(stringer.format(chr(idx),ADDR_WIDTH_DATA_BRAM-1)) 
    vhdFile.write(stringer.format(ADDR_WIDTH_DATA_BRAM-1))
    vhdFile.write("""
        );
    end component design_BRAM_A_wrapper;
    
    component design_MAC_wrapper is
    port (
        M_AXIS_RESULT_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        M_AXIS_RESULT_tready : in STD_LOGIC;
        M_AXIS_RESULT_tvalid : out STD_LOGIC;
        S_AXIS_A_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        S_AXIS_A_tready : out STD_LOGIC;
        S_AXIS_A_tvalid : in STD_LOGIC;
        S_AXIS_B_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        S_AXIS_B_tready : out STD_LOGIC;
        S_AXIS_B_tvalid : in STD_LOGIC;
        S_AXIS_C_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        S_AXIS_C_tready : out STD_LOGIC;
        S_AXIS_C_tvalid : in STD_LOGIC;
        S_AXIS_OPERATION_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
        S_AXIS_OPERATION_tready : out STD_LOGIC;
        S_AXIS_OPERATION_tvalid : in STD_LOGIC;
        aclk : in STD_LOGIC
    );
    end component design_MAC_wrapper;
    
    component design_DIV_wrapper is
    port (
        M_AXIS_RESULT_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        M_AXIS_RESULT_tready : in STD_LOGIC;
        M_AXIS_RESULT_tvalid : out STD_LOGIC;
        S_AXIS_A_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        S_AXIS_A_tready : out STD_LOGIC;
        S_AXIS_A_tvalid : in STD_LOGIC;
        S_AXIS_B_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        S_AXIS_B_tready : out STD_LOGIC;
        S_AXIS_B_tvalid : in STD_LOGIC;
        aclk : in STD_LOGIC
    );
    end component design_DIV_wrapper;
    
    --Component decleration ends ****************************************************************************************************************************************************************

    signal RST : std_logic;

    
    """)
    stringer="""signal inputLocations : dataArray({0} downto 0);"""
    vhdFile.write(stringer.format(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT))
    stringer="""
    signal block_{0}_port{1}_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal block_{0}_port{1}_din  : std_logic_vector(31 downto 0);
    signal block_{0}_port{1}_dout : std_logic_vector(31 downto 0);
    signal block_{0}_port{1}_en   : std_logic;
    signal block_{0}_port{1}_we   : std_logic;
    """
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))
    if NUM_PORT==4:
        stringer="""
    signal bram_{0}_port{1}_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal bram_{0}_port{1}_din  : std_logic_vector(31 downto 0);
    signal bram_{0}_port{1}_dout : std_logic_vector(31 downto 0);
    signal bram_{0}_port{1}_en   : std_logic;
    signal bram_{0}_port{1}_we   : std_logic;    

    """
        for id0 in range(65, 65 + NUM_BRAM):
            for id1 in range(97, 97 + NUM_PORT):
                vhdFile.write(stringer.format(chr(id0),chr(id1)))
    
    
    stringer=""" 
    signal mac_{0}_result_tdata : std_logic_vector(31 downto 0);
    signal mac_{0}_result_tready : std_logic;
    signal mac_{0}_result_tvalid : std_logic;

    signal mac_{0}_a_tdata : std_logic_vector(31 downto 0);
    signal mac_{0}_a_tready : std_logic;
    signal mac_{0}_a_tvalid : std_logic;

    signal mac_{0}_b_tdata : std_logic_vector(31 downto 0);
    signal mac_{0}_b_tready : std_logic;
    signal mac_{0}_b_tvalid : std_logic;

    signal mac_{0}_c_tdata : std_logic_vector(31 downto 0);
    signal mac_{0}_c_tready : std_logic;
    signal mac_{0}_c_tvalid : std_logic;

    signal mac_{0}_operation_tdata : std_logic_vector(7 downto 0);
    signal mac_{0}_operation_tready : std_logic;
    signal mac_{0}_operation_tvalid : std_logic;
    signal mac_{0}_a_signInv : std_logic;
    signal mac_{0}_a_tdataIN : std_logic_vector(31 downto 0);
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
    stringer=""" 
    signal div_{0}_result_tdata : std_logic_vector(31 downto 0);
    signal div_{0}_result_tready : std_logic;
    signal div_{0}_result_tvalid : std_logic;

    signal div_{0}_a_tdata : std_logic_vector(31 downto 0);
    signal div_{0}_a_tready : std_logic;
    signal div_{0}_a_tvalid : std_logic;

    signal div_{0}_b_tdata : std_logic_vector(31 downto 0);
    signal div_{0}_b_tready : std_logic;
    signal div_{0}_b_tvalid : std_logic;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
    stringer="""
    signal mac_{0}_a_sel : std_logic_vector(AU_SEL_WIDTH-1 downto 0);
    signal mac_{0}_b_sel : std_logic_vector(AU_SEL_WIDTH-1 downto 0);
    signal mac_{0}_c_sel : std_logic_vector(AU_SEL_WIDTH-1 downto 0);
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
        
    stringer="""
    signal div_{0}_a_sel : std_logic_vector(AU_SEL_WIDTH-1 downto 0);
    signal div_{0}_b_sel : std_logic_vector(AU_SEL_WIDTH-1 downto 0);
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))      
    if NUM_PORT==4:
        stringer="""
        signal bram_{0}_{1}_sel : std_logic_vector(BRAM_SEL_WIDTH-1 downto 0);"""
    else :
        stringer="""
        signal block_{0}_{1}_sel : std_logic_vector(BRAM_SEL_WIDTH-1 downto 0);"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))  
    
    vhdFile.write("""

    --Mux signals for connection to ZYNQ system
    
    """)    
    stringer="""

    signal bram_mux_out_block_{0}_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal bram_mux_out_block_{0}_din : std_logic_vector(31 downto 0);
    signal bram_decoder_in_block_{0} : std_logic_vector(31 downto 0);  
    signal bram_mux_out_block_{0}_en : std_logic;
    signal bram_mux_out_block_{0}_we : std_logic;
    """
    if NUM_PORT%2==0:
            stringer+="""signal bram_mux_out_block_{0}_clock : std_logic;"""

    for id0 in range(65, 65 + NUM_BRAM):
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
    
begin

    """)

    for id0 in range(65, 65 + NUM_BRAM):
        if NUM_PORT==4:
            stringer="""
    BRAM_{0} : entity quadPortBRAM
    generic map({1}, 32)
    port MAP(
        CLK_1X          => CLK_100,
        CLK_2X          => CLK_200,
        RST             => RST,
        """
            vhdFile.write(stringer.format(chr(id0),ADDR_WIDTH_DATA_BRAM))
            for id1 in range(65, 65 + 4):
                stringer="""
        BRAM_PORT{1}_ADDR    => bram_{0}_port{2}_addr,
        BRAM_PORT{1}_DIN     => bram_{0}_port{2}_din,
        BRAM_PORT{1}_DOUT    => bram_{0}_port{2}_dout,
        BRAM_PORT{1}_EN      => bram_{0}_port{2}_en,
        BRAM_PORT{1}_WE      => bram_{0}_port{2}_we,
                
                """
                vhdFile.write(stringer.format(chr(id0),chr(id1),chr(id1+97-65)))
            for id1 in range(65, 65 + 2):
                stringer="""
        BLOCK_PORT{1}_ADDR    => block_{0}_port{2}_addr,
        BLOCK_PORT{1}_DIN     => block_{0}_port{2}_din,
        BLOCK_PORT{1}_DOUT    => block_{0}_port{2}_dout,
        BLOCK_PORT{1}_EN      => block_{0}_port{2}_en,
        BLOCK_PORT{1}_WE      => block_{0}_port{2}_we    
            
            """
                vhdFile.write(stringer.format(chr(id0),chr(id1),chr(id1+97-65)))
                if(id1==65):
                    vhdFile.write(""",""")
            vhdFile.write("""
        );
            """)
        stringer="""
    block_{0} : design_BRAM_A_wrapper
    port map (    
        """
        #vhdFile.write(stringer.format(chr(id0)))
        stringer+="""
        BRAM_PORTA_addr     => bram_mux_out_block_{0}_addr,
        BRAM_PORTA_clk      => CLK_{1}00,
        BRAM_PORTA_din      => bram_mux_out_block_{0}_din,
        BRAM_PORTA_dout     => bram_decoder_in_block_{0},
        BRAM_PORTA_en       => bram_mux_out_block_{0}_en,
        BRAM_PORTA_we(0)       => bram_mux_out_block_{0}_we"""
        if NUM_PORT>1:
            stringer+=""",

        BRAM_PORTB_addr     => block_{0}_portb_addr,
        BRAM_PORTB_clk      => CLK_{1}00,
        BRAM_PORTB_din      => block_{0}_portb_din,
        BRAM_PORTB_dout     => block_{0}_portb_dout,
        BRAM_PORTB_en       => block_{0}_portb_en,
        BRAM_PORTB_we(0)       => block_{0}_portb_we
            """
        #vhdFile.write(stringer.format(chr(id0), 2 if 4 == NUM_PORT else 1 ))
        stringer+="""
    );
    
    bram_ZYNQ_mux_{0} : entity bram_ZYNQ_mux
    generic map(ADDR_WIDTH => ADDR_WIDTH)
    port map(bram_addr_0 => bram_ZYNQ_block_{0}_addr,
          bram_din_0 => bram_ZYNQ_block_{0}_din,
          bram_en_0 => bram_ZYNQ_block_{0}_en,
          bram_we_0 => bram_ZYNQ_block_{0}_we,
          bram_addr_1 => block_{0}_porta_addr,
          bram_din_1 => block_{0}_porta_din,
          bram_en_1 => block_{0}_porta_en,
          bram_we_1 => block_{0}_porta_we,
          bram_addr_out => bram_mux_out_block_{0}_addr,
          bram_din_out => bram_mux_out_block_{0}_din,
          bram_en_out => bram_mux_out_block_{0}_en,
          bram_we_out => bram_mux_out_block_{0}_we,
          sel => bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder_{0} :entity bram_ZYNQ_decoder
    generic map (width => 32)
    port map(decoder_in => bram_decoder_in_block_{0},
          decoder_out_0 => bram_ZYNQ_block_{0}_dout,
          decoder_out_1 => block_{0}_porta_dout,
          sel => bram_ZYNQ_sel
          );
    
    """
    for id0 in range(65, 65 + NUM_BRAM):
            vhdFile.write(stringer.format(chr(id0), 2 if 4 == NUM_PORT else 1 ))

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    MAC_{0} : design_MAC_wrapper
    port map(
        M_AXIS_RESULT_tdata => mac_{0}_result_tdata,
        M_AXIS_RESULT_tready => mac_{0}_result_tready,
        M_AXIS_RESULT_tvalid => mac_{0}_result_tvalid,
        S_AXIS_A_tdata => mac_{0}_a_tdata,
        S_AXIS_A_tready => mac_{0}_a_tready,
        S_AXIS_A_tvalid => mac_{0}_a_tvalid,
        S_AXIS_B_tdata => mac_{0}_b_tdata,
        S_AXIS_B_tready => mac_{0}_b_tready,
        S_AXIS_B_tvalid => mac_{0}_b_tvalid,
        S_AXIS_C_tdata => mac_{0}_c_tdata,
        S_AXIS_C_tready => mac_{0}_c_tready,
        S_AXIS_C_tvalid => mac_{0}_c_tvalid,
        S_AXIS_OPERATION_tdata => mac_{0}_operation_tdata,
        S_AXIS_OPERATION_tready => mac_{0}_operation_tready,
        S_AXIS_OPERATION_tvalid => mac_{0}_operation_tvalid,
        aclk   => CLK_100
    );        
        """
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    DIV_{0} : design_DIV_wrapper
    port map(
        M_AXIS_RESULT_tdata => div_{0}_result_tdata,
        M_AXIS_RESULT_tready => div_{0}_result_tready,
        M_AXIS_RESULT_tvalid => div_{0}_result_tvalid,
        S_AXIS_A_tdata => div_{0}_a_tdata,
        S_AXIS_A_tready => div_{0}_a_tready,
        S_AXIS_A_tvalid => div_{0}_a_tvalid,
        S_AXIS_B_tdata => div_{0}_b_tdata,
        S_AXIS_B_tready => div_{0}_b_tready,
        S_AXIS_B_tvalid => div_{0}_b_tvalid,
        aclk   => CLK_100
    );  
        """
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
-- input locations
    
    """)
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    inputLocations({0}) <= mac_{1}_result_tdata;"""
        vhdFile.write(stringer.format(id0-65,chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    inputLocations({0}) <= div_{1}_result_tdata;"""
        vhdFile.write(stringer.format(id0-65+NUM_MAC_DIV_S,chr(id0)))

    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            if NUM_PORT==4:
                stringer="""
    inputLocations({0}) <= bram_{1}_port{2}_dout;"""
            else :
                stringer="""
    inputLocations({0}) <= block_{1}_port{2}_dout;"""
            vhdFile.write(stringer.format((id0-65)*NUM_PORT+(id1-97)+NUM_MAC_DIV_S*2,chr(id0),chr(id1)))
    stringer="""
    inputLocations({0}) <= (others => '0');     
    """
    vhdFile.write(stringer.format(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT))

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
       
    MUX_MAC_IN_{0}_b : entity MUX_AU_IN
    port map(
        SEL => mac_{0}_b_sel,
        DIN => inputLocations,
        DOUT => mac_{0}_b_tdata
    );

    MUX_MAC_IN_{0}_c : entity MUX_AU_IN
    port map(
        SEL => mac_{0}_c_sel,
        DIN => inputLocations,
        DOUT => mac_{0}_c_tdata
    );

    MUX_MAC_IN_{0}_a : entity MUX_AU_IN
    port map(
        SEL => mac_{0}_a_sel,
        DIN => inputLocations,
        DOUT => mac_{0}_a_tdataIN
    );

    mac_{0}_a_signInv <= not mac_{0}_a_tdataIN(31);
    mac_{0}_a_tdata <= mac_{0}_a_signInv & mac_{0}_a_tdataIN(30 downto 0);

    """
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""

    MUX_DIV_IN_{0}_a : entity MUX_AU_IN
    port map(
        SEL => div_{0}_a_sel,
        DIN => inputLocations,
        DOUT => div_{0}_a_tdata
    );

    MUX_DIV_IN_{0}_b : entity MUX_AU_IN
    port map(
        SEL => div_{0}_b_sel,
        DIN => inputLocations,
        DOUT => div_{0}_b_tdata
    );
"""     
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_BRAM):
        if NUM_PORT==4:
            stringer="""
    MUX_BRAM_{0}_a_in : entity MUX_BRAM_IN
    port map(
        SEL => bram_{0}_a_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => bram_{0}_porta_din
    );
    MUX_BRAM_{0}_b_in : entity MUX_BRAM_IN
    port map(
        SEL => bram_{0}_b_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => bram_{0}_portb_din
    );
    MUX_BRAM_{0}_c_in : entity MUX_BRAM_IN
    port map(
        SEL => bram_{0}_c_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => bram_{0}_portc_din
    );
    MUX_BRAM_{0}_d_in : entity MUX_BRAM_IN
    port map(
        SEL => bram_{0}_d_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => bram_{0}_portd_din
    );


    """
        else :
            stringer="""
    MUX_BRAM_{0}_a_in : entity MUX_BRAM_IN
    port map(
        SEL => block_{0}_a_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => block_{0}_porta_din
    );
    """
        if NUM_PORT==2:
            stringer +="""

    MUX_BRAM_{0}_b_in : entity MUX_BRAM_IN
    port map(
        SEL => block_{0}_b_sel,
        DIN => inputLocations({1} downto 0),
        DOUT => block_{0}_portb_din

    );
        
        """
        vhdFile.write(stringer.format(chr(id0),NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT-1))
    if NUM_PORT==4:
        stringer="""
    bram_{0}_port{1}_addr <= CTRL_Signal(CTRL_WIDTH-{2}*ADDR_WIDTH-{3} downto CTRL_WIDTH-{3}*ADDR_WIDTH-{2});
    bram_{0}_port{1}_we <= CTRL_Signal(CTRL_WIDTH-{3}*ADDR_WIDTH-{3});"""
    else :
        stringer="""
    block_{0}_port{1}_addr <= CTRL_Signal(CTRL_WIDTH-{2}*ADDR_WIDTH-{3} downto CTRL_WIDTH-{3}*ADDR_WIDTH-{2});
    block_{0}_port{1}_we <= CTRL_Signal(CTRL_WIDTH-{3}*ADDR_WIDTH-{3});"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*NUM_PORT+id1-97,(id0-65)*NUM_PORT+id1-97+1))      


    stringer="""
    mac_{0}_{1}_sel <= CTRL_Signal(CTRL_WIDTH-{4}*ADDR_WIDTH-{2}*AU_SEL_WIDTH-{5} downto CTRL_WIDTH-{4}*ADDR_WIDTH-{3}*AU_SEL_WIDTH-{4});"""
    
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        for id1 in range(97, 97 + 3):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*3+id1-97,(id0-65)*3+id1-97+1,NUM_BRAM*NUM_PORT,NUM_PORT*NUM_BRAM+1))   

    stringer="""
    div_{0}_{1}_sel <= CTRL_Signal(CTRL_WIDTH-{4}*ADDR_WIDTH-{2}*AU_SEL_WIDTH-{5} downto CTRL_WIDTH-{4}*ADDR_WIDTH-{3}*AU_SEL_WIDTH-{4});"""

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        for id1 in range(97, 97 + 2):
            vhdFile.write(stringer.format(chr(id0),chr(id1),NUM_MAC_DIV_S*3+(id0-65)*2+id1-97,NUM_MAC_DIV_S*3+(id0-65)*2+id1-97+1,NUM_BRAM*NUM_PORT,NUM_BRAM*NUM_PORT+1))      

    stringer="""
    block_{0}_{1}_sel <= CTRL_Signal(CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{2}*BRAM_SEL_WIDTH-{5} downto CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{3}*BRAM_SEL_WIDTH-{4});"""
    if NUM_PORT == 4:
        stringer="""
    bram_{0}_{1}_sel <= CTRL_Signal(CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{2}*BRAM_SEL_WIDTH-{5} downto CTRL_WIDTH-{4}*ADDR_WIDTH-{6}*AU_SEL_WIDTH-{3}*BRAM_SEL_WIDTH-{4});"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1),(id0-65)*NUM_PORT+id1-97,(id0-65)*NUM_PORT+id1-97+1,NUM_PORT*NUM_BRAM,NUM_BRAM*NUM_PORT+1,NUM_MAC_DIV_S*5))
    vhdFile.write("""

    --  CTRL_Signal(0) is actually a complete signal which is required by this module during debugging

    """)
    if NUM_PORT==4:
        stringer="""
    bram_{0}_port{1}_en <= locked;"""
    else :
        stringer="""
    block_{0}_port{1}_en <= locked;"""
    for id0 in range(65, 65 + NUM_BRAM):
        for id1 in range(97, 97 + NUM_PORT):
            vhdFile.write(stringer.format(chr(id0),chr(id1)))
    vhdFile.write("""
    
    RST <= not locked;

    """)
    stringer="""

    mac_{0}_a_tvalid <= locked;
    mac_{0}_b_tvalid <= locked;
    mac_{0}_c_tvalid <= locked;
    mac_{0}_operation_tvalid <= locked;
    mac_{0}_operation_tdata <= "00000000"; --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    mac_{0}_result_tready <= locked;

    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))
    stringer="""

    div_{0}_a_tvalid <= locked;
    div_{0}_b_tvalid <= locked;
    div_{0}_result_tready <= locked;

    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
    
end architecture;""")
    vhdFile.close()

def hardwareTesterWrapper_vhdl():
	vhdFile  = open("./autoFiles/HDFile/HardwareTesterWrapper.vhd", 'w')
	stringer="""library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.types.all;

entity LUDH_TEST_WRAPPER is
    generic(
        ADDR_WIDTH : integer := {0}; --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM : integer := {1};
        CTRL_WIDTH : integer := {2};
        AU_SEL_WIDTH : integer := {3};
        BRAM_SEL_WIDTH : integer := {4}
    );
    port(
        CLK_100 : in std_logic;
    """
	vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH))
	if NUM_PORT==4:
		vhdFile.write("""CLK_200 : in std_logic;""")
	vhdFile.write("""
        locked : in std_logic_vector(0 downto 0);
        RST_IN : in std_logic_vector(0 downto 0);
        START : in std_logic_vector(0 downto 0);
        COMPLETED : out std_logic_vector(0 downto 0);""")
	stringer="""

		bram_ZYNQ_block_{0}_addr : in std_logic_vector(ADDR_WIDTH_DATA_BRAM - 1 downto 0);
        bram_ZYNQ_block_{0}_din : in std_logic_vector(31 downto 0);
        bram_ZYNQ_block_{0}_dout : out std_logic_vector(31 downto 0);
        bram_ZYNQ_block_{0}_en : in std_logic;
        bram_ZYNQ_block_{0}_we : in std_logic_vector(3 downto 0);
    """
	for idx in range(65, 65 + NUM_BRAM):
		vhdFile.write(stringer.format(chr(idx)))
	vhdFile.write("""
        bram_ZYNQ_INST_addr : in std_logic_vector(31 downto 0);
        bram_ZYNQ_INST_en : in STD_LOGIC_VECTOR ( 0 to 0 );
        bram_ZYNQ_INST_we : in STD_LOGIC_VECTOR ( 0 to 0 );
    """)
	stringer="""
    	bram_ZYNQ_INST_din_part_{0} : in std_logic_vector(31 downto 0);"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)):
	    vhdFile.write(stringer.format(idx))
	stringer="""
    	bram_ZYNQ_INST_dout_part_{0} : out std_logic_vector(31 downto 0);"""
	vhdFile.write("""
    	""")
	for idx in range(math.ceil(CTRL_WIDTH/32.0)):
	    vhdFile.write(stringer.format(idx))
	vhdFile.write("""

		--debug signals
        debug_state : out std_logic_vector(1 downto 0)
    );
end entity;

architecture justConnect of LUDH_TEST_WRAPPER is

    signal ctrl_signal : std_logic_vector(CTRL_WIDTH-1 downto 0); 
    
    --Instruction memory
    """)
	stringer="""
    signal bram_ZYNQ_INST_din : std_logic_vector({0} downto 0); 
    signal bram_ZYNQ_INST_dout : std_logic_vector({0} downto 0);

begin
        bram_ZYNQ_INST_din <= 
"""
	vhdFile.write(stringer.format(32*(math.ceil(CTRL_WIDTH/32.0))-1))
	stringer="""bram_ZYNQ_INST_din_part_{0}"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)-1,-1,-1):
	    vhdFile.write(stringer.format(idx))
	    if idx != 0:
	        vhdFile.write(""" & """)
	vhdFile.write(""";
	""")
	stringer="""
    bram_ZYNQ_INST_dout_part_{0} <= bram_ZYNQ_INST_dout({1} downto {2});"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)-1):
	    vhdFile.write(stringer.format(idx,(idx+1)*32-1,idx*32))
	stringer="""
	bram_ZYNQ_INST_dout_part_{0} <= "{2}" & bram_ZYNQ_INST_dout(CTRL_WIDTH-1 downto {1});
	"""
	vhdFile.write(stringer.format((idx+1),(idx+1)*32,((str(0))) *(32*math.ceil(CTRL_WIDTH/32.0)- CTRL_WIDTH)))

	vhdFile.write("""    
    tester : entity LUDH_Tester
    generic map(ADDR_WIDTH, CTRL_WIDTH)
    port map(
        CLK_100 => CLK_100,
        locked => locked(0),
        RST => RST_IN(0),
        CTRL_Signal => ctrl_signal,
        COMPLETED => COMPLETED(0),
        START => START(0),
        
        bram_ZYNQ_INST_addr => bram_ZYNQ_INST_addr(ADDR_WIDTH - 1 downto 0),
        bram_ZYNQ_INST_din => bram_ZYNQ_INST_din(CTRL_WIDTH - 1 downto 0),
        bram_ZYNQ_INST_dout => bram_ZYNQ_INST_dout(CTRL_WIDTH - 1 downto 0),
        bram_ZYNQ_INST_en => bram_ZYNQ_INST_en(0),
        bram_ZYNQ_INST_we => bram_ZYNQ_INST_we,
        
        --debug signals
        debug_state => debug_state
    );

    LUDH : entity LUDHardware
    generic map(ADDR_WIDTH_DATA_BRAM, CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH)
    port map(
        CLK_100 => CLK_100,""")
	if NUM_PORT==4:
	    vhdFile.write("""CLK_200 => CLK_200,
	    """)
	vhdFile.write("""
		locked => locked(0),
        CTRL_Signal => ctrl_signal,
        
    """)
	stringer="""
		bram_ZYNQ_block_{0}_addr => bram_ZYNQ_block_{0}_addr(ADDR_WIDTH_DATA_BRAM - 1 downto 0),
        bram_ZYNQ_block_{0}_din => bram_ZYNQ_block_{0}_din,
        bram_ZYNQ_block_{0}_dout => bram_ZYNQ_block_{0}_dout,
        bram_ZYNQ_block_{0}_en => bram_ZYNQ_block_{0}_en,
        bram_ZYNQ_block_{0}_we => bram_ZYNQ_block_{0}_we(0),
    """
	for idx in range(65, 65 + NUM_BRAM):
	    vhdFile.write(stringer.format(chr(idx)))
	vhdFile.write("""        
        bram_ZYNQ_sel => START(0)
    );

end architecture;
    """)
	vhdFile.close()

def AXI() :
    vhdFile  = open("./autoFiles/HDFile/myip_AXI_LUD.vhd", 'w')
    stringer="""
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity myip_AXI_LUD is
    generic (
        -- Users to add parameters here
        ADDR_WIDTH : integer := {0}; --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM : integer := {1};
        CTRL_WIDTH : integer := {2};
        AU_SEL_WIDTH : integer := {3};
        BRAM_SEL_WIDTH : integer := {4};
        -- User parameters ends
        -- Do not modify the parameters beyond this line


        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH    : integer   := 32;
        C_S_AXI_ADDR_WIDTH    : integer   := 9
    );
    port (
        -- Users to add ports here
        clk_1x : in std_logic;
        """
    vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,math.ceil(math.log2(4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0))+1)))
    if NUM_PORT==4:
        vhdFile.write("""clk_2x : in std_logic;
""")
    vhdFile.write("""
        -- User ports ends
        -- Do not modify the ports beyond this line

        -- Global Clock Signal
        S_AXI_ACLK  : in std_logic;
        -- Global Reset Signal. This Signal is Active LOW
        S_AXI_ARESETN   : in std_logic;
        -- Write address (issued by master, acceped by Slave)
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Write channel Protection type. This signal indicates the
            -- privilege and security level of the transaction, and whether
            -- the transaction is a data access or an instruction access.
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        -- Write address valid. This signal indicates that the master signaling
            -- valid write address and control information.
        S_AXI_AWVALID   : in std_logic;
        -- Write address ready. This signal indicates that the slave is ready
            -- to accept an address and associated control signals.
        S_AXI_AWREADY   : out std_logic;
        -- Write data (issued by master, acceped by Slave) 
        S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Write strobes. This signal indicates which byte lanes hold
            -- valid data. There is one write strobe bit for each eight
            -- bits of the write data bus.    
        S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        -- Write valid. This signal indicates that valid write
            -- data and strobes are available.
        S_AXI_WVALID    : in std_logic;
        -- Write ready. This signal indicates that the slave
            -- can accept the write data.
        S_AXI_WREADY    : out std_logic;
        -- Write response. This signal indicates the status
            -- of the write transaction.
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        -- Write response valid. This signal indicates that the channel
            -- is signaling a valid write response.
        S_AXI_BVALID    : out std_logic;
        -- Response ready. This signal indicates that the master
            -- can accept a write response.
        S_AXI_BREADY    : in std_logic;
        -- Read address (issued by master, acceped by Slave)
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        -- Protection type. This signal indicates the privilege
            -- and security level of the transaction, and whether the
            -- transaction is a data access or an instruction access.
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        -- Read address valid. This signal indicates that the channel
            -- is signaling valid read address and control information.
        S_AXI_ARVALID   : in std_logic;
        -- Read address ready. This signal indicates that the slave is
            -- ready to accept an address and associated control signals.
        S_AXI_ARREADY   : out std_logic;
        -- Read data (issued by slave)
        S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        -- Read response. This signal indicates the status of the
            -- read transfer.
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        -- Read valid. This signal indicates that the channel is
            -- signaling the required read data.
        S_AXI_RVALID    : out std_logic;
        -- Read ready. This signal indicates that the master can
            -- accept the read data and response information.
        S_AXI_RREADY    : in std_logic
    );
end myip_AXI_LUD;

architecture arch_imp of myip_AXI_LUD is

    -- AXI4LITE signals
    signal axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready  : std_logic;
    signal axi_wready   : std_logic;
    signal axi_bresp    : std_logic_vector(1 downto 0);
    signal axi_bvalid   : std_logic;
    signal axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready  : std_logic;
    signal axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp    : std_logic_vector(1 downto 0);
    signal axi_rvalid   : std_logic;

    -- Example-specific design signals
    -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    -- ADDR_LSB is used for addressing 32/64 bit registers/memories
    -- ADDR_LSB = 2 for 32 bits (n downto 2)
    -- ADDR_LSB = 3 for 64 bits (n downto 3)
    constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant OPT_MEM_ADDR_BITS : integer := 6;
    ------------------------------------------------
    ---- Signals for user logic register space example
    --------------------------------------------------
    ---- Number of Slave Registers 128
""")
    stringer="""
    signal slv_reg{0}	:   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal aw_en	: std_logic;
	
	--output signals    
    """)
    stringer="""
    signal slv_reg{0}_out	:   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);"""
    L=list([3])
    L+=list(range(4+2*NUM_BRAM,4+3*NUM_BRAM))
    L+=list(range(4+5*NUM_BRAM+3+math.ceil(CTRL_WIDTH/32.0),4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0)+1))
    for i in L:
        ##print(i)
        vhdFile.write(stringer.format(i))
    vhdFile.write("""

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	           axi_awready <= '1';
	           aw_en <= '0';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	           aw_en <= '1';
	           axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
    """)
    stringer="""
    slv_reg{0} <= (others => '0');"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is""")
    stringer="""
	          when b"{0}" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor {1}
	                slv_reg{1}(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;"""
    for i in range(128):
        vhdFile.write(stringer.format(format(i,'b').zfill(math.ceil(math.log2(128))),i))
    vhdFile.write("""
		when others =>""")
    stringer="""
    	            slv_reg{0} <= slv_reg{0};"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;
    
    process (
    """)
    stringer="""slv_reg{0},"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    stringer="""slv_reg{0}_out,"""
    for i in L:
        vhdFile.write(stringer.format(i))
    vhdFile.write(""" axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);	
    begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
""")
    S0="""
    when b"{0}" =>
	    reg_data_out <= slv_reg{1};"""
    S1="""
    when b"{0}" =>
	    reg_data_out <= slv_reg{1}_out;"""
#format(5,'b').zfill(5)
    for i in range(128):
        if i in L:
            vhdFile.write(S1.format(format(i,'b').zfill(math.ceil(math.log2(128))),i))
        else :
            vhdFile.write(S0.format(format(i,'b').zfill(math.ceil(math.log2(128))),i))
    vhdFile.write("""
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here
	
	-- Add user logic here
    main_entity : entity LUDH_TEST_WRAPPER
    generic map(
        ADDR_WIDTH => ADDR_WIDTH,
        ADDR_WIDTH_DATA_BRAM => ADDR_WIDTH_DATA_BRAM,
        CTRL_WIDTH => CTRL_WIDTH)
    port map(
            CLK_100 => clk_1x,""")
    if NUM_PORT==4:
        vhdFile.write("""
        CLK_200 => clk_2x,
        """)
    vhdFile.write("""
            locked => slv_reg0(0 downto 0),
            RST_IN => slv_reg1(0 downto 0),
            START => slv_reg2(0 downto 0),
            COMPLETED => slv_reg3_out(0 downto 0),  --output
    """)
    stringer="""
            bram_ZYNQ_block_{5}_addr => slv_reg{0}(ADDR_WIDTH_DATA_BRAM - 1 downto 0),
            bram_ZYNQ_block_{5}_din => slv_reg{1}(31 downto 0),
            bram_ZYNQ_block_{5}_dout => slv_reg{2}_out(31 downto 0), --output
            bram_ZYNQ_block_{5}_en => slv_reg{3}(0),
            bram_ZYNQ_block_{5}_we => slv_reg{4}(3 downto 0),
            """
    for i in range(NUM_BRAM):
        vhdFile.write(stringer.format(i+4,i+4+NUM_BRAM,i+4+2*NUM_BRAM,i+4+3*NUM_BRAM,i+4+4*NUM_BRAM,chr(i+65)))
    vhdFile.write("""
            
            
            bram_ZYNQ_INST_addr => slv_reg44(31 downto 0),
            bram_ZYNQ_INST_en => slv_reg45(0 downto 0),
            bram_ZYNQ_INST_we => slv_reg46(0 downto 0),
            
    """)
    stringer="""
            bram_ZYNQ_INST_din_part_{0} => slv_reg{1}(31 downto 0),"""
    for i in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(i,i+4+NUM_BRAM*5+3))
    vhdFile.write("""
    """)
    stringer="""
            bram_ZYNQ_INST_dout_part_{0} => slv_reg{1}_out(31 downto 0),"""
    for i in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(i,i+4+NUM_BRAM*5+3+math.ceil(CTRL_WIDTH/32.0)))
    vhdFile.write("""
            
            --debug signals""")
    stringer="""
    debug_state => slv_reg{0}_out(1 downto 0) --output"""
    vhdFile.write(stringer.format(4+NUM_BRAM*5+3+2*math.ceil(CTRL_WIDTH/32.0)))
    vhdFile.write("""
        );

	-- User logic ends

end arch_imp;    
    """)
    vhdFile.close()
    vhdFile  = open("./autoFiles/HDFile/myip_AXI_LUD_wrapper.vhd", 'w')
    stringer="""
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myip_AXI_LUD_wrapper is
    generic (
        -- Users to add parameters here
        ADDR_WIDTH : integer := {0}; --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM : integer := {1};
        CTRL_WIDTH : integer := {2};
        AU_SEL_WIDTH : integer := {3};
        BRAM_SEL_WIDTH : integer := {4};
        -- User parameters ends
        -- Do not modify the parameters beyond this line


        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH    : integer   := 32;
        C_S_AXI_ADDR_WIDTH    : integer   := 9
    );
    port (
        -- Users to add ports here
        clk_1x : in std_logic;
        """
    vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,math.ceil(math.log2(4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0))+1)))
    if NUM_PORT==4:
        vhdFile.write("""clk_2x : in std_logic;
""")
    vhdFile.write("""
        -- User ports ends
        -- Do not modify the ports beyond this line

        -- Global Clock Signal
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
    );
end myip_AXI_LUD_wrapper;

architecture arch_imp of myip_AXI_LUD_wrapper is
	-- component declaration
	component myip_AXI_LUD is
		generic (
	    --User Defined""")
    stringer="""
        ADDR_WIDTH : integer := {0}; --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM : integer := {1};
        CTRL_WIDTH : integer := {2};
        AU_SEL_WIDTH : integer := {3};
        BRAM_SEL_WIDTH : integer := {4};
        -- User parameters ends
        -- Do not modify the parameters beyond this line

        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH    : integer   := 32;
        C_S_AXI_ADDR_WIDTH    : integer   := 9
    );
    port (
        -- Users to add ports here
        clk_1x : in std_logic;
        """
    vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,math.ceil(math.log2(4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0))+1)))
    if NUM_PORT==4:
        vhdFile.write("""clk_2x : in std_logic;
""")
    vhdFile.write("""
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component myip_AXI_LUD;

begin

-- Instantiation of Axi Bus Interface S00_AXI
myip_LUdecomposition_v2_v1_0_S00_AXI_inst : myip_AXI_LUD
	generic map (
		--User Defined
        ADDR_WIDTH => ADDR_WIDTH, --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM => ADDR_WIDTH_DATA_BRAM,
        CTRL_WIDTH => CTRL_WIDTH,
        AU_SEL_WIDTH => AU_SEL_WIDTH,
        BRAM_SEL_WIDTH => BRAM_SEL_WIDTH,
        
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
		--user defined
	    clk_1x => clk_1x,
""")
    if NUM_PORT==4:
        vhdFile.write("""clk_2x => clk_2x,
""")
    vhdFile.write("""
	            
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
	""")
def SV():
    vhdFile  = open("./autoFiles/SVFile/simTester_verilog.sv", 'w')
    vhdFile.write("""
    `timescale 1ns / 1ps
module simTester_verilog();""")
    if NUM_PORT==4:
        vhdFile.write("""
reg CLK_100, CLK_200, locked, RST_IN,start_sig;
        """)
    else :
        vhdFile.write("""
reg CLK_100, locked, RST_IN,start_sig;
        """)
    vhdFile.write("""
wire  completed;
localparam time t_100 = 40;""")
    if NUM_PORT==4:
        vhdFile.write("""
localparam time t_200 = 20;
""")
    stringer="""
localparam integer ADDR_WIDTH = {0};
localparam integer INST_BRAM_SIZE = {1};//(2**ADDR_WIDTH)
localparam integer ADDR_WIDTH_DATA_BRAM = {2};
localparam integer DATA_BRAM_SIZE = {3};//(2**ADDR_WIDTH_DATA_BRAM)
localparam integer CTRL_WIDTH = {4};
localparam integer AU_SEL_WIDTH = {5};
localparam integer BRAM_SEL_WIDTH = {6};

`include "systemVerilog_A_INST.svh"

localparam integer BRAM_LIMIT_IND_DEBUG = {7}; //It indicates that BRAM contents from location 0 to BRAM_LIMIT_IND_DEBUG will be dumped for all 4 BRAMS for every cycle

//Constant array to load the A matrix

"""
    vhdFile.write(stringer.format(ADDR_WIDTH,2**ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,2**ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,NUM_BRAM));
    stringer="""
    //For {0} BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_{1}_addr;
reg [31:0]bram_ZYNQ_block_{1}_din;
wire [31:0]bram_ZYNQ_block_{1}_dout;
wire bram_ZYNQ_block_{1}_en;
wire [3:0]bram_ZYNQ_block_{1}_we;
    """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(idx,chr(idx+65)))
    vhdFile.write("""

//Instruction BRAM
wire [31:0]bram_ZYNQ_INST_addr;
wire bram_ZYNQ_INST_en;
wire bram_ZYNQ_INST_we;
""")
    stringer="""  
wire [31:0]bram_ZYNQ_INST_din_part_{0};"""
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))
    stringer="""
wire [31:0]bram_ZYNQ_INST_dout_part_{0};"""
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))
    stringer="""
//debug signals
wire [1:0]debug_state;

reg [31:0]BRAM_dump[0:{1}][0:{0}];
reg [31:0]fptr,fptr2;
integer count;
reg complete_bit;

//MUX signal
reg [1:0]sel_mux_dataBRAM;

""" 
    vhdFile.write(stringer.format((2**ADDR_WIDTH_DATA_BRAM)-1,NUM_BRAM-1))
    stringer="""
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_{0}_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_{0}_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_{0}_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_{0}_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_{0}_dout;
"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
//Mux signals for enable
""")
    stringer="""
reg mux_dataBRAM_{0}_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_{0}_en1 = 0; //For clearing
reg mux_dataBRAM_{0}_en2 = 0; //For loading A matrix
reg mux_dataBRAM_{0}_en3 = 0; //Currently unused
wire mux_dataBRAM_{0}_endout;
"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
//Mux signals for write enable
""")
    stringer="""
reg mux_dataBRAM_{0}_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_{0}_we1 = 0; //For clearing
reg mux_dataBRAM_{0}_we2 = 0; //For loading A matrix
reg mux_dataBRAM_{0}_we3 = 0; //Currently unused
wire mux_dataBRAM_{0}_wedout;
"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
//Mux signals for din
reg sel_mux_dataBRAM_din;
""")
    stringer="""
reg [31:0]mux_dataBRAM_{0}_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_{0}_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_{0}_din_out;
"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
//Instruction BRAM muxes
""")
    stringer="""
reg [31:0]instBRAM_part{0}_din;"""
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))
    vhdFile.write("""
reg instBRAM_en = 0;
reg instBRAM_we = 0;
reg [ADDR_WIDTH-1:0]instBRAM_addr;


//Memory dump start and complete signals
reg start_mem_dump;
reg mem_dump_complete;
reg start_dataBRAM_erase;
reg dataBRAM_erase_complete;
reg start_A_load;
reg A_load_complete;
reg start_instBRAM_erase;
reg instBRAM_erase_complete;
reg start_inst_load;
reg inst_load_complete;
reg start_full_run;
reg complete_full_run;
reg start0; //For full run
reg complete_sig;

LUDH_TEST_WRAPPER #(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH) uut (
CLK_100,
""")
    if NUM_PORT==4:
        vhdFile.write("""CLK_200,
        """)
    vhdFile.write("""locked,
RST_IN,
start_sig,
completed,

""")
    stringer="""//{0} BRAM
bram_ZYNQ_block_{1}_addr, 
bram_ZYNQ_block_{1}_din, 
bram_ZYNQ_block_{1}_dout, 
bram_ZYNQ_block_{1}_en,
bram_ZYNQ_block_{1}_we,

"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(idx,chr(idx+65)))
    vhdFile.write("""//Instruction BRAM
bram_ZYNQ_INST_addr,
bram_ZYNQ_INST_en,
bram_ZYNQ_INST_we,
""")
    stringer="""bram_ZYNQ_INST_din_part_{0},
    """
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))
    stringer="""bram_ZYNQ_INST_dout_part_{0},
    """
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))

    vhdFile.write("""//debug signals
debug_state
);

initial begin
CLK_100 = 1'b1;
forever #(t_100/2) CLK_100 = ~CLK_100;
end
""")
    if NUM_PORT==4:
        vhdFile.write("""
initial begin
CLK_200 = 1'b1;
forever #(t_200/2) CLK_200 = ~CLK_200;
end
""")
    vhdFile.write("""//Initiallizing the mux to be used for DATA BRAMS address multiplexing
//For address""")
    stringer="""
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut{1}(mux_dataBRAM_{0}_dout,mux_dataBRAM_{0}_0,mux_dataBRAM_{0}_1,mux_dataBRAM_{0}_2,mux_dataBRAM_{0}_3,sel_mux_dataBRAM);"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65),idx))
    vhdFile.write("""
//For enable""")
    stringer="""
    mux_4x1 #(1) uut{1}(mux_dataBRAM_{0}_endout,mux_dataBRAM_{0}_en0,mux_dataBRAM_{0}_en1,mux_dataBRAM_{0}_en2,mux_dataBRAM_{0}_en3,sel_mux_dataBRAM);"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65),idx+NUM_BRAM))
    vhdFile.write("""
//For Write enable""")
    stringer="""
    mux_4x1 #(1) uut{1}(mux_dataBRAM_{0}_wedout,mux_dataBRAM_{0}_we0,mux_dataBRAM_{0}_we1,mux_dataBRAM_{0}_we2,mux_dataBRAM_{0}_we3,sel_mux_dataBRAM);"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65),idx+NUM_BRAM*2))
    vhdFile.write("""
//For din""")
    stringer="""
    mux_2x1 #(32) uut{1}(mux_dataBRAM_{0}_din_out,mux_dataBRAM_{0}_din0,mux_dataBRAM_{0}_din1,sel_mux_dataBRAM_din);"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65),idx+NUM_BRAM*3))
    vhdFile.write("""

initial begin
start_mem_dump <= 0;
mem_dump_complete <= 0;
start_dataBRAM_erase <= 0;
dataBRAM_erase_complete <= 0;
start_A_load <= 0;
A_load_complete <= 0;
start_instBRAM_erase <= 0;
instBRAM_erase_complete <= 0;
start_inst_load <= 0;
inst_load_complete <= 0;
complete_full_run <= 0;
sel_mux_dataBRAM <= 2'b00;
sel_mux_dataBRAM_din <= 1'b0;

count <= -1;
complete_bit <= 1'b0;
locked <= 1'b0;

#(t_100*50)
start_full_run <= 1'b0;

#(t_100*50)
RST_IN <= 1'b1;

//Resetting the contents of data BRAMS and Inst BRAM
#(t_100*50)
sel_mux_dataBRAM <= 2'b01;
sel_mux_dataBRAM_din <= 1'b0;
start_dataBRAM_erase <= 1'b1;

@(posedge dataBRAM_erase_complete)
#(t_100*50)
start_dataBRAM_erase <= 0;

#(t_100*50)
start_instBRAM_erase <= 1'b1;

@(posedge instBRAM_erase_complete)
#(t_100*50)
start_instBRAM_erase <= 0;

//Loading the A matrix
#(t_100*50)
sel_mux_dataBRAM <= 2'b10;
sel_mux_dataBRAM_din <= 1'b1;
start_A_load <= 1'b1;

@(posedge A_load_complete)
#(t_100*50)
start_A_load <= 0;

//RST = 0
#(t_100*50)
RST_IN <= 1'b0;

//Locked = 1
#(t_100*50)
locked <= 1'b1;

//Loading the instruction matrix and starting LU Decomposition
#(t_100*50)
start_full_run = 1'b1;

@(posedge complete_sig)
complete_bit <= 1'b1;
#(t_100*50)
start_full_run <= 1'b0;

#(t_100*50)
sel_mux_dataBRAM <= 2'b00;
start_mem_dump <= 1;

@(posedge mem_dump_complete)
#(t_100*50)
start_mem_dump <= 0;
$stop;

end

assign start_sig = start0;
assign complete_sig = complete_full_run;

//Address signals(data BRAM)
""")
    stringer="""
assign bram_ZYNQ_block_{0}_addr = mux_dataBRAM_{0}_dout;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""  
//Enable signals(data BRAM)
""")
    stringer="""
assign bram_ZYNQ_block_{0}_en = mux_dataBRAM_{0}_endout;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""  
//Write enable signals(data BRAM)
""")
    stringer="""
assign bram_ZYNQ_block_{0}_we = mux_dataBRAM_{0}_wedout;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""  
//din signals(data BRAM)
""")
    stringer="""
assign bram_ZYNQ_block_{0}_din = mux_dataBRAM_{0}_din_out;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
//Address signal(inst BRAM)
assign bram_ZYNQ_INST_addr = instBRAM_addr;

//Enable signal(inst BRAM)
assign bram_ZYNQ_INST_en = instBRAM_en;

//Write enable signal(inst BRAM)
assign bram_ZYNQ_INST_we = instBRAM_we;

//din signal(inst BRAM)
""")

    stringer="""
assign bram_ZYNQ_INST_din_part_{0} = instBRAM_part{0}_din;"""
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))
    vhdFile.write("""

//Always block for full run
always@(posedge CLK_100) begin
if(CLK_100  == 1 && start_full_run == 1 && complete_full_run != 1) begin
//Start loading complete instructions
start_inst_load <= 1'b1;
@(posedge inst_load_complete)
#(t_100*50)
start_inst_load <= 0;

//Start the LU Decomposition
#(t_100*50)
start0 <= 1'b1;
complete_full_run <= 1'b0;

//Waiting for completion
@(posedge completed)
complete_full_run <= 1'b1;

end
else if(CLK_100 == 1 && start_full_run == 0) begin
start0 <= 0;
complete_full_run <= 0;
end
end

//Always block to dump bram contents    
    """)
    if NUM_PORT==4:
        vhdFile.write("""
always@(posedge CLK_200) begin
if(CLK_200 == 1 && start_mem_dump == 1 && mem_dump_complete != 1)begin 
        """)
    else :
        vhdFile.write("""
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_mem_dump == 1 && mem_dump_complete != 1)begin 
""")
    vhdFile.write("""
    if(count == -1) begin
        fptr = $fopen("BRAM_dump.h","w");
        $fdisplay(fptr,"float bram_dump[%d][%d];",BRAM_LIMIT_IND_DEBUG,DATA_BRAM_SIZE);
        count = count + 1;
        """)

    stringer="""mux_dataBRAM_{0}_en0 = 1'b1;
    """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    stringer="""mux_dataBRAM_{0}_we0 = 1'b0;
    """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))        
    vhdFile.write("""
    // Adddress
    """)
    stringer="""mux_dataBRAM_{0}_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
    end
    else if(count == 0) begin
        count = count + 1;    
    """)
    vhdFile.write("""
    // Adddress
    """)
    stringer="""mux_dataBRAM_{0}_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""    end
    else if(count <= DATA_BRAM_SIZE && count >= 1)begin
""")
    stringer="""
            $fdisplay(fptr,"bram_dump[{0}][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_{1}_dout)); //count-1 because BRAM has single cycle latency"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(idx,chr(idx+65)))
    vhdFile.write("""
            count = count + 1;""")
    stringer="""
            mux_dataBRAM_{0}_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
    end
    else if (count == DATA_BRAM_SIZE+1) begin
        $fclose(fptr);
        count = -1;
        mem_dump_complete = 1;    
""") 

    stringer="""
    mux_dataBRAM_{0}_en0 = 1'b0;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
    end
end
""")
    if NUM_PORT==4:
        vhdFile.write("""else if(CLK_200 == 1 && start_mem_dump == 0)
    mem_dump_complete = 0;
end


//Always block to erase data BRAM contents
always@(posedge CLK_200) begin
if(CLK_200 == 1 && start_dataBRAM_erase == 1 && dataBRAM_erase_complete != 1)begin 
""")
    else :
        vhdFile.write("""else if(CLK_100 == 1 && start_mem_dump == 0)
    mem_dump_complete = 0;
end


//Always block to erase data BRAM contents
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_dataBRAM_erase == 1 && dataBRAM_erase_complete != 1)begin 
""")
    vhdFile.write("""
    if(count <= DATA_BRAM_SIZE-2 && count >= -1)begin
        if(count == -1) begin
""")
    stringer="""
    mux_dataBRAM_{0}_en1 = 1'b1;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    stringer="""
    mux_dataBRAM_{0}_we1 = 1'b1;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    stringer="""
    mux_dataBRAM_{0}_din0 = 0; """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
    end
        count = count + 1;""")
    stringer="""
    mux_dataBRAM_{0}_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))        
    vhdFile.write("""
    end
    else if (count == DATA_BRAM_SIZE-1) begin
        count = -1;
        dataBRAM_erase_complete = 1;   
""")
    stringer="""
    mux_dataBRAM_{0}_en1 = 1'b0;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    stringer="""
    mux_dataBRAM_{0}_we1 = 1'b0; """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))        
    vhdFile.write("""
        end
end""")
    if NUM_PORT==4:
        vhdFile.write("""
else if(CLK_200 == 1 && start_dataBRAM_erase == 0)
    dataBRAM_erase_complete = 0;
end

//Always block to load the A matrix in data bram
always@(posedge CLK_200) begin
if(CLK_200 == 1 && start_A_load == 1 && A_load_complete != 1)begin 

    if(count <= A_size-2 && count >= -1)begin
        if(count == -1) //Initialization of en signals
        """)
    else :
        vhdFile.write("""
else if(CLK_100 == 1 && start_dataBRAM_erase == 0)
    dataBRAM_erase_complete = 0;
end

//Always block to load the A matrix in data bram
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_A_load == 1 && A_load_complete != 1)begin 

    if(count <= A_size-2 && count >= -1)begin
        if(count == -1) //Initialization of en signals
        """)
    stringer="""
    mux_dataBRAM_{0}_en2 = 1'b1;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))       
    stringer="""
    mux_dataBRAM_{0}_we2 = 1'b0;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))       
    vhdFile.write("""
    count = count + 1;
    if(A_BRAMInd[count] == 0) begin//making one of the write enables 1
        mux_dataBRAM_A_we2 = 1'b1; mux_dataBRAM_A_2 = A_BRAMAddr[count]; mux_dataBRAM_A_din1 = A[count];
    end
""")
    stringer="""
        else if(A_BRAMInd[count] == {0}) begin
            mux_dataBRAM_{1}_we2 = 1'b1; mux_dataBRAM_{1}_2 = A_BRAMAddr[count]; mux_dataBRAM_{1}_din1 = A[count];
        end"""
    for idx in range(NUM_BRAM-1):
        vhdFile.write(stringer.format(idx+1,chr(idx+65+1)))
    vhdFile.write("""
end
    else if (count == A_size-1) begin
        count = -1;
        A_load_complete = 1;   
""")
    stringer="""
    mux_dataBRAM_{0}_en2 = 1'b0; """
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))  
    stringer="""
    mux_dataBRAM_{0}_we2 = 1'b0;"""
    for idx in range(NUM_BRAM):
        vhdFile.write(stringer.format(chr(idx+65)))
    vhdFile.write("""
        end
end""")
    if NUM_PORT==4:
        vhdFile.write("""
        else if(CLK_200 == 1 && start_A_load == 0)""")
    else :
        vhdFile.write("""
        else if(CLK_100 == 1 && start_A_load == 0)""")
    vhdFile.write("""
        A_load_complete = 0;
end

//Always block to erase inst BRAM
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_instBRAM_erase == 1 && instBRAM_erase_complete != 1)begin 

    if(count <= INST_BRAM_SIZE-2 && count >= -1)begin
        if(count == -1) begin
            instBRAM_en = 1'b1;
            instBRAM_we = 1'b1;
            """)
    stringer="""
    instBRAM_part{0}_din = 0;"""
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx))    
    vhdFile.write("""
        end
        count = count + 1;
        instBRAM_addr = count[ADDR_WIDTH-1:0];
    end
    else if (count == INST_BRAM_SIZE-1) begin
        count = -1;
        instBRAM_erase_complete = 1;   
        instBRAM_en = 1'b0;
        instBRAM_we = 1'b0;
    end
end
else if(CLK_100 == 1 && start_instBRAM_erase == 0)
    instBRAM_erase_complete = 0;
end

//Always block to load instruction to instruction BRAM
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_inst_load == 1 && inst_load_complete != 1)begin 

    if(count <= total_instructions-2 && count >= -1)begin
        if(count == -1) begin
            instBRAM_en = 1'b1;
            instBRAM_we = 1'b1;
        end
        count = count + 1;
    """)
    stringer="""
    instBRAM_part{0}_din = Inst[count][{0}]; """
    for idx in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(idx)) 
    vhdFile.write("""
        instBRAM_addr = count[ADDR_WIDTH-1:0];
    end
    else if (count == total_instructions-1) begin
        count = -1;
        inst_load_complete = 1;   
        instBRAM_en = 1'b0;
        instBRAM_we = 1'b0;
    end
end
else if(CLK_100 == 1 && start_inst_load == 0)
    inst_load_complete = 0;
end

function real float_conv(input [31:0]b_num);
reg sign;
reg [7:0]weighted_expt;
integer actual_expt;
reg [1:23] mantissa;
reg [7:0] i;
real temp_result,temp_decimal;

begin
sign = b_num >> 31;
weighted_expt = (b_num & 32'h7f800000)>> 23;
mantissa = b_num & 32'h007fffff;

if(weighted_expt == 0)begin
	temp_result = 1.0;
	for(i=0;i<126;i=i+1)
		temp_result = temp_result/2;

	temp_decimal = 0;
	for(i=1;i<=23;i=i+1)
		temp_decimal = temp_decimal + mantissa[i]*(1.0/(1<<i));
		
	temp_result = temp_result*temp_decimal;
	if(sign==1)
		float_conv = -temp_result;
	else
		float_conv = temp_result;
	end
else if(weighted_expt>0 && weighted_expt <255) begin
	actual_expt = weighted_expt-127;
	if(actual_expt<0)begin
		temp_result = 1.0;
		actual_expt = -actual_expt;
		for(i=0;i<actual_expt;i=i+1)
			temp_result = temp_result/2;
		end
	else begin
		temp_result = 1.0;
		for(i=0;i<actual_expt;i=i+1)
			temp_result = temp_result*2;
	end

	temp_decimal = 0;
	for(i=1;i<=23;i=i+1)
		temp_decimal = temp_decimal + mantissa[i]*(1.0/(1<<i));

	temp_decimal = temp_decimal + 1;
	temp_result = temp_result*temp_decimal;
	if(sign == 1)
		float_conv = -temp_result;
	else
		float_conv = temp_result;
end
else if(weighted_expt == 255)begin
/*if(mantissa == 0 and sign == 0)
float_conv = "inf";
else if(mantissa == 0 and sign == 1)
float_conv = "-inf";
else
float_conv = "nan";*/
end

end
endfunction

endmodule

module mux_4x1 #(parameter integer data_width = 11)(dout,din0,din1,din2,din3,sel);
output reg [data_width-1:0]dout;
input [data_width-1:0]din0;
input [data_width-1:0]din1;
input [data_width-1:0]din2;
input [data_width-1:0]din3;
input [1:0]sel;

always@(din0,din1,din2,din3,sel) begin
case(sel)
2'b00: dout <= din0;
2'b01: dout <= din1;
2'b10: dout <= din2;
2'b11: dout <= din3;
endcase
end
endmodule

module mux_2x1 #(parameter integer data_width = 32)(dout,din0,din1,sel);
output reg [data_width-1:0]dout;
input [data_width-1:0]din0;
input [data_width-1:0]din1;
input sel;

always@(din0,din1,sel) begin
case(sel)
1'b0: dout <= din0;
1'b1: dout <= din1;
endcase
end
endmodule

""")
    vhdFile.close()

if __name__ == "__main__":
    os.makedirs("./autoFiles", exist_ok=True)
    os.makedirs("./autoFiles/HDFile", exist_ok=True)
    os.makedirs("./autoFiles/SVFile", exist_ok=True)
    # Opening JSON file
    f = open('IO.json',)
    
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
    make_tcl()
hardwareMUX_vhdl()
hardwareTester_vhdl()
LUDHardware_vhdl()
hardwareTesterWrapper_vhdl()
hardwareMUX_vhdl()
AXI()
SV()
