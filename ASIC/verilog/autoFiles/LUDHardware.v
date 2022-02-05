
module LUDHardware 
    #(
        ADDR_WIDTH = 10,
        CTRL_WIDTH = 72,
        AU_SEL_WIDTH = 3,
        BRAM_SEL_WIDTH = 3
    ) 
    (
        input CLK_100,
        input locked,
        input [CTRL_WIDTH-1:0] CTRL_Signal,

//These ports will be connected to the ZYNQ processing system
        input [ADDR_WIDTH-1:0]bram_ZYNQ_block_A_addr,
        input [31:0]bram_ZYNQ_block_A_din,
        output [31:0]bram_ZYNQ_block_A_dout,
        input bram_ZYNQ_block_A_en,
        input bram_ZYNQ_block_A_we,        

        
        input [ADDR_WIDTH-1:0]bram_ZYNQ_block_B_addr,
        input [31:0]bram_ZYNQ_block_B_din,
        output [31:0]bram_ZYNQ_block_B_dout,
        input bram_ZYNQ_block_B_en,
        input bram_ZYNQ_block_B_we,        

        
        input [ADDR_WIDTH-1:0]bram_ZYNQ_block_C_addr,
        input [31:0]bram_ZYNQ_block_C_din,
        output [31:0]bram_ZYNQ_block_C_dout,
        input bram_ZYNQ_block_C_en,
        input bram_ZYNQ_block_C_we,        

        
        input [ADDR_WIDTH-1:0]bram_ZYNQ_block_D_addr,
        input [31:0]bram_ZYNQ_block_D_din,
        output [31:0]bram_ZYNQ_block_D_dout,
        input bram_ZYNQ_block_D_en,
        input bram_ZYNQ_block_D_we,        

        

        input bram_ZYNQ_sel
        
    );

    wire RST;
        wire [31:0]inputLocations[6:0];
    wire [ADDR_WIDTH-1:0] block_A_porta_addr;
    wire [31:0] block_A_porta_din;
    wire [31:0] block_A_porta_dout;
    wire block_A_porta_en;
    wire block_A_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_B_porta_addr;
    wire [31:0] block_B_porta_din;
    wire [31:0] block_B_porta_dout;
    wire block_B_porta_en;
    wire block_B_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_C_porta_addr;
    wire [31:0] block_C_porta_din;
    wire [31:0] block_C_porta_dout;
    wire block_C_porta_en;
    wire block_C_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_D_porta_addr;
    wire [31:0] block_D_porta_din;
    wire [31:0] block_D_porta_dout;
    wire block_D_porta_en;
    wire block_D_porta_we;
     
    wire [31:0] mac_A_result_tdata;
    wire mac_A_result_tready;
    wire mac_A_result_tvalid;

    wire [31:0] mac_A_a_tdata;
    wire mac_A_a_tready;
    wire mac_A_a_tvalid;

    wire [31:0]mac_A_b_tdata;
    wire mac_A_b_tready;
    wire mac_A_b_tvalid;

    wire [31:0] mac_A_c_tdata;
    wire mac_A_c_tready;
    wire mac_A_c_tvalid;

    wire [7:0] mac_A_operation_tdata;
    wire mac_A_operation_tready;
    wire mac_A_operation_tvalid;
    wire mac_A_a_signInv;

    wire [31:0]mac_A_a_tdataIN;
     
    wire [31:0] div_A_result_tdata;
    wire div_A_result_tready;
    wire div_A_result_tvalid;

    wire [31:0] div_A_a_tdata;
    wire div_A_a_tready;
    wire div_A_a_tvalid;

    wire [31:0] div_A_b_tdata;
    wire div_A_b_tready;
    wire div_A_b_tvalid;
    
    wire [AU_SEL_WIDTH-1:0] mac_A_a_sel;
    wire [AU_SEL_WIDTH-1:0] mac_A_b_sel;
    wire [AU_SEL_WIDTH-1:0] mac_A_c_sel;
    
    wire [AU_SEL_WIDTH-1:0] div_A_a_sel;
    wire [AU_SEL_WIDTH-1:0] div_A_b_sel;
    
        wire [BRAM_SEL_WIDTH-1 : 0] block_A_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] block_B_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] block_C_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] block_D_a_sel;

    //-Mux signals for connection to ZYNQ system
    
    


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_A_addr;
    wire [31:0] bram_mux_out_block_A_din;
    wire [31:0] bram_decoder_in_block_A;  
    wire bram_mux_out_block_A_en;
    wire bram_mux_out_block_A_we;

    


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_B_addr;
    wire [31:0] bram_mux_out_block_B_din;
    wire [31:0] bram_decoder_in_block_B;  
    wire bram_mux_out_block_B_en;
    wire bram_mux_out_block_B_we;

    


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_C_addr;
    wire [31:0] bram_mux_out_block_C_din;
    wire [31:0] bram_decoder_in_block_C;  
    wire bram_mux_out_block_C_en;
    wire bram_mux_out_block_C_we;

    


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_D_addr;
    wire [31:0] bram_mux_out_block_D_din;
    wire [31:0] bram_decoder_in_block_D;  
    wire bram_mux_out_block_D_en;
    wire bram_mux_out_block_D_we;

    
    DATA_32_1024_sky130A block_A (    
        
        .addr0(bram_mux_out_block_A_addr),
        .clk0(CLK_100),
        .din0(bram_mux_out_block_A_din),
        .dout0(bram_decoder_in_block_A),
        .csb0(bram_mux_out_block_A_en),
        .web0(bram_mux_out_block_A_we)
    );
    bram_ZYNQ_mux #(ADDR_WIDTH) bram_ZYNQ_mux_A 
        ( bram_ZYNQ_block_A_addr,
          bram_ZYNQ_block_A_din,
          bram_ZYNQ_block_A_en,
          bram_ZYNQ_block_A_we,
          block_A_porta_addr,
          block_A_porta_din,
          block_A_porta_en,
          block_A_porta_we,
          bram_mux_out_block_A_addr,
          bram_mux_out_block_A_din,
          bram_mux_out_block_A_en,
          bram_mux_out_block_A_we,
          bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder #(32) bram_ZYNQ_decoder_A
        ( bram_decoder_in_block_A,
          bram_ZYNQ_block_A_dout,
          block_A_porta_dout,
          bram_ZYNQ_sel
          );
    
    
    DATA_32_1024_sky130A block_B (    
        
        .addr0(bram_mux_out_block_B_addr),
        .clk0(CLK_100),
        .din0(bram_mux_out_block_B_din),
        .dout0(bram_decoder_in_block_B),
        .csb0(bram_mux_out_block_B_en),
        .web0(bram_mux_out_block_B_we)
    );
    bram_ZYNQ_mux #(ADDR_WIDTH) bram_ZYNQ_mux_B 
        ( bram_ZYNQ_block_B_addr,
          bram_ZYNQ_block_B_din,
          bram_ZYNQ_block_B_en,
          bram_ZYNQ_block_B_we,
          block_B_porta_addr,
          block_B_porta_din,
          block_B_porta_en,
          block_B_porta_we,
          bram_mux_out_block_B_addr,
          bram_mux_out_block_B_din,
          bram_mux_out_block_B_en,
          bram_mux_out_block_B_we,
          bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder #(32) bram_ZYNQ_decoder_B
        ( bram_decoder_in_block_B,
          bram_ZYNQ_block_B_dout,
          block_B_porta_dout,
          bram_ZYNQ_sel
          );
    
    
    DATA_32_1024_sky130A block_C (    
        
        .addr0(bram_mux_out_block_C_addr),
        .clk0(CLK_100),
        .din0(bram_mux_out_block_C_din),
        .dout0(bram_decoder_in_block_C),
        .csb0(bram_mux_out_block_C_en),
        .web0(bram_mux_out_block_C_we)
    );
    bram_ZYNQ_mux #(ADDR_WIDTH) bram_ZYNQ_mux_C 
        ( bram_ZYNQ_block_C_addr,
          bram_ZYNQ_block_C_din,
          bram_ZYNQ_block_C_en,
          bram_ZYNQ_block_C_we,
          block_C_porta_addr,
          block_C_porta_din,
          block_C_porta_en,
          block_C_porta_we,
          bram_mux_out_block_C_addr,
          bram_mux_out_block_C_din,
          bram_mux_out_block_C_en,
          bram_mux_out_block_C_we,
          bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder #(32) bram_ZYNQ_decoder_C
        ( bram_decoder_in_block_C,
          bram_ZYNQ_block_C_dout,
          block_C_porta_dout,
          bram_ZYNQ_sel
          );
    
    
    DATA_32_1024_sky130A block_D (    
        
        .addr0(bram_mux_out_block_D_addr),
        .clk0(CLK_100),
        .din0(bram_mux_out_block_D_din),
        .dout0(bram_decoder_in_block_D),
        .csb0(bram_mux_out_block_D_en),
        .web0(bram_mux_out_block_D_we)
    );
    bram_ZYNQ_mux #(ADDR_WIDTH) bram_ZYNQ_mux_D 
        ( bram_ZYNQ_block_D_addr,
          bram_ZYNQ_block_D_din,
          bram_ZYNQ_block_D_en,
          bram_ZYNQ_block_D_we,
          block_D_porta_addr,
          block_D_porta_din,
          block_D_porta_en,
          block_D_porta_we,
          bram_mux_out_block_D_addr,
          bram_mux_out_block_D_din,
          bram_mux_out_block_D_en,
          bram_mux_out_block_D_we,
          bram_ZYNQ_sel
          );
    bram_ZYNQ_decoder #(32) bram_ZYNQ_decoder_D
        ( bram_decoder_in_block_D,
          bram_ZYNQ_block_D_dout,
          block_D_porta_dout,
          bram_ZYNQ_sel
          );
    
    
    design_MAC_wrapper MAC_A (
        .output_ans(mac_A_result_tdata),
        .output_ans_ack(mac_A_result_tready),
        .output_ans_stb(mac_A_result_tvalid),
        .input_a(mac_A_a_tdata),
        .input_a_ack(mac_A_a_tready),
        .input_a_stb(mac_A_a_tvalid),
        .input_b(mac_A_b_tdata),
        .input_b_ack(mac_A_b_tready),
        .input_b_stb(mac_A_b_tvalid),
        .input_c(mac_A_c_tdata),
        .input_c_ack(mac_A_c_tready),
        .input_c_stb(mac_A_c_tvalid),
        .input_op(mac_A_operation_tdata),
        .input_op_ack(mac_A_operation_tready),
        .input_op_stb(mac_A_operation_tvalid),
        .aclk(CLK_100),.rstn(locked)
    );        
        
    design_DIV_wrapper DIV_A (
        .output_ans(div_A_result_tdata),
        .output_ans_ack(div_A_result_tready),
        .output_ans_stb(div_A_result_tvalid),
        .input_a(div_A_a_tdata),
        .input_a_ack(div_A_a_tready),
        .input_a_stb(div_A_a_tvalid),
        .input_b(div_A_b_tdata),
        .input_b_ack(div_A_b_tready),
        .input_b_stb(div_A_b_tvalid),
        .aclk(CLK_100),.rstn(locked)
    );  
        
// input locations
    
    
    assign inputLocations[0] = mac_A_result_tdata;
    assign inputLocations[1] = div_A_result_tdata;
    assign inputLocations[2] = block_A_porta_dout;
    assign inputLocations[3] = block_B_porta_dout;
    assign inputLocations[4] = block_C_porta_dout;
    assign inputLocations[5] = block_D_porta_dout;
    assign inputLocations[6] = 0;     
    
    MUX_AU_IN MUX_MAC_IN_A_b(
        mac_A_b_sel,
        
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
                mac_A_b_tdata
    );

    MUX_AU_IN MUX_MAC_IN_A_c 
    (
        mac_A_c_sel,

        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
                mac_A_c_tdata
    );

    MUX_AU_IN MUX_MAC_IN_A_a 
    (
        mac_A_a_sel,

        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        mac_A_a_tdataIN
    );
    assign mac_A_a_signInv = !mac_A_a_tdataIN[31];
    assign mac_A_a_tdata = {mac_A_a_signInv , mac_A_a_tdataIN[30:0]};
    

    MUX_AU_IN MUX_DIV_IN_A_a (
        div_A_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],div_A_a_tdata
    );

    MUX_AU_IN MUX_DIV_IN_A_b (
        div_A_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],div_A_b_tdata
    );

    MUX_BRAM_IN MUX_BRAM_A_a_in (
        block_A_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],block_A_porta_din
    );
    
    MUX_BRAM_IN MUX_BRAM_B_a_in (
        block_B_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],block_B_porta_din
    );
    
    MUX_BRAM_IN MUX_BRAM_C_a_in (
        block_C_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],block_C_porta_din
    );
    
    MUX_BRAM_IN MUX_BRAM_D_a_in (
        block_D_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],block_D_porta_din
    );
    
    assign block_A_porta_addr = CTRL_Signal[CTRL_WIDTH-0*ADDR_WIDTH-1 : CTRL_WIDTH-1*ADDR_WIDTH-0];
    assign block_A_porta_we = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-1];
    assign block_B_porta_addr = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-2 : CTRL_WIDTH-2*ADDR_WIDTH-1];
    assign block_B_porta_we = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-2];
    assign block_C_porta_addr = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-3 : CTRL_WIDTH-3*ADDR_WIDTH-2];
    assign block_C_porta_we = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-3];
    assign block_D_porta_addr = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-4 : CTRL_WIDTH-4*ADDR_WIDTH-3];
    assign block_D_porta_we = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-4];
    assign mac_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-0*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-1*AU_SEL_WIDTH-4];
    assign mac_A_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-1*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-2*AU_SEL_WIDTH-4];
    assign mac_A_c_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-2*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-3*AU_SEL_WIDTH-4];
    assign div_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-3*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-4*AU_SEL_WIDTH-4];
    assign div_A_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-4*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-4];
    assign block_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-0*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-4];
    assign block_B_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-4];
    assign block_C_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-4];
    assign block_D_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-4*BRAM_SEL_WIDTH-4];

    //--  CTRL_Signal(0) is actually a complete signal which is required by this module during debugging

    
    assign block_A_porta_en = locked;
    assign block_B_porta_en = locked;
    assign block_C_porta_en = locked;
    assign block_D_porta_en = locked;
    
    assign RST = !locked;

    

    assign mac_A_a_tvalid = locked;
    assign mac_A_b_tvalid = locked;
    assign mac_A_c_tvalid = locked;
    assign mac_A_operation_tvalid = locked;
    assign mac_A_operation_tdata = 0;// --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    assign mac_A_result_tready = locked;

    

    assign div_A_a_tvalid = locked;
    assign div_A_b_tvalid = locked;
    assign div_A_result_tready = locked;

    
    
endmodule