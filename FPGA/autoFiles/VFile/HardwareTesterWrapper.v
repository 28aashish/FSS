module LUDH_TEST_WRAPPER 
    #(
        ADDR_WIDTH = 12, //Instruction BRAM
        ADDR_WIDTH_DATA_BRAM = 10,
        CTRL_WIDTH = 72,
        AU_SEL_WIDTH = 3,
        BRAM_SEL_WIDTH = 3
    )
    (
        input CLK_100,
    
        input locked,
        input RST_IN,
        input START,
        output COMPLETED,

        input [ADDR_WIDTH_DATA_BRAM-1:0] bram_ZYNQ_block_A_addr,
        input [31:0] bram_ZYNQ_block_A_din,
        output [31:0] bram_ZYNQ_block_A_dout,
        input bram_ZYNQ_block_A_en,
        input [3:0] bram_ZYNQ_block_A_we,
    
    

        input [ADDR_WIDTH_DATA_BRAM-1:0] bram_ZYNQ_block_B_addr,
        input [31:0] bram_ZYNQ_block_B_din,
        output [31:0] bram_ZYNQ_block_B_dout,
        input bram_ZYNQ_block_B_en,
        input [3:0] bram_ZYNQ_block_B_we,
    
    

        input [ADDR_WIDTH_DATA_BRAM-1:0] bram_ZYNQ_block_C_addr,
        input [31:0] bram_ZYNQ_block_C_din,
        output [31:0] bram_ZYNQ_block_C_dout,
        input bram_ZYNQ_block_C_en,
        input [3:0] bram_ZYNQ_block_C_we,
    
    

        input [ADDR_WIDTH_DATA_BRAM-1:0] bram_ZYNQ_block_D_addr,
        input [31:0] bram_ZYNQ_block_D_din,
        output [31:0] bram_ZYNQ_block_D_dout,
        input bram_ZYNQ_block_D_en,
        input [3:0] bram_ZYNQ_block_D_we,
    
    
        input [31:0]bram_ZYNQ_INST_addr,
        input bram_ZYNQ_INST_en,
        input bram_ZYNQ_INST_we,
    
        input [31:0] bram_ZYNQ_INST_din_part_0,
        input [31:0] bram_ZYNQ_INST_din_part_1,
        input [31:0] bram_ZYNQ_INST_din_part_2,
    	

        output [31:0] bram_ZYNQ_INST_dout_part_0,

        output [31:0] bram_ZYNQ_INST_dout_part_1,

        output [31:0] bram_ZYNQ_INST_dout_part_2,


        //debug signals
        output [1:0] debug_state
    );

    wire [CTRL_WIDTH-1:0] ctrl_signal; 
    
    //Instruction memory
    
    wire [95:0] bram_ZYNQ_INST_din; 
    wire [95:0] bram_ZYNQ_INST_dout;
    
    assign bram_ZYNQ_INST_din ={
bram_ZYNQ_INST_din_part_2 , bram_ZYNQ_INST_din_part_1 , bram_ZYNQ_INST_din_part_0};
	
    assign bram_ZYNQ_INST_dout_part_0 = bram_ZYNQ_INST_dout[31 : 0];
    assign bram_ZYNQ_INST_dout_part_1 = bram_ZYNQ_INST_dout[63 : 32];
    assign bram_ZYNQ_INST_dout_part_2 = { 24'b000000000000000000000000 , bram_ZYNQ_INST_dout[CTRL_WIDTH-1 : 64]};
	    
    LUDH_TESTER #(ADDR_WIDTH, CTRL_WIDTH) tester  (
        CLK_100,
        locked,
        RST_IN,
        ctrl_signal,
        COMPLETED,
        START,
        
        bram_ZYNQ_INST_addr[ADDR_WIDTH - 1 : 0],
        bram_ZYNQ_INST_din[CTRL_WIDTH - 1 : 0],
        bram_ZYNQ_INST_dout[CTRL_WIDTH - 1 : 0],
        bram_ZYNQ_INST_en,
        bram_ZYNQ_INST_we,
        
        //debug signals
        debug_state
    );


    LUDHardware #(ADDR_WIDTH_DATA_BRAM, CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH) LUDH (
        CLK_100,
		locked,
        ctrl_signal,
        
    
		bram_ZYNQ_block_A_addr[ADDR_WIDTH_DATA_BRAM - 1 : 0],
        bram_ZYNQ_block_A_din,
        bram_ZYNQ_block_A_dout,
        bram_ZYNQ_block_A_en,
        bram_ZYNQ_block_A_we[0],
    
		bram_ZYNQ_block_B_addr[ADDR_WIDTH_DATA_BRAM - 1 : 0],
        bram_ZYNQ_block_B_din,
        bram_ZYNQ_block_B_dout,
        bram_ZYNQ_block_B_en,
        bram_ZYNQ_block_B_we[0],
    
		bram_ZYNQ_block_C_addr[ADDR_WIDTH_DATA_BRAM - 1 : 0],
        bram_ZYNQ_block_C_din,
        bram_ZYNQ_block_C_dout,
        bram_ZYNQ_block_C_en,
        bram_ZYNQ_block_C_we[0],
    
		bram_ZYNQ_block_D_addr[ADDR_WIDTH_DATA_BRAM - 1 : 0],
        bram_ZYNQ_block_D_din,
        bram_ZYNQ_block_D_dout,
        bram_ZYNQ_block_D_en,
        bram_ZYNQ_block_D_we[0],
            
        START
    );

endmodule
    