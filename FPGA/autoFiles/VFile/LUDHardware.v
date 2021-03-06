
module LUDHardware 
    #(
        ADDR_WIDTH = 7,
        CTRL_WIDTH = 60,
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

        

        input bram_ZYNQ_sel
        
    );

    wire RST;
        wire [31:0]inputLocations[6:0];
    wire [ADDR_WIDTH-1:0] block_A_porta_addr;
    wire [31:0] block_A_porta_din;
    wire [31:0] block_A_porta_dout;
    wire block_A_porta_en;
    wire block_A_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_A_portb_addr;
    wire [31:0] block_A_portb_din;
    wire [31:0] block_A_portb_dout;
    wire block_A_portb_en;
    wire block_A_portb_we;
    
    wire [ADDR_WIDTH-1:0] block_B_porta_addr;
    wire [31:0] block_B_porta_din;
    wire [31:0] block_B_porta_dout;
    wire block_B_porta_en;
    wire block_B_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_B_portb_addr;
    wire [31:0] block_B_portb_din;
    wire [31:0] block_B_portb_dout;
    wire block_B_portb_en;
    wire block_B_portb_we;
     
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
        wire [BRAM_SEL_WIDTH-1 : 0] block_A_b_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] block_B_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] block_B_b_sel;

    //-Mux signals for connection to ZYNQ system
    
    


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_A_addr;
    wire [31:0] bram_mux_out_block_A_din;
    wire [31:0] bram_decoder_in_block_A;  
    wire bram_mux_out_block_A_en;
    wire bram_mux_out_block_A_we;

    wire bram_mux_out_block_A_clock;


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_B_addr;
    wire [31:0] bram_mux_out_block_B_din;
    wire [31:0] bram_decoder_in_block_B;  
    wire bram_mux_out_block_B_en;
    wire bram_mux_out_block_B_we;

    wire bram_mux_out_block_B_clock;
    design_BRAM_A_wrapper block_A (    
        
        .BRAM_PORTA_addr(bram_mux_out_block_A_addr),
        .BRAM_PORTA_clk(CLK_100),
        .BRAM_PORTA_din(bram_mux_out_block_A_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_A),
        .BRAM_PORTA_en(bram_mux_out_block_A_en),
        .BRAM_PORTA_we(bram_mux_out_block_A_we),

        .BRAM_PORTB_addr(block_A_portb_addr),
        .BRAM_PORTB_clk(CLK_100),
        .BRAM_PORTB_din(block_A_portb_din),
        .BRAM_PORTB_dout(block_A_portb_dout),
        .BRAM_PORTB_en(block_A_portb_en),
        .BRAM_PORTB_we(block_A_portb_we)
            
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
    
    
    design_BRAM_A_wrapper block_B (    
        
        .BRAM_PORTA_addr(bram_mux_out_block_B_addr),
        .BRAM_PORTA_clk(CLK_100),
        .BRAM_PORTA_din(bram_mux_out_block_B_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_B),
        .BRAM_PORTA_en(bram_mux_out_block_B_en),
        .BRAM_PORTA_we(bram_mux_out_block_B_we),

        .BRAM_PORTB_addr(block_B_portb_addr),
        .BRAM_PORTB_clk(CLK_100),
        .BRAM_PORTB_din(block_B_portb_din),
        .BRAM_PORTB_dout(block_B_portb_dout),
        .BRAM_PORTB_en(block_B_portb_en),
        .BRAM_PORTB_we(block_B_portb_we)
            
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
    
    
    design_MAC_wrapper MAC_A (
        .M_AXIS_RESULT_tdata(mac_A_result_tdata),
        .M_AXIS_RESULT_tready(mac_A_result_tready),
        .M_AXIS_RESULT_tvalid(mac_A_result_tvalid),
        .S_AXIS_A_tdata(mac_A_a_tdata),
        .S_AXIS_A_tready(mac_A_a_tready),
        .S_AXIS_A_tvalid(mac_A_a_tvalid),
        .S_AXIS_B_tdata(mac_A_b_tdata),
        .S_AXIS_B_tready(mac_A_b_tready),
        .S_AXIS_B_tvalid(mac_A_b_tvalid),
        .S_AXIS_C_tdata(mac_A_c_tdata),
        .S_AXIS_C_tready(mac_A_c_tready),
        .S_AXIS_C_tvalid(mac_A_c_tvalid),
        .S_AXIS_OPERATION_tdata(mac_A_operation_tdata),
        .S_AXIS_OPERATION_tready(mac_A_operation_tready),
        .S_AXIS_OPERATION_tvalid(mac_A_operation_tvalid),
        .aclk(CLK_100)
    );        
        
    design_DIV_wrapper DIV_A (
        .M_AXIS_RESULT_tdata(div_A_result_tdata),
        .M_AXIS_RESULT_tready(div_A_result_tready),
        .M_AXIS_RESULT_tvalid(div_A_result_tvalid),
        .S_AXIS_A_tdata(div_A_a_tdata),
        .S_AXIS_A_tready(div_A_a_tready),
        .S_AXIS_A_tvalid(div_A_a_tvalid),
        .S_AXIS_B_tdata(div_A_b_tdata),
        .S_AXIS_B_tready(div_A_b_tready),
        .S_AXIS_B_tvalid(div_A_b_tvalid),
        .aclk(CLK_100)
    );  
        
// input locations
    
    
    assign inputLocations[0] = mac_A_result_tdata;
    assign inputLocations[1] = div_A_result_tdata;
    assign inputLocations[2] = block_A_porta_dout;
    assign inputLocations[3] = block_A_portb_dout;
    assign inputLocations[4] = block_B_porta_dout;
    assign inputLocations[5] = block_B_portb_dout;
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
    

    MUX_BRAM_IN MUX_BRAM_A_b_in (
        block_A_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        block_A_portb_din

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
    

    MUX_BRAM_IN MUX_BRAM_B_b_in (
        block_B_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        block_B_portb_din

    );
        
        
    assign block_A_porta_addr = CTRL_Signal[CTRL_WIDTH-0*ADDR_WIDTH-1 : CTRL_WIDTH-1*ADDR_WIDTH-0];
    assign block_A_porta_we = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-1];
    assign block_A_portb_addr = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-2 : CTRL_WIDTH-2*ADDR_WIDTH-1];
    assign block_A_portb_we = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-2];
    assign block_B_porta_addr = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-3 : CTRL_WIDTH-3*ADDR_WIDTH-2];
    assign block_B_porta_we = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-3];
    assign block_B_portb_addr = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-4 : CTRL_WIDTH-4*ADDR_WIDTH-3];
    assign block_B_portb_we = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-4];
    assign mac_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-0*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-1*AU_SEL_WIDTH-4];
    assign mac_A_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-1*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-2*AU_SEL_WIDTH-4];
    assign mac_A_c_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-2*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-3*AU_SEL_WIDTH-4];
    assign div_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-3*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-4*AU_SEL_WIDTH-4];
    assign div_A_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-4*AU_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-4];
    assign block_A_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-0*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-4];
    assign block_A_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-4];
    assign block_B_a_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-4];
    assign block_B_b_sel = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-5 : CTRL_WIDTH-4*ADDR_WIDTH-5*AU_SEL_WIDTH-4*BRAM_SEL_WIDTH-4];

    //--  CTRL_Signal(0) is actually a complete signal which is required by this module during debugging

    
    assign block_A_porta_en = locked;
    assign block_A_portb_en = locked;
    assign block_B_porta_en = locked;
    assign block_B_portb_en = locked;
    
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