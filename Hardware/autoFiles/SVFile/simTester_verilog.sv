
    `timescale 1ns / 1ps
module simTester_verilog();
reg CLK_100, locked, RST_IN,start_sig;
        
wire  completed;
localparam time t_100 = 40;
localparam integer ADDR_WIDTH = 12;
localparam integer INST_BRAM_SIZE = 4096;//(2**ADDR_WIDTH)
localparam integer ADDR_WIDTH_DATA_BRAM = 10;
localparam integer DATA_BRAM_SIZE = 1024;//(2**ADDR_WIDTH_DATA_BRAM)
localparam integer CTRL_WIDTH = 421;
localparam integer AU_SEL_WIDTH = 5;
localparam integer BRAM_SEL_WIDTH = 5;

`include "systemVerilog_A_INST.svh"

localparam integer BRAM_LIMIT_IND_DEBUG = 10; //It indicates that BRAM contents from location 0 to BRAM_LIMIT_IND_DEBUG will be dumped for all 4 BRAMS for every cycle

//Constant array to load the A matrix


    //For 0 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_A_addr;
reg [31:0]bram_ZYNQ_block_A_din;
wire [31:0]bram_ZYNQ_block_A_dout;
wire bram_ZYNQ_block_A_en;
wire [3:0]bram_ZYNQ_block_A_we;
    
    //For 1 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_B_addr;
reg [31:0]bram_ZYNQ_block_B_din;
wire [31:0]bram_ZYNQ_block_B_dout;
wire bram_ZYNQ_block_B_en;
wire [3:0]bram_ZYNQ_block_B_we;
    
    //For 2 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_C_addr;
reg [31:0]bram_ZYNQ_block_C_din;
wire [31:0]bram_ZYNQ_block_C_dout;
wire bram_ZYNQ_block_C_en;
wire [3:0]bram_ZYNQ_block_C_we;
    
    //For 3 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_D_addr;
reg [31:0]bram_ZYNQ_block_D_din;
wire [31:0]bram_ZYNQ_block_D_dout;
wire bram_ZYNQ_block_D_en;
wire [3:0]bram_ZYNQ_block_D_we;
    
    //For 4 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_E_addr;
reg [31:0]bram_ZYNQ_block_E_din;
wire [31:0]bram_ZYNQ_block_E_dout;
wire bram_ZYNQ_block_E_en;
wire [3:0]bram_ZYNQ_block_E_we;
    
    //For 5 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_F_addr;
reg [31:0]bram_ZYNQ_block_F_din;
wire [31:0]bram_ZYNQ_block_F_dout;
wire bram_ZYNQ_block_F_en;
wire [3:0]bram_ZYNQ_block_F_we;
    
    //For 6 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_G_addr;
reg [31:0]bram_ZYNQ_block_G_din;
wire [31:0]bram_ZYNQ_block_G_dout;
wire bram_ZYNQ_block_G_en;
wire [3:0]bram_ZYNQ_block_G_we;
    
    //For 7 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_H_addr;
reg [31:0]bram_ZYNQ_block_H_din;
wire [31:0]bram_ZYNQ_block_H_dout;
wire bram_ZYNQ_block_H_en;
wire [3:0]bram_ZYNQ_block_H_we;
    
    //For 8 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_I_addr;
reg [31:0]bram_ZYNQ_block_I_din;
wire [31:0]bram_ZYNQ_block_I_dout;
wire bram_ZYNQ_block_I_en;
wire [3:0]bram_ZYNQ_block_I_we;
    
    //For 9 BRAM
wire [ADDR_WIDTH_DATA_BRAM - 1 : 0]bram_ZYNQ_block_J_addr;
reg [31:0]bram_ZYNQ_block_J_din;
wire [31:0]bram_ZYNQ_block_J_dout;
wire bram_ZYNQ_block_J_en;
wire [3:0]bram_ZYNQ_block_J_we;
    

//Instruction BRAM
wire [31:0]bram_ZYNQ_INST_addr;
wire bram_ZYNQ_INST_en;
wire bram_ZYNQ_INST_we;
  
wire [31:0]bram_ZYNQ_INST_din_part_0;  
wire [31:0]bram_ZYNQ_INST_din_part_1;  
wire [31:0]bram_ZYNQ_INST_din_part_2;  
wire [31:0]bram_ZYNQ_INST_din_part_3;  
wire [31:0]bram_ZYNQ_INST_din_part_4;  
wire [31:0]bram_ZYNQ_INST_din_part_5;  
wire [31:0]bram_ZYNQ_INST_din_part_6;  
wire [31:0]bram_ZYNQ_INST_din_part_7;  
wire [31:0]bram_ZYNQ_INST_din_part_8;  
wire [31:0]bram_ZYNQ_INST_din_part_9;  
wire [31:0]bram_ZYNQ_INST_din_part_10;  
wire [31:0]bram_ZYNQ_INST_din_part_11;  
wire [31:0]bram_ZYNQ_INST_din_part_12;  
wire [31:0]bram_ZYNQ_INST_din_part_13;
wire [31:0]bram_ZYNQ_INST_dout_part_0;
wire [31:0]bram_ZYNQ_INST_dout_part_1;
wire [31:0]bram_ZYNQ_INST_dout_part_2;
wire [31:0]bram_ZYNQ_INST_dout_part_3;
wire [31:0]bram_ZYNQ_INST_dout_part_4;
wire [31:0]bram_ZYNQ_INST_dout_part_5;
wire [31:0]bram_ZYNQ_INST_dout_part_6;
wire [31:0]bram_ZYNQ_INST_dout_part_7;
wire [31:0]bram_ZYNQ_INST_dout_part_8;
wire [31:0]bram_ZYNQ_INST_dout_part_9;
wire [31:0]bram_ZYNQ_INST_dout_part_10;
wire [31:0]bram_ZYNQ_INST_dout_part_11;
wire [31:0]bram_ZYNQ_INST_dout_part_12;
wire [31:0]bram_ZYNQ_INST_dout_part_13;
//debug signals
wire [1:0]debug_state;

reg [31:0]BRAM_dump[0:9][0:1023];
reg [31:0]fptr,fptr2;
integer count;
reg complete_bit;

//MUX signal
reg [1:0]sel_mux_dataBRAM;


reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_A_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_A_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_A_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_A_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_A_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_B_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_B_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_B_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_B_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_B_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_C_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_C_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_C_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_C_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_C_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_D_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_D_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_D_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_D_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_D_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_E_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_E_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_E_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_E_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_E_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_F_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_F_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_F_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_F_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_F_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_G_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_G_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_G_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_G_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_G_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_H_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_H_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_H_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_H_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_H_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_I_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_I_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_I_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_I_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_I_dout;

reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_J_0; //For dumping BRAM contents
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_J_1; //For clearing
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_J_2; //For loading A matrix
reg [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_J_3; //Currently unused
wire [ADDR_WIDTH_DATA_BRAM-1:0]mux_dataBRAM_J_dout;

//Mux signals for enable

reg mux_dataBRAM_A_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_A_en1 = 0; //For clearing
reg mux_dataBRAM_A_en2 = 0; //For loading A matrix
reg mux_dataBRAM_A_en3 = 0; //Currently unused
wire mux_dataBRAM_A_endout;

reg mux_dataBRAM_B_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_B_en1 = 0; //For clearing
reg mux_dataBRAM_B_en2 = 0; //For loading A matrix
reg mux_dataBRAM_B_en3 = 0; //Currently unused
wire mux_dataBRAM_B_endout;

reg mux_dataBRAM_C_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_C_en1 = 0; //For clearing
reg mux_dataBRAM_C_en2 = 0; //For loading A matrix
reg mux_dataBRAM_C_en3 = 0; //Currently unused
wire mux_dataBRAM_C_endout;

reg mux_dataBRAM_D_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_D_en1 = 0; //For clearing
reg mux_dataBRAM_D_en2 = 0; //For loading A matrix
reg mux_dataBRAM_D_en3 = 0; //Currently unused
wire mux_dataBRAM_D_endout;

reg mux_dataBRAM_E_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_E_en1 = 0; //For clearing
reg mux_dataBRAM_E_en2 = 0; //For loading A matrix
reg mux_dataBRAM_E_en3 = 0; //Currently unused
wire mux_dataBRAM_E_endout;

reg mux_dataBRAM_F_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_F_en1 = 0; //For clearing
reg mux_dataBRAM_F_en2 = 0; //For loading A matrix
reg mux_dataBRAM_F_en3 = 0; //Currently unused
wire mux_dataBRAM_F_endout;

reg mux_dataBRAM_G_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_G_en1 = 0; //For clearing
reg mux_dataBRAM_G_en2 = 0; //For loading A matrix
reg mux_dataBRAM_G_en3 = 0; //Currently unused
wire mux_dataBRAM_G_endout;

reg mux_dataBRAM_H_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_H_en1 = 0; //For clearing
reg mux_dataBRAM_H_en2 = 0; //For loading A matrix
reg mux_dataBRAM_H_en3 = 0; //Currently unused
wire mux_dataBRAM_H_endout;

reg mux_dataBRAM_I_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_I_en1 = 0; //For clearing
reg mux_dataBRAM_I_en2 = 0; //For loading A matrix
reg mux_dataBRAM_I_en3 = 0; //Currently unused
wire mux_dataBRAM_I_endout;

reg mux_dataBRAM_J_en0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_J_en1 = 0; //For clearing
reg mux_dataBRAM_J_en2 = 0; //For loading A matrix
reg mux_dataBRAM_J_en3 = 0; //Currently unused
wire mux_dataBRAM_J_endout;

//Mux signals for write enable

reg mux_dataBRAM_A_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_A_we1 = 0; //For clearing
reg mux_dataBRAM_A_we2 = 0; //For loading A matrix
reg mux_dataBRAM_A_we3 = 0; //Currently unused
wire mux_dataBRAM_A_wedout;

reg mux_dataBRAM_B_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_B_we1 = 0; //For clearing
reg mux_dataBRAM_B_we2 = 0; //For loading A matrix
reg mux_dataBRAM_B_we3 = 0; //Currently unused
wire mux_dataBRAM_B_wedout;

reg mux_dataBRAM_C_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_C_we1 = 0; //For clearing
reg mux_dataBRAM_C_we2 = 0; //For loading A matrix
reg mux_dataBRAM_C_we3 = 0; //Currently unused
wire mux_dataBRAM_C_wedout;

reg mux_dataBRAM_D_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_D_we1 = 0; //For clearing
reg mux_dataBRAM_D_we2 = 0; //For loading A matrix
reg mux_dataBRAM_D_we3 = 0; //Currently unused
wire mux_dataBRAM_D_wedout;

reg mux_dataBRAM_E_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_E_we1 = 0; //For clearing
reg mux_dataBRAM_E_we2 = 0; //For loading A matrix
reg mux_dataBRAM_E_we3 = 0; //Currently unused
wire mux_dataBRAM_E_wedout;

reg mux_dataBRAM_F_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_F_we1 = 0; //For clearing
reg mux_dataBRAM_F_we2 = 0; //For loading A matrix
reg mux_dataBRAM_F_we3 = 0; //Currently unused
wire mux_dataBRAM_F_wedout;

reg mux_dataBRAM_G_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_G_we1 = 0; //For clearing
reg mux_dataBRAM_G_we2 = 0; //For loading A matrix
reg mux_dataBRAM_G_we3 = 0; //Currently unused
wire mux_dataBRAM_G_wedout;

reg mux_dataBRAM_H_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_H_we1 = 0; //For clearing
reg mux_dataBRAM_H_we2 = 0; //For loading A matrix
reg mux_dataBRAM_H_we3 = 0; //Currently unused
wire mux_dataBRAM_H_wedout;

reg mux_dataBRAM_I_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_I_we1 = 0; //For clearing
reg mux_dataBRAM_I_we2 = 0; //For loading A matrix
reg mux_dataBRAM_I_we3 = 0; //Currently unused
wire mux_dataBRAM_I_wedout;

reg mux_dataBRAM_J_we0 = 0; //For dumping BRAM contents
reg mux_dataBRAM_J_we1 = 0; //For clearing
reg mux_dataBRAM_J_we2 = 0; //For loading A matrix
reg mux_dataBRAM_J_we3 = 0; //Currently unused
wire mux_dataBRAM_J_wedout;

//Mux signals for din
reg sel_mux_dataBRAM_din;

reg [31:0]mux_dataBRAM_A_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_A_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_A_din_out;

reg [31:0]mux_dataBRAM_B_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_B_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_B_din_out;

reg [31:0]mux_dataBRAM_C_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_C_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_C_din_out;

reg [31:0]mux_dataBRAM_D_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_D_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_D_din_out;

reg [31:0]mux_dataBRAM_E_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_E_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_E_din_out;

reg [31:0]mux_dataBRAM_F_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_F_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_F_din_out;

reg [31:0]mux_dataBRAM_G_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_G_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_G_din_out;

reg [31:0]mux_dataBRAM_H_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_H_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_H_din_out;

reg [31:0]mux_dataBRAM_I_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_I_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_I_din_out;

reg [31:0]mux_dataBRAM_J_din0; //for clearing the data BRAMS
reg [31:0]mux_dataBRAM_J_din1; //for loading the data BRAMS
wire [31:0]mux_dataBRAM_J_din_out;

//Instruction BRAM muxes

reg [31:0]instBRAM_part0_din;
reg [31:0]instBRAM_part1_din;
reg [31:0]instBRAM_part2_din;
reg [31:0]instBRAM_part3_din;
reg [31:0]instBRAM_part4_din;
reg [31:0]instBRAM_part5_din;
reg [31:0]instBRAM_part6_din;
reg [31:0]instBRAM_part7_din;
reg [31:0]instBRAM_part8_din;
reg [31:0]instBRAM_part9_din;
reg [31:0]instBRAM_part10_din;
reg [31:0]instBRAM_part11_din;
reg [31:0]instBRAM_part12_din;
reg [31:0]instBRAM_part13_din;
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
locked,
RST_IN,
start_sig,
completed,

//0 BRAM
bram_ZYNQ_block_A_addr, 
bram_ZYNQ_block_A_din, 
bram_ZYNQ_block_A_dout, 
bram_ZYNQ_block_A_en,
bram_ZYNQ_block_A_we,

//1 BRAM
bram_ZYNQ_block_B_addr, 
bram_ZYNQ_block_B_din, 
bram_ZYNQ_block_B_dout, 
bram_ZYNQ_block_B_en,
bram_ZYNQ_block_B_we,

//2 BRAM
bram_ZYNQ_block_C_addr, 
bram_ZYNQ_block_C_din, 
bram_ZYNQ_block_C_dout, 
bram_ZYNQ_block_C_en,
bram_ZYNQ_block_C_we,

//3 BRAM
bram_ZYNQ_block_D_addr, 
bram_ZYNQ_block_D_din, 
bram_ZYNQ_block_D_dout, 
bram_ZYNQ_block_D_en,
bram_ZYNQ_block_D_we,

//4 BRAM
bram_ZYNQ_block_E_addr, 
bram_ZYNQ_block_E_din, 
bram_ZYNQ_block_E_dout, 
bram_ZYNQ_block_E_en,
bram_ZYNQ_block_E_we,

//5 BRAM
bram_ZYNQ_block_F_addr, 
bram_ZYNQ_block_F_din, 
bram_ZYNQ_block_F_dout, 
bram_ZYNQ_block_F_en,
bram_ZYNQ_block_F_we,

//6 BRAM
bram_ZYNQ_block_G_addr, 
bram_ZYNQ_block_G_din, 
bram_ZYNQ_block_G_dout, 
bram_ZYNQ_block_G_en,
bram_ZYNQ_block_G_we,

//7 BRAM
bram_ZYNQ_block_H_addr, 
bram_ZYNQ_block_H_din, 
bram_ZYNQ_block_H_dout, 
bram_ZYNQ_block_H_en,
bram_ZYNQ_block_H_we,

//8 BRAM
bram_ZYNQ_block_I_addr, 
bram_ZYNQ_block_I_din, 
bram_ZYNQ_block_I_dout, 
bram_ZYNQ_block_I_en,
bram_ZYNQ_block_I_we,

//9 BRAM
bram_ZYNQ_block_J_addr, 
bram_ZYNQ_block_J_din, 
bram_ZYNQ_block_J_dout, 
bram_ZYNQ_block_J_en,
bram_ZYNQ_block_J_we,

//Instruction BRAM
bram_ZYNQ_INST_addr,
bram_ZYNQ_INST_en,
bram_ZYNQ_INST_we,
bram_ZYNQ_INST_din_part_0,
    bram_ZYNQ_INST_din_part_1,
    bram_ZYNQ_INST_din_part_2,
    bram_ZYNQ_INST_din_part_3,
    bram_ZYNQ_INST_din_part_4,
    bram_ZYNQ_INST_din_part_5,
    bram_ZYNQ_INST_din_part_6,
    bram_ZYNQ_INST_din_part_7,
    bram_ZYNQ_INST_din_part_8,
    bram_ZYNQ_INST_din_part_9,
    bram_ZYNQ_INST_din_part_10,
    bram_ZYNQ_INST_din_part_11,
    bram_ZYNQ_INST_din_part_12,
    bram_ZYNQ_INST_din_part_13,
    bram_ZYNQ_INST_dout_part_0,
    bram_ZYNQ_INST_dout_part_1,
    bram_ZYNQ_INST_dout_part_2,
    bram_ZYNQ_INST_dout_part_3,
    bram_ZYNQ_INST_dout_part_4,
    bram_ZYNQ_INST_dout_part_5,
    bram_ZYNQ_INST_dout_part_6,
    bram_ZYNQ_INST_dout_part_7,
    bram_ZYNQ_INST_dout_part_8,
    bram_ZYNQ_INST_dout_part_9,
    bram_ZYNQ_INST_dout_part_10,
    bram_ZYNQ_INST_dout_part_11,
    bram_ZYNQ_INST_dout_part_12,
    bram_ZYNQ_INST_dout_part_13,
    //debug signals
debug_state
);

initial begin
CLK_100 = 1'b1;
forever #(t_100/2) CLK_100 = ~CLK_100;
end
//Initiallizing the mux to be used for DATA BRAMS address multiplexing
//For address
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut0(mux_dataBRAM_A_dout,mux_dataBRAM_A_0,mux_dataBRAM_A_1,mux_dataBRAM_A_2,mux_dataBRAM_A_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut1(mux_dataBRAM_B_dout,mux_dataBRAM_B_0,mux_dataBRAM_B_1,mux_dataBRAM_B_2,mux_dataBRAM_B_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut2(mux_dataBRAM_C_dout,mux_dataBRAM_C_0,mux_dataBRAM_C_1,mux_dataBRAM_C_2,mux_dataBRAM_C_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut3(mux_dataBRAM_D_dout,mux_dataBRAM_D_0,mux_dataBRAM_D_1,mux_dataBRAM_D_2,mux_dataBRAM_D_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut4(mux_dataBRAM_E_dout,mux_dataBRAM_E_0,mux_dataBRAM_E_1,mux_dataBRAM_E_2,mux_dataBRAM_E_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut5(mux_dataBRAM_F_dout,mux_dataBRAM_F_0,mux_dataBRAM_F_1,mux_dataBRAM_F_2,mux_dataBRAM_F_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut6(mux_dataBRAM_G_dout,mux_dataBRAM_G_0,mux_dataBRAM_G_1,mux_dataBRAM_G_2,mux_dataBRAM_G_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut7(mux_dataBRAM_H_dout,mux_dataBRAM_H_0,mux_dataBRAM_H_1,mux_dataBRAM_H_2,mux_dataBRAM_H_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut8(mux_dataBRAM_I_dout,mux_dataBRAM_I_0,mux_dataBRAM_I_1,mux_dataBRAM_I_2,mux_dataBRAM_I_3,sel_mux_dataBRAM);
    mux_4x1 #(ADDR_WIDTH_DATA_BRAM) uut9(mux_dataBRAM_J_dout,mux_dataBRAM_J_0,mux_dataBRAM_J_1,mux_dataBRAM_J_2,mux_dataBRAM_J_3,sel_mux_dataBRAM);
//For enable
    mux_4x1 #(1) uut10(mux_dataBRAM_A_endout,mux_dataBRAM_A_en0,mux_dataBRAM_A_en1,mux_dataBRAM_A_en2,mux_dataBRAM_A_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut11(mux_dataBRAM_B_endout,mux_dataBRAM_B_en0,mux_dataBRAM_B_en1,mux_dataBRAM_B_en2,mux_dataBRAM_B_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut12(mux_dataBRAM_C_endout,mux_dataBRAM_C_en0,mux_dataBRAM_C_en1,mux_dataBRAM_C_en2,mux_dataBRAM_C_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut13(mux_dataBRAM_D_endout,mux_dataBRAM_D_en0,mux_dataBRAM_D_en1,mux_dataBRAM_D_en2,mux_dataBRAM_D_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut14(mux_dataBRAM_E_endout,mux_dataBRAM_E_en0,mux_dataBRAM_E_en1,mux_dataBRAM_E_en2,mux_dataBRAM_E_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut15(mux_dataBRAM_F_endout,mux_dataBRAM_F_en0,mux_dataBRAM_F_en1,mux_dataBRAM_F_en2,mux_dataBRAM_F_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut16(mux_dataBRAM_G_endout,mux_dataBRAM_G_en0,mux_dataBRAM_G_en1,mux_dataBRAM_G_en2,mux_dataBRAM_G_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut17(mux_dataBRAM_H_endout,mux_dataBRAM_H_en0,mux_dataBRAM_H_en1,mux_dataBRAM_H_en2,mux_dataBRAM_H_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut18(mux_dataBRAM_I_endout,mux_dataBRAM_I_en0,mux_dataBRAM_I_en1,mux_dataBRAM_I_en2,mux_dataBRAM_I_en3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut19(mux_dataBRAM_J_endout,mux_dataBRAM_J_en0,mux_dataBRAM_J_en1,mux_dataBRAM_J_en2,mux_dataBRAM_J_en3,sel_mux_dataBRAM);
//For Write enable
    mux_4x1 #(1) uut20(mux_dataBRAM_A_wedout,mux_dataBRAM_A_we0,mux_dataBRAM_A_we1,mux_dataBRAM_A_we2,mux_dataBRAM_A_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut21(mux_dataBRAM_B_wedout,mux_dataBRAM_B_we0,mux_dataBRAM_B_we1,mux_dataBRAM_B_we2,mux_dataBRAM_B_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut22(mux_dataBRAM_C_wedout,mux_dataBRAM_C_we0,mux_dataBRAM_C_we1,mux_dataBRAM_C_we2,mux_dataBRAM_C_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut23(mux_dataBRAM_D_wedout,mux_dataBRAM_D_we0,mux_dataBRAM_D_we1,mux_dataBRAM_D_we2,mux_dataBRAM_D_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut24(mux_dataBRAM_E_wedout,mux_dataBRAM_E_we0,mux_dataBRAM_E_we1,mux_dataBRAM_E_we2,mux_dataBRAM_E_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut25(mux_dataBRAM_F_wedout,mux_dataBRAM_F_we0,mux_dataBRAM_F_we1,mux_dataBRAM_F_we2,mux_dataBRAM_F_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut26(mux_dataBRAM_G_wedout,mux_dataBRAM_G_we0,mux_dataBRAM_G_we1,mux_dataBRAM_G_we2,mux_dataBRAM_G_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut27(mux_dataBRAM_H_wedout,mux_dataBRAM_H_we0,mux_dataBRAM_H_we1,mux_dataBRAM_H_we2,mux_dataBRAM_H_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut28(mux_dataBRAM_I_wedout,mux_dataBRAM_I_we0,mux_dataBRAM_I_we1,mux_dataBRAM_I_we2,mux_dataBRAM_I_we3,sel_mux_dataBRAM);
    mux_4x1 #(1) uut29(mux_dataBRAM_J_wedout,mux_dataBRAM_J_we0,mux_dataBRAM_J_we1,mux_dataBRAM_J_we2,mux_dataBRAM_J_we3,sel_mux_dataBRAM);
//For din
    mux_2x1 #(32) uut30(mux_dataBRAM_A_din_out,mux_dataBRAM_A_din0,mux_dataBRAM_A_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut31(mux_dataBRAM_B_din_out,mux_dataBRAM_B_din0,mux_dataBRAM_B_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut32(mux_dataBRAM_C_din_out,mux_dataBRAM_C_din0,mux_dataBRAM_C_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut33(mux_dataBRAM_D_din_out,mux_dataBRAM_D_din0,mux_dataBRAM_D_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut34(mux_dataBRAM_E_din_out,mux_dataBRAM_E_din0,mux_dataBRAM_E_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut35(mux_dataBRAM_F_din_out,mux_dataBRAM_F_din0,mux_dataBRAM_F_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut36(mux_dataBRAM_G_din_out,mux_dataBRAM_G_din0,mux_dataBRAM_G_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut37(mux_dataBRAM_H_din_out,mux_dataBRAM_H_din0,mux_dataBRAM_H_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut38(mux_dataBRAM_I_din_out,mux_dataBRAM_I_din0,mux_dataBRAM_I_din1,sel_mux_dataBRAM_din);
    mux_2x1 #(32) uut39(mux_dataBRAM_J_din_out,mux_dataBRAM_J_din0,mux_dataBRAM_J_din1,sel_mux_dataBRAM_din);

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

assign bram_ZYNQ_block_A_addr = mux_dataBRAM_A_dout;
assign bram_ZYNQ_block_B_addr = mux_dataBRAM_B_dout;
assign bram_ZYNQ_block_C_addr = mux_dataBRAM_C_dout;
assign bram_ZYNQ_block_D_addr = mux_dataBRAM_D_dout;
assign bram_ZYNQ_block_E_addr = mux_dataBRAM_E_dout;
assign bram_ZYNQ_block_F_addr = mux_dataBRAM_F_dout;
assign bram_ZYNQ_block_G_addr = mux_dataBRAM_G_dout;
assign bram_ZYNQ_block_H_addr = mux_dataBRAM_H_dout;
assign bram_ZYNQ_block_I_addr = mux_dataBRAM_I_dout;
assign bram_ZYNQ_block_J_addr = mux_dataBRAM_J_dout;  
//Enable signals(data BRAM)

assign bram_ZYNQ_block_A_en = mux_dataBRAM_A_endout;
assign bram_ZYNQ_block_B_en = mux_dataBRAM_B_endout;
assign bram_ZYNQ_block_C_en = mux_dataBRAM_C_endout;
assign bram_ZYNQ_block_D_en = mux_dataBRAM_D_endout;
assign bram_ZYNQ_block_E_en = mux_dataBRAM_E_endout;
assign bram_ZYNQ_block_F_en = mux_dataBRAM_F_endout;
assign bram_ZYNQ_block_G_en = mux_dataBRAM_G_endout;
assign bram_ZYNQ_block_H_en = mux_dataBRAM_H_endout;
assign bram_ZYNQ_block_I_en = mux_dataBRAM_I_endout;
assign bram_ZYNQ_block_J_en = mux_dataBRAM_J_endout;  
//Write enable signals(data BRAM)

assign bram_ZYNQ_block_A_we = mux_dataBRAM_A_wedout;
assign bram_ZYNQ_block_B_we = mux_dataBRAM_B_wedout;
assign bram_ZYNQ_block_C_we = mux_dataBRAM_C_wedout;
assign bram_ZYNQ_block_D_we = mux_dataBRAM_D_wedout;
assign bram_ZYNQ_block_E_we = mux_dataBRAM_E_wedout;
assign bram_ZYNQ_block_F_we = mux_dataBRAM_F_wedout;
assign bram_ZYNQ_block_G_we = mux_dataBRAM_G_wedout;
assign bram_ZYNQ_block_H_we = mux_dataBRAM_H_wedout;
assign bram_ZYNQ_block_I_we = mux_dataBRAM_I_wedout;
assign bram_ZYNQ_block_J_we = mux_dataBRAM_J_wedout;  
//din signals(data BRAM)

assign bram_ZYNQ_block_A_din = mux_dataBRAM_A_din_out;
assign bram_ZYNQ_block_B_din = mux_dataBRAM_B_din_out;
assign bram_ZYNQ_block_C_din = mux_dataBRAM_C_din_out;
assign bram_ZYNQ_block_D_din = mux_dataBRAM_D_din_out;
assign bram_ZYNQ_block_E_din = mux_dataBRAM_E_din_out;
assign bram_ZYNQ_block_F_din = mux_dataBRAM_F_din_out;
assign bram_ZYNQ_block_G_din = mux_dataBRAM_G_din_out;
assign bram_ZYNQ_block_H_din = mux_dataBRAM_H_din_out;
assign bram_ZYNQ_block_I_din = mux_dataBRAM_I_din_out;
assign bram_ZYNQ_block_J_din = mux_dataBRAM_J_din_out;
//Address signal(inst BRAM)
assign bram_ZYNQ_INST_addr = instBRAM_addr;

//Enable signal(inst BRAM)
assign bram_ZYNQ_INST_en = instBRAM_en;

//Write enable signal(inst BRAM)
assign bram_ZYNQ_INST_we = instBRAM_we;

//din signal(inst BRAM)

assign bram_ZYNQ_INST_din_part_0 = instBRAM_part0_din;
assign bram_ZYNQ_INST_din_part_1 = instBRAM_part1_din;
assign bram_ZYNQ_INST_din_part_2 = instBRAM_part2_din;
assign bram_ZYNQ_INST_din_part_3 = instBRAM_part3_din;
assign bram_ZYNQ_INST_din_part_4 = instBRAM_part4_din;
assign bram_ZYNQ_INST_din_part_5 = instBRAM_part5_din;
assign bram_ZYNQ_INST_din_part_6 = instBRAM_part6_din;
assign bram_ZYNQ_INST_din_part_7 = instBRAM_part7_din;
assign bram_ZYNQ_INST_din_part_8 = instBRAM_part8_din;
assign bram_ZYNQ_INST_din_part_9 = instBRAM_part9_din;
assign bram_ZYNQ_INST_din_part_10 = instBRAM_part10_din;
assign bram_ZYNQ_INST_din_part_11 = instBRAM_part11_din;
assign bram_ZYNQ_INST_din_part_12 = instBRAM_part12_din;
assign bram_ZYNQ_INST_din_part_13 = instBRAM_part13_din;

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
    
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_mem_dump == 1 && mem_dump_complete != 1)begin 

    if(count == -1) begin
        fptr = $fopen("BRAM_dump.h","w");
        $fdisplay(fptr,"float bram_dump[%d][%d];",BRAM_LIMIT_IND_DEBUG,DATA_BRAM_SIZE);
        count = count + 1;
        mux_dataBRAM_A_en0 = 1'b1;
    mux_dataBRAM_B_en0 = 1'b1;
    mux_dataBRAM_C_en0 = 1'b1;
    mux_dataBRAM_D_en0 = 1'b1;
    mux_dataBRAM_E_en0 = 1'b1;
    mux_dataBRAM_F_en0 = 1'b1;
    mux_dataBRAM_G_en0 = 1'b1;
    mux_dataBRAM_H_en0 = 1'b1;
    mux_dataBRAM_I_en0 = 1'b1;
    mux_dataBRAM_J_en0 = 1'b1;
    mux_dataBRAM_A_we0 = 1'b0;
    mux_dataBRAM_B_we0 = 1'b0;
    mux_dataBRAM_C_we0 = 1'b0;
    mux_dataBRAM_D_we0 = 1'b0;
    mux_dataBRAM_E_we0 = 1'b0;
    mux_dataBRAM_F_we0 = 1'b0;
    mux_dataBRAM_G_we0 = 1'b0;
    mux_dataBRAM_H_we0 = 1'b0;
    mux_dataBRAM_I_we0 = 1'b0;
    mux_dataBRAM_J_we0 = 1'b0;
    
    // Adddress
    mux_dataBRAM_A_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_B_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_C_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_D_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_E_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_F_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_G_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_H_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_I_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_J_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    
    end
    else if(count == 0) begin
        count = count + 1;    
    
    // Adddress
    mux_dataBRAM_A_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_B_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_C_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_D_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_E_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_F_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_G_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_H_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_I_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_J_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
        end
    else if(count <= DATA_BRAM_SIZE && count >= 1)begin

            $fdisplay(fptr,"bram_dump[0][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_A_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[1][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_B_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[2][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_C_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[3][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_D_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[4][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_E_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[5][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_F_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[6][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_G_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[7][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_H_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[8][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_I_dout)); //count-1 because BRAM has single cycle latency
            $fdisplay(fptr,"bram_dump[9][%d] = %0.8e;",count-1,float_conv(bram_ZYNQ_block_J_dout)); //count-1 because BRAM has single cycle latency
            count = count + 1;
            mux_dataBRAM_A_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_B_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_C_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_D_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_E_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_F_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_G_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_H_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_I_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
            mux_dataBRAM_J_0 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    end
    else if (count == DATA_BRAM_SIZE+1) begin
        $fclose(fptr);
        count = -1;
        mem_dump_complete = 1;    

    mux_dataBRAM_A_en0 = 1'b0;
    mux_dataBRAM_B_en0 = 1'b0;
    mux_dataBRAM_C_en0 = 1'b0;
    mux_dataBRAM_D_en0 = 1'b0;
    mux_dataBRAM_E_en0 = 1'b0;
    mux_dataBRAM_F_en0 = 1'b0;
    mux_dataBRAM_G_en0 = 1'b0;
    mux_dataBRAM_H_en0 = 1'b0;
    mux_dataBRAM_I_en0 = 1'b0;
    mux_dataBRAM_J_en0 = 1'b0;
    end
end
else if(CLK_100 == 1 && start_mem_dump == 0)
    mem_dump_complete = 0;
end


//Always block to erase data BRAM contents
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_dataBRAM_erase == 1 && dataBRAM_erase_complete != 1)begin 

    if(count <= DATA_BRAM_SIZE-2 && count >= -1)begin
        if(count == -1) begin

    mux_dataBRAM_A_en1 = 1'b1;
    mux_dataBRAM_B_en1 = 1'b1;
    mux_dataBRAM_C_en1 = 1'b1;
    mux_dataBRAM_D_en1 = 1'b1;
    mux_dataBRAM_E_en1 = 1'b1;
    mux_dataBRAM_F_en1 = 1'b1;
    mux_dataBRAM_G_en1 = 1'b1;
    mux_dataBRAM_H_en1 = 1'b1;
    mux_dataBRAM_I_en1 = 1'b1;
    mux_dataBRAM_J_en1 = 1'b1;
    mux_dataBRAM_A_we1 = 1'b1;
    mux_dataBRAM_B_we1 = 1'b1;
    mux_dataBRAM_C_we1 = 1'b1;
    mux_dataBRAM_D_we1 = 1'b1;
    mux_dataBRAM_E_we1 = 1'b1;
    mux_dataBRAM_F_we1 = 1'b1;
    mux_dataBRAM_G_we1 = 1'b1;
    mux_dataBRAM_H_we1 = 1'b1;
    mux_dataBRAM_I_we1 = 1'b1;
    mux_dataBRAM_J_we1 = 1'b1;
    mux_dataBRAM_A_din0 = 0; 
    mux_dataBRAM_B_din0 = 0; 
    mux_dataBRAM_C_din0 = 0; 
    mux_dataBRAM_D_din0 = 0; 
    mux_dataBRAM_E_din0 = 0; 
    mux_dataBRAM_F_din0 = 0; 
    mux_dataBRAM_G_din0 = 0; 
    mux_dataBRAM_H_din0 = 0; 
    mux_dataBRAM_I_din0 = 0; 
    mux_dataBRAM_J_din0 = 0; 
    end
        count = count + 1;
    mux_dataBRAM_A_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_B_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_C_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_D_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_E_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_F_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_G_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_H_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_I_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    mux_dataBRAM_J_1 = count[ADDR_WIDTH_DATA_BRAM-1:0];
    end
    else if (count == DATA_BRAM_SIZE-1) begin
        count = -1;
        dataBRAM_erase_complete = 1;   

    mux_dataBRAM_A_en1 = 1'b0;
    mux_dataBRAM_B_en1 = 1'b0;
    mux_dataBRAM_C_en1 = 1'b0;
    mux_dataBRAM_D_en1 = 1'b0;
    mux_dataBRAM_E_en1 = 1'b0;
    mux_dataBRAM_F_en1 = 1'b0;
    mux_dataBRAM_G_en1 = 1'b0;
    mux_dataBRAM_H_en1 = 1'b0;
    mux_dataBRAM_I_en1 = 1'b0;
    mux_dataBRAM_J_en1 = 1'b0;
    mux_dataBRAM_A_we1 = 1'b0; 
    mux_dataBRAM_B_we1 = 1'b0; 
    mux_dataBRAM_C_we1 = 1'b0; 
    mux_dataBRAM_D_we1 = 1'b0; 
    mux_dataBRAM_E_we1 = 1'b0; 
    mux_dataBRAM_F_we1 = 1'b0; 
    mux_dataBRAM_G_we1 = 1'b0; 
    mux_dataBRAM_H_we1 = 1'b0; 
    mux_dataBRAM_I_we1 = 1'b0; 
    mux_dataBRAM_J_we1 = 1'b0; 
        end
end
else if(CLK_100 == 1 && start_dataBRAM_erase == 0)
    dataBRAM_erase_complete = 0;
end

//Always block to load the A matrix in data bram
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_A_load == 1 && A_load_complete != 1)begin 

    if(count <= A_size-2 && count >= -1)begin
        if(count == -1) //Initialization of en signals
        
    mux_dataBRAM_A_en2 = 1'b1;
    mux_dataBRAM_B_en2 = 1'b1;
    mux_dataBRAM_C_en2 = 1'b1;
    mux_dataBRAM_D_en2 = 1'b1;
    mux_dataBRAM_E_en2 = 1'b1;
    mux_dataBRAM_F_en2 = 1'b1;
    mux_dataBRAM_G_en2 = 1'b1;
    mux_dataBRAM_H_en2 = 1'b1;
    mux_dataBRAM_I_en2 = 1'b1;
    mux_dataBRAM_J_en2 = 1'b1;
    mux_dataBRAM_A_we2 = 1'b0;
    mux_dataBRAM_B_we2 = 1'b0;
    mux_dataBRAM_C_we2 = 1'b0;
    mux_dataBRAM_D_we2 = 1'b0;
    mux_dataBRAM_E_we2 = 1'b0;
    mux_dataBRAM_F_we2 = 1'b0;
    mux_dataBRAM_G_we2 = 1'b0;
    mux_dataBRAM_H_we2 = 1'b0;
    mux_dataBRAM_I_we2 = 1'b0;
    mux_dataBRAM_J_we2 = 1'b0;
    count = count + 1;
    if(A_BRAMInd[count] == 0) begin//making one of the write enables 1
        mux_dataBRAM_A_we2 = 1'b1; mux_dataBRAM_A_2 = A_BRAMAddr[count]; mux_dataBRAM_A_din1 = A[count];
    end

        else if(A_BRAMInd[count] == 1) begin
            mux_dataBRAM_B_we2 = 1'b1; mux_dataBRAM_B_2 = A_BRAMAddr[count]; mux_dataBRAM_B_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 2) begin
            mux_dataBRAM_C_we2 = 1'b1; mux_dataBRAM_C_2 = A_BRAMAddr[count]; mux_dataBRAM_C_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 3) begin
            mux_dataBRAM_D_we2 = 1'b1; mux_dataBRAM_D_2 = A_BRAMAddr[count]; mux_dataBRAM_D_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 4) begin
            mux_dataBRAM_E_we2 = 1'b1; mux_dataBRAM_E_2 = A_BRAMAddr[count]; mux_dataBRAM_E_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 5) begin
            mux_dataBRAM_F_we2 = 1'b1; mux_dataBRAM_F_2 = A_BRAMAddr[count]; mux_dataBRAM_F_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 6) begin
            mux_dataBRAM_G_we2 = 1'b1; mux_dataBRAM_G_2 = A_BRAMAddr[count]; mux_dataBRAM_G_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 7) begin
            mux_dataBRAM_H_we2 = 1'b1; mux_dataBRAM_H_2 = A_BRAMAddr[count]; mux_dataBRAM_H_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 8) begin
            mux_dataBRAM_I_we2 = 1'b1; mux_dataBRAM_I_2 = A_BRAMAddr[count]; mux_dataBRAM_I_din1 = A[count];
        end
        else if(A_BRAMInd[count] == 9) begin
            mux_dataBRAM_J_we2 = 1'b1; mux_dataBRAM_J_2 = A_BRAMAddr[count]; mux_dataBRAM_J_din1 = A[count];
        end
end
    else if (count == A_size-1) begin
        count = -1;
        A_load_complete = 1;   

    mux_dataBRAM_A_en2 = 1'b0; 
    mux_dataBRAM_B_en2 = 1'b0; 
    mux_dataBRAM_C_en2 = 1'b0; 
    mux_dataBRAM_D_en2 = 1'b0; 
    mux_dataBRAM_E_en2 = 1'b0; 
    mux_dataBRAM_F_en2 = 1'b0; 
    mux_dataBRAM_G_en2 = 1'b0; 
    mux_dataBRAM_H_en2 = 1'b0; 
    mux_dataBRAM_I_en2 = 1'b0; 
    mux_dataBRAM_J_en2 = 1'b0; 
    mux_dataBRAM_A_we2 = 1'b0;
    mux_dataBRAM_B_we2 = 1'b0;
    mux_dataBRAM_C_we2 = 1'b0;
    mux_dataBRAM_D_we2 = 1'b0;
    mux_dataBRAM_E_we2 = 1'b0;
    mux_dataBRAM_F_we2 = 1'b0;
    mux_dataBRAM_G_we2 = 1'b0;
    mux_dataBRAM_H_we2 = 1'b0;
    mux_dataBRAM_I_we2 = 1'b0;
    mux_dataBRAM_J_we2 = 1'b0;
        end
end
        else if(CLK_100 == 1 && start_A_load == 0)
        A_load_complete = 0;
end

//Always block to erase inst BRAM
always@(posedge CLK_100) begin
if(CLK_100 == 1 && start_instBRAM_erase == 1 && instBRAM_erase_complete != 1)begin 

    if(count <= INST_BRAM_SIZE-2 && count >= -1)begin
        if(count == -1) begin
            instBRAM_en = 1'b1;
            instBRAM_we = 1'b1;
            
    instBRAM_part0_din = 0;
    instBRAM_part1_din = 0;
    instBRAM_part2_din = 0;
    instBRAM_part3_din = 0;
    instBRAM_part4_din = 0;
    instBRAM_part5_din = 0;
    instBRAM_part6_din = 0;
    instBRAM_part7_din = 0;
    instBRAM_part8_din = 0;
    instBRAM_part9_din = 0;
    instBRAM_part10_din = 0;
    instBRAM_part11_din = 0;
    instBRAM_part12_din = 0;
    instBRAM_part13_din = 0;
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
    
    instBRAM_part0_din = Inst[count][0]; 
    instBRAM_part1_din = Inst[count][1]; 
    instBRAM_part2_din = Inst[count][2]; 
    instBRAM_part3_din = Inst[count][3]; 
    instBRAM_part4_din = Inst[count][4]; 
    instBRAM_part5_din = Inst[count][5]; 
    instBRAM_part6_din = Inst[count][6]; 
    instBRAM_part7_din = Inst[count][7]; 
    instBRAM_part8_din = Inst[count][8]; 
    instBRAM_part9_din = Inst[count][9]; 
    instBRAM_part10_din = Inst[count][10]; 
    instBRAM_part11_din = Inst[count][11]; 
    instBRAM_part12_din = Inst[count][12]; 
    instBRAM_part13_din = Inst[count][13]; 
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

