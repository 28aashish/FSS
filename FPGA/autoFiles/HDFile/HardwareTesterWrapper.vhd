library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.types.all;

entity LUDH_TEST_WRAPPER is
    generic(
        ADDR_WIDTH : integer := 10; --Instruction BRAM
        ADDR_WIDTH_DATA_BRAM : integer := 7;
        CTRL_WIDTH : integer := 60;
        AU_SEL_WIDTH : integer := 3;
        BRAM_SEL_WIDTH : integer := 3
    );
    port(
        CLK_100 : in std_logic;
    
        locked : in std_logic_vector(0 downto 0);
        RST_IN : in std_logic_vector(0 downto 0);
        START : in std_logic_vector(0 downto 0);
        COMPLETED : out std_logic_vector(0 downto 0);

		bram_ZYNQ_block_A_addr : in std_logic_vector(ADDR_WIDTH_DATA_BRAM - 1 downto 0);
        bram_ZYNQ_block_A_din : in std_logic_vector(31 downto 0);
        bram_ZYNQ_block_A_dout : out std_logic_vector(31 downto 0);
        bram_ZYNQ_block_A_en : in std_logic;
        bram_ZYNQ_block_A_we : in std_logic;
    

		bram_ZYNQ_block_B_addr : in std_logic_vector(ADDR_WIDTH_DATA_BRAM - 1 downto 0);
        bram_ZYNQ_block_B_din : in std_logic_vector(31 downto 0);
        bram_ZYNQ_block_B_dout : out std_logic_vector(31 downto 0);
        bram_ZYNQ_block_B_en : in std_logic;
        bram_ZYNQ_block_B_we : in std_logic;
    
        bram_ZYNQ_INST_addr : in std_logic_vector(9 downto 0);
        bram_ZYNQ_INST_en : in STD_LOGIC_VECTOR ( 0 to 0 );
        bram_ZYNQ_INST_we : in STD_LOGIC_VECTOR ( 0 to 0 );
    
    	bram_ZYNQ_INST_din_part_0 : in std_logic_vector(31 downto 0);
    	bram_ZYNQ_INST_din_part_1 : in std_logic_vector(31 downto 0);
    	
    	bram_ZYNQ_INST_dout_part_0 : out std_logic_vector(31 downto 0);
    	bram_ZYNQ_INST_dout_part_1 : out std_logic_vector(31 downto 0);

		--debug signals
        debug_state : out std_logic_vector(1 downto 0)
    );
end entity;

architecture justConnect of LUDH_TEST_WRAPPER is

    signal ctrl_signal : std_logic_vector(CTRL_WIDTH-1 downto 0); 
    
    --Instruction memory
    
    signal bram_ZYNQ_INST_din : std_logic_vector(63 downto 0); 
    signal bram_ZYNQ_INST_dout : std_logic_vector(63 downto 0);

begin
        bram_ZYNQ_INST_din <= 
bram_ZYNQ_INST_din_part_1 & bram_ZYNQ_INST_din_part_0;
	
    bram_ZYNQ_INST_dout_part_0 <= bram_ZYNQ_INST_dout(31 downto 0);
	bram_ZYNQ_INST_dout_part_1 <= "0000" & bram_ZYNQ_INST_dout(CTRL_WIDTH-1 downto 32);
	    
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
        CLK_100 => CLK_100,
		locked => locked(0),
        CTRL_Signal => ctrl_signal,
        
    
		bram_ZYNQ_block_A_addr => bram_ZYNQ_block_A_addr(ADDR_WIDTH_DATA_BRAM - 1 downto 0),
        bram_ZYNQ_block_A_din => bram_ZYNQ_block_A_din,
        bram_ZYNQ_block_A_dout => bram_ZYNQ_block_A_dout,
        bram_ZYNQ_block_A_en => bram_ZYNQ_block_A_en,
        bram_ZYNQ_block_A_we => bram_ZYNQ_block_A_we,
    
		bram_ZYNQ_block_B_addr => bram_ZYNQ_block_B_addr(ADDR_WIDTH_DATA_BRAM - 1 downto 0),
        bram_ZYNQ_block_B_din => bram_ZYNQ_block_B_din,
        bram_ZYNQ_block_B_dout => bram_ZYNQ_block_B_dout,
        bram_ZYNQ_block_B_en => bram_ZYNQ_block_B_en,
        bram_ZYNQ_block_B_we => bram_ZYNQ_block_B_we,
            
        bram_ZYNQ_sel => START(0)
    );

end architecture;
    