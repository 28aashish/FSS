
module LUDHardware 
    #(
        ADDR_WIDTH = 10,
        CTRL_WIDTH = 307,
        AU_SEL_WIDTH = 5,
        BRAM_SEL_WIDTH = 5
    ) 
    (
        input CLK_100,
        input CLK_200,
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
        wire [31:0]inputLocations[20:0];
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
    
    wire [ADDR_WIDTH-1:0] block_A_portc_addr;
    wire [31:0] block_A_portc_din;
    wire [31:0] block_A_portc_dout;
    wire block_A_portc_en;
    wire block_A_portc_we;
    
    wire [ADDR_WIDTH-1:0] block_A_portd_addr;
    wire [31:0] block_A_portd_din;
    wire [31:0] block_A_portd_dout;
    wire block_A_portd_en;
    wire block_A_portd_we;
    
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
    
    wire [ADDR_WIDTH-1:0] block_B_portc_addr;
    wire [31:0] block_B_portc_din;
    wire [31:0] block_B_portc_dout;
    wire block_B_portc_en;
    wire block_B_portc_we;
    
    wire [ADDR_WIDTH-1:0] block_B_portd_addr;
    wire [31:0] block_B_portd_din;
    wire [31:0] block_B_portd_dout;
    wire block_B_portd_en;
    wire block_B_portd_we;
    
    wire [ADDR_WIDTH-1:0] block_C_porta_addr;
    wire [31:0] block_C_porta_din;
    wire [31:0] block_C_porta_dout;
    wire block_C_porta_en;
    wire block_C_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_C_portb_addr;
    wire [31:0] block_C_portb_din;
    wire [31:0] block_C_portb_dout;
    wire block_C_portb_en;
    wire block_C_portb_we;
    
    wire [ADDR_WIDTH-1:0] block_C_portc_addr;
    wire [31:0] block_C_portc_din;
    wire [31:0] block_C_portc_dout;
    wire block_C_portc_en;
    wire block_C_portc_we;
    
    wire [ADDR_WIDTH-1:0] block_C_portd_addr;
    wire [31:0] block_C_portd_din;
    wire [31:0] block_C_portd_dout;
    wire block_C_portd_en;
    wire block_C_portd_we;
    
    wire [ADDR_WIDTH-1:0] block_D_porta_addr;
    wire [31:0] block_D_porta_din;
    wire [31:0] block_D_porta_dout;
    wire block_D_porta_en;
    wire block_D_porta_we;
    
    wire [ADDR_WIDTH-1:0] block_D_portb_addr;
    wire [31:0] block_D_portb_din;
    wire [31:0] block_D_portb_dout;
    wire block_D_portb_en;
    wire block_D_portb_we;
    
    wire [ADDR_WIDTH-1:0] block_D_portc_addr;
    wire [31:0] block_D_portc_din;
    wire [31:0] block_D_portc_dout;
    wire block_D_portc_en;
    wire block_D_portc_we;
    
    wire [ADDR_WIDTH-1:0] block_D_portd_addr;
    wire [31:0] block_D_portd_din;
    wire [31:0] block_D_portd_dout;
    wire block_D_portd_en;
    wire block_D_portd_we;
    
    wire [ADDR_WIDTH-1:0] bram_A_porta_addr;
    wire [31:0] bram_A_porta_din;
    wire [31:0] bram_A_porta_dout;
    wire bram_A_porta_en;
    wire bram_A_porta_we;
    
    wire [ADDR_WIDTH-1:0] bram_A_portb_addr;
    wire [31:0] bram_A_portb_din;
    wire [31:0] bram_A_portb_dout;
    wire bram_A_portb_en;
    wire bram_A_portb_we;
    
    wire [ADDR_WIDTH-1:0] bram_A_portc_addr;
    wire [31:0] bram_A_portc_din;
    wire [31:0] bram_A_portc_dout;
    wire bram_A_portc_en;
    wire bram_A_portc_we;
    
    wire [ADDR_WIDTH-1:0] bram_A_portd_addr;
    wire [31:0] bram_A_portd_din;
    wire [31:0] bram_A_portd_dout;
    wire bram_A_portd_en;
    wire bram_A_portd_we;
    
    wire [ADDR_WIDTH-1:0] bram_B_porta_addr;
    wire [31:0] bram_B_porta_din;
    wire [31:0] bram_B_porta_dout;
    wire bram_B_porta_en;
    wire bram_B_porta_we;
    
    wire [ADDR_WIDTH-1:0] bram_B_portb_addr;
    wire [31:0] bram_B_portb_din;
    wire [31:0] bram_B_portb_dout;
    wire bram_B_portb_en;
    wire bram_B_portb_we;
    
    wire [ADDR_WIDTH-1:0] bram_B_portc_addr;
    wire [31:0] bram_B_portc_din;
    wire [31:0] bram_B_portc_dout;
    wire bram_B_portc_en;
    wire bram_B_portc_we;
    
    wire [ADDR_WIDTH-1:0] bram_B_portd_addr;
    wire [31:0] bram_B_portd_din;
    wire [31:0] bram_B_portd_dout;
    wire bram_B_portd_en;
    wire bram_B_portd_we;
    
    wire [ADDR_WIDTH-1:0] bram_C_porta_addr;
    wire [31:0] bram_C_porta_din;
    wire [31:0] bram_C_porta_dout;
    wire bram_C_porta_en;
    wire bram_C_porta_we;
    
    wire [ADDR_WIDTH-1:0] bram_C_portb_addr;
    wire [31:0] bram_C_portb_din;
    wire [31:0] bram_C_portb_dout;
    wire bram_C_portb_en;
    wire bram_C_portb_we;
    
    wire [ADDR_WIDTH-1:0] bram_C_portc_addr;
    wire [31:0] bram_C_portc_din;
    wire [31:0] bram_C_portc_dout;
    wire bram_C_portc_en;
    wire bram_C_portc_we;
    
    wire [ADDR_WIDTH-1:0] bram_C_portd_addr;
    wire [31:0] bram_C_portd_din;
    wire [31:0] bram_C_portd_dout;
    wire bram_C_portd_en;
    wire bram_C_portd_we;
    
    wire [ADDR_WIDTH-1:0] bram_D_porta_addr;
    wire [31:0] bram_D_porta_din;
    wire [31:0] bram_D_porta_dout;
    wire bram_D_porta_en;
    wire bram_D_porta_we;
    
    wire [ADDR_WIDTH-1:0] bram_D_portb_addr;
    wire [31:0] bram_D_portb_din;
    wire [31:0] bram_D_portb_dout;
    wire bram_D_portb_en;
    wire bram_D_portb_we;
    
    wire [ADDR_WIDTH-1:0] bram_D_portc_addr;
    wire [31:0] bram_D_portc_din;
    wire [31:0] bram_D_portc_dout;
    wire bram_D_portc_en;
    wire bram_D_portc_we;
    
    wire [ADDR_WIDTH-1:0] bram_D_portd_addr;
    wire [31:0] bram_D_portd_din;
    wire [31:0] bram_D_portd_dout;
    wire bram_D_portd_en;
    wire bram_D_portd_we;
     
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
     
    wire [31:0] mac_B_result_tdata;
    wire mac_B_result_tready;
    wire mac_B_result_tvalid;

    wire [31:0] mac_B_a_tdata;
    wire mac_B_a_tready;
    wire mac_B_a_tvalid;

    wire [31:0]mac_B_b_tdata;
    wire mac_B_b_tready;
    wire mac_B_b_tvalid;

    wire [31:0] mac_B_c_tdata;
    wire mac_B_c_tready;
    wire mac_B_c_tvalid;

    wire [7:0] mac_B_operation_tdata;
    wire mac_B_operation_tready;
    wire mac_B_operation_tvalid;
    wire mac_B_a_signInv;

    wire [31:0]mac_B_a_tdataIN;
     
    wire [31:0] div_A_result_tdata;
    wire div_A_result_tready;
    wire div_A_result_tvalid;

    wire [31:0] div_A_a_tdata;
    wire div_A_a_tready;
    wire div_A_a_tvalid;

    wire [31:0] div_A_b_tdata;
    wire div_A_b_tready;
    wire div_A_b_tvalid;
     
    wire [31:0] div_B_result_tdata;
    wire div_B_result_tready;
    wire div_B_result_tvalid;

    wire [31:0] div_B_a_tdata;
    wire div_B_a_tready;
    wire div_B_a_tvalid;

    wire [31:0] div_B_b_tdata;
    wire div_B_b_tready;
    wire div_B_b_tvalid;
    
    wire [AU_SEL_WIDTH-1:0] mac_A_a_sel;
    wire [AU_SEL_WIDTH-1:0] mac_A_b_sel;
    wire [AU_SEL_WIDTH-1:0] mac_A_c_sel;
    
    wire [AU_SEL_WIDTH-1:0] mac_B_a_sel;
    wire [AU_SEL_WIDTH-1:0] mac_B_b_sel;
    wire [AU_SEL_WIDTH-1:0] mac_B_c_sel;
    
    wire [AU_SEL_WIDTH-1:0] div_A_a_sel;
    wire [AU_SEL_WIDTH-1:0] div_A_b_sel;
    
    wire [AU_SEL_WIDTH-1:0] div_B_a_sel;
    wire [AU_SEL_WIDTH-1:0] div_B_b_sel;
    
        wire [BRAM_SEL_WIDTH-1 : 0] bram_A_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_A_b_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_A_c_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_A_d_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_B_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_B_b_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_B_c_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_B_d_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_C_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_C_b_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_C_c_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_C_d_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_D_a_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_D_b_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_D_c_sel;
        wire [BRAM_SEL_WIDTH-1 : 0] bram_D_d_sel;

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


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_C_addr;
    wire [31:0] bram_mux_out_block_C_din;
    wire [31:0] bram_decoder_in_block_C;  
    wire bram_mux_out_block_C_en;
    wire bram_mux_out_block_C_we;

    wire bram_mux_out_block_C_clock;


    wire [ADDR_WIDTH - 1 : 0] bram_mux_out_block_D_addr;
    wire [31:0] bram_mux_out_block_D_din;
    wire [31:0] bram_decoder_in_block_D;  
    wire bram_mux_out_block_D_en;
    wire bram_mux_out_block_D_we;

    wire bram_mux_out_block_D_clock;
    quadPortBRAM #(10,32) BRAM_A
    (
        CLK_100,
        CLK_200,
        RST,
        
        bram_A_porta_addr,
        bram_A_porta_din,
        bram_A_porta_dout,
        bram_A_porta_en,
        bram_A_porta_we,
                
                
        bram_A_portb_addr,
        bram_A_portb_din,
        bram_A_portb_dout,
        bram_A_portb_en,
        bram_A_portb_we,
                
                
        bram_A_portc_addr,
        bram_A_portc_din,
        bram_A_portc_dout,
        bram_A_portc_en,
        bram_A_portc_we,
                
                
        bram_A_portd_addr,
        bram_A_portd_din,
        bram_A_portd_dout,
        bram_A_portd_en,
        bram_A_portd_we,
                
                
        block_A_porta_addr,
        block_A_porta_din,
        block_A_porta_dout,
        block_A_porta_en,
        block_A_porta_we    
            
            ,
        block_A_portb_addr,
        block_A_portb_din,
        block_A_portb_dout,
        block_A_portb_en,
        block_A_portb_we    
            
            
        );
            
    quadPortBRAM #(10,32) BRAM_B
    (
        CLK_100,
        CLK_200,
        RST,
        
        bram_B_porta_addr,
        bram_B_porta_din,
        bram_B_porta_dout,
        bram_B_porta_en,
        bram_B_porta_we,
                
                
        bram_B_portb_addr,
        bram_B_portb_din,
        bram_B_portb_dout,
        bram_B_portb_en,
        bram_B_portb_we,
                
                
        bram_B_portc_addr,
        bram_B_portc_din,
        bram_B_portc_dout,
        bram_B_portc_en,
        bram_B_portc_we,
                
                
        bram_B_portd_addr,
        bram_B_portd_din,
        bram_B_portd_dout,
        bram_B_portd_en,
        bram_B_portd_we,
                
                
        block_B_porta_addr,
        block_B_porta_din,
        block_B_porta_dout,
        block_B_porta_en,
        block_B_porta_we    
            
            ,
        block_B_portb_addr,
        block_B_portb_din,
        block_B_portb_dout,
        block_B_portb_en,
        block_B_portb_we    
            
            
        );
            
    quadPortBRAM #(10,32) BRAM_C
    (
        CLK_100,
        CLK_200,
        RST,
        
        bram_C_porta_addr,
        bram_C_porta_din,
        bram_C_porta_dout,
        bram_C_porta_en,
        bram_C_porta_we,
                
                
        bram_C_portb_addr,
        bram_C_portb_din,
        bram_C_portb_dout,
        bram_C_portb_en,
        bram_C_portb_we,
                
                
        bram_C_portc_addr,
        bram_C_portc_din,
        bram_C_portc_dout,
        bram_C_portc_en,
        bram_C_portc_we,
                
                
        bram_C_portd_addr,
        bram_C_portd_din,
        bram_C_portd_dout,
        bram_C_portd_en,
        bram_C_portd_we,
                
                
        block_C_porta_addr,
        block_C_porta_din,
        block_C_porta_dout,
        block_C_porta_en,
        block_C_porta_we    
            
            ,
        block_C_portb_addr,
        block_C_portb_din,
        block_C_portb_dout,
        block_C_portb_en,
        block_C_portb_we    
            
            
        );
            
    quadPortBRAM #(10,32) BRAM_D
    (
        CLK_100,
        CLK_200,
        RST,
        
        bram_D_porta_addr,
        bram_D_porta_din,
        bram_D_porta_dout,
        bram_D_porta_en,
        bram_D_porta_we,
                
                
        bram_D_portb_addr,
        bram_D_portb_din,
        bram_D_portb_dout,
        bram_D_portb_en,
        bram_D_portb_we,
                
                
        bram_D_portc_addr,
        bram_D_portc_din,
        bram_D_portc_dout,
        bram_D_portc_en,
        bram_D_portc_we,
                
                
        bram_D_portd_addr,
        bram_D_portd_din,
        bram_D_portd_dout,
        bram_D_portd_en,
        bram_D_portd_we,
                
                
        block_D_porta_addr,
        block_D_porta_din,
        block_D_porta_dout,
        block_D_porta_en,
        block_D_porta_we    
            
            ,
        block_D_portb_addr,
        block_D_portb_din,
        block_D_portb_dout,
        block_D_portb_en,
        block_D_portb_we    
            
            
        );
            
    design_BRAM_A_wrapper block_A (    
        
        .BRAM_PORTA_addr(bram_mux_out_block_A_addr),
        .BRAM_PORTA_clk(CLK_200),
        .BRAM_PORTA_din(bram_mux_out_block_A_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_A),
        .BRAM_PORTA_en(bram_mux_out_block_A_en),
        .BRAM_PORTA_we(bram_mux_out_block_A_we),

        .BRAM_PORTB_addr(block_A_portb_addr),
        .BRAM_PORTB_clk(CLK_200),
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
        .BRAM_PORTA_clk(CLK_200),
        .BRAM_PORTA_din(bram_mux_out_block_B_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_B),
        .BRAM_PORTA_en(bram_mux_out_block_B_en),
        .BRAM_PORTA_we(bram_mux_out_block_B_we),

        .BRAM_PORTB_addr(block_B_portb_addr),
        .BRAM_PORTB_clk(CLK_200),
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
    
    
    design_BRAM_A_wrapper block_C (    
        
        .BRAM_PORTA_addr(bram_mux_out_block_C_addr),
        .BRAM_PORTA_clk(CLK_200),
        .BRAM_PORTA_din(bram_mux_out_block_C_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_C),
        .BRAM_PORTA_en(bram_mux_out_block_C_en),
        .BRAM_PORTA_we(bram_mux_out_block_C_we),

        .BRAM_PORTB_addr(block_C_portb_addr),
        .BRAM_PORTB_clk(CLK_200),
        .BRAM_PORTB_din(block_C_portb_din),
        .BRAM_PORTB_dout(block_C_portb_dout),
        .BRAM_PORTB_en(block_C_portb_en),
        .BRAM_PORTB_we(block_C_portb_we)
            
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
    
    
    design_BRAM_A_wrapper block_D (    
        
        .BRAM_PORTA_addr(bram_mux_out_block_D_addr),
        .BRAM_PORTA_clk(CLK_200),
        .BRAM_PORTA_din(bram_mux_out_block_D_din),
        .BRAM_PORTA_dout(bram_decoder_in_block_D),
        .BRAM_PORTA_en(bram_mux_out_block_D_en),
        .BRAM_PORTA_we(bram_mux_out_block_D_we),

        .BRAM_PORTB_addr(block_D_portb_addr),
        .BRAM_PORTB_clk(CLK_200),
        .BRAM_PORTB_din(block_D_portb_din),
        .BRAM_PORTB_dout(block_D_portb_dout),
        .BRAM_PORTB_en(block_D_portb_en),
        .BRAM_PORTB_we(block_D_portb_we)
            
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
        
    design_MAC_wrapper MAC_B (
        .output_ans(mac_B_result_tdata),
        .output_ans_ack(mac_B_result_tready),
        .output_ans_stb(mac_B_result_tvalid),
        .input_a(mac_B_a_tdata),
        .input_a_ack(mac_B_a_tready),
        .input_a_stb(mac_B_a_tvalid),
        .input_b(mac_B_b_tdata),
        .input_b_ack(mac_B_b_tready),
        .input_b_stb(mac_B_b_tvalid),
        .input_c(mac_B_c_tdata),
        .input_c_ack(mac_B_c_tready),
        .input_c_stb(mac_B_c_tvalid),
        .input_op(mac_B_operation_tdata),
        .input_op_ack(mac_B_operation_tready),
        .input_op_stb(mac_B_operation_tvalid),
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
        
    design_DIV_wrapper DIV_B (
        .output_ans(div_B_result_tdata),
        .output_ans_ack(div_B_result_tready),
        .output_ans_stb(div_B_result_tvalid),
        .input_a(div_B_a_tdata),
        .input_a_ack(div_B_a_tready),
        .input_a_stb(div_B_a_tvalid),
        .input_b(div_B_b_tdata),
        .input_b_ack(div_B_b_tready),
        .input_b_stb(div_B_b_tvalid),
        .aclk(CLK_100),.rstn(locked)
    );  
        
// input locations
    
    
    assign inputLocations[0] = mac_A_result_tdata;
    assign inputLocations[1] = mac_B_result_tdata;
    assign inputLocations[2] = div_A_result_tdata;
    assign inputLocations[3] = div_B_result_tdata;
    assign inputLocations[4] = bram_A_porta_dout;
    assign inputLocations[5] = bram_A_portb_dout;
    assign inputLocations[6] = bram_A_portc_dout;
    assign inputLocations[7] = bram_A_portd_dout;
    assign inputLocations[8] = bram_B_porta_dout;
    assign inputLocations[9] = bram_B_portb_dout;
    assign inputLocations[10] = bram_B_portc_dout;
    assign inputLocations[11] = bram_B_portd_dout;
    assign inputLocations[12] = bram_C_porta_dout;
    assign inputLocations[13] = bram_C_portb_dout;
    assign inputLocations[14] = bram_C_portc_dout;
    assign inputLocations[15] = bram_C_portd_dout;
    assign inputLocations[16] = bram_D_porta_dout;
    assign inputLocations[17] = bram_D_portb_dout;
    assign inputLocations[18] = bram_D_portc_dout;
    assign inputLocations[19] = bram_D_portd_dout;
    assign inputLocations[20] = 0;     
    
    MUX_AU_IN MUX_MAC_IN_A_b(
        mac_A_b_sel,
        
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
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
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
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
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
        mac_A_a_tdataIN
    );
    assign mac_A_a_signInv = !mac_A_a_tdataIN[31];
    assign mac_A_a_tdata = {mac_A_a_signInv , mac_A_a_tdataIN[30:0]};
    
    MUX_AU_IN MUX_MAC_IN_B_b(
        mac_B_b_sel,
        
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
                mac_B_b_tdata
    );

    MUX_AU_IN MUX_MAC_IN_B_c 
    (
        mac_B_c_sel,

        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
                mac_B_c_tdata
    );

    MUX_AU_IN MUX_MAC_IN_B_a 
    (
        mac_B_a_sel,

        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],
        mac_B_a_tdataIN
    );
    assign mac_B_a_signInv = !mac_B_a_tdataIN[31];
    assign mac_B_a_tdata = {mac_B_a_signInv , mac_B_a_tdataIN[30:0]};
    

    MUX_AU_IN MUX_DIV_IN_A_a (
        div_A_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],div_A_a_tdata
    );

    MUX_AU_IN MUX_DIV_IN_A_b (
        div_A_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],div_A_b_tdata
    );


    MUX_AU_IN MUX_DIV_IN_B_a (
        div_B_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],div_B_a_tdata
    );

    MUX_AU_IN MUX_DIV_IN_B_b (
        div_B_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        inputLocations[20],div_B_b_tdata
    );

    MUX_BRAM_IN MUX_BRAM_A_a_in (
        bram_A_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_A_porta_din
    );
    MUX_BRAM_IN MUX_BRAM_A_b_in (
        bram_A_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        bram_A_portb_din
    );
    MUX_BRAM_IN MUX_BRAM_A_c_in (
        bram_A_c_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_A_portc_din
    );
    MUX_BRAM_IN MUX_BRAM_A_d_in(
        bram_A_d_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],bram_A_portd_din
    );


    
    MUX_BRAM_IN MUX_BRAM_B_a_in (
        bram_B_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_B_porta_din
    );
    MUX_BRAM_IN MUX_BRAM_B_b_in (
        bram_B_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        bram_B_portb_din
    );
    MUX_BRAM_IN MUX_BRAM_B_c_in (
        bram_B_c_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_B_portc_din
    );
    MUX_BRAM_IN MUX_BRAM_B_d_in(
        bram_B_d_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],bram_B_portd_din
    );


    
    MUX_BRAM_IN MUX_BRAM_C_a_in (
        bram_C_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_C_porta_din
    );
    MUX_BRAM_IN MUX_BRAM_C_b_in (
        bram_C_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        bram_C_portb_din
    );
    MUX_BRAM_IN MUX_BRAM_C_c_in (
        bram_C_c_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_C_portc_din
    );
    MUX_BRAM_IN MUX_BRAM_C_d_in(
        bram_C_d_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],bram_C_portd_din
    );


    
    MUX_BRAM_IN MUX_BRAM_D_a_in (
        bram_D_a_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_D_porta_din
    );
    MUX_BRAM_IN MUX_BRAM_D_b_in (
        bram_D_b_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
        bram_D_portb_din
    );
    MUX_BRAM_IN MUX_BRAM_D_c_in (
        bram_D_c_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],
            bram_D_portc_din
    );
    MUX_BRAM_IN MUX_BRAM_D_d_in(
        bram_D_d_sel,
        inputLocations[0],
        inputLocations[1],
        inputLocations[2],
        inputLocations[3],
        inputLocations[4],
        inputLocations[5],
        inputLocations[6],
        inputLocations[7],
        inputLocations[8],
        inputLocations[9],
        inputLocations[10],
        inputLocations[11],
        inputLocations[12],
        inputLocations[13],
        inputLocations[14],
        inputLocations[15],
        inputLocations[16],
        inputLocations[17],
        inputLocations[18],
        inputLocations[19],bram_D_portd_din
    );


    
    assign bram_A_porta_addr = CTRL_Signal[CTRL_WIDTH-0*ADDR_WIDTH-1 : CTRL_WIDTH-1*ADDR_WIDTH-0];
    assign bram_A_porta_we = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-1];
    assign bram_A_portb_addr = CTRL_Signal[CTRL_WIDTH-1*ADDR_WIDTH-2 : CTRL_WIDTH-2*ADDR_WIDTH-1];
    assign bram_A_portb_we = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-2];
    assign bram_A_portc_addr = CTRL_Signal[CTRL_WIDTH-2*ADDR_WIDTH-3 : CTRL_WIDTH-3*ADDR_WIDTH-2];
    assign bram_A_portc_we = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-3];
    assign bram_A_portd_addr = CTRL_Signal[CTRL_WIDTH-3*ADDR_WIDTH-4 : CTRL_WIDTH-4*ADDR_WIDTH-3];
    assign bram_A_portd_we = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-4];
    assign bram_B_porta_addr = CTRL_Signal[CTRL_WIDTH-4*ADDR_WIDTH-5 : CTRL_WIDTH-5*ADDR_WIDTH-4];
    assign bram_B_porta_we = CTRL_Signal[CTRL_WIDTH-5*ADDR_WIDTH-5];
    assign bram_B_portb_addr = CTRL_Signal[CTRL_WIDTH-5*ADDR_WIDTH-6 : CTRL_WIDTH-6*ADDR_WIDTH-5];
    assign bram_B_portb_we = CTRL_Signal[CTRL_WIDTH-6*ADDR_WIDTH-6];
    assign bram_B_portc_addr = CTRL_Signal[CTRL_WIDTH-6*ADDR_WIDTH-7 : CTRL_WIDTH-7*ADDR_WIDTH-6];
    assign bram_B_portc_we = CTRL_Signal[CTRL_WIDTH-7*ADDR_WIDTH-7];
    assign bram_B_portd_addr = CTRL_Signal[CTRL_WIDTH-7*ADDR_WIDTH-8 : CTRL_WIDTH-8*ADDR_WIDTH-7];
    assign bram_B_portd_we = CTRL_Signal[CTRL_WIDTH-8*ADDR_WIDTH-8];
    assign bram_C_porta_addr = CTRL_Signal[CTRL_WIDTH-8*ADDR_WIDTH-9 : CTRL_WIDTH-9*ADDR_WIDTH-8];
    assign bram_C_porta_we = CTRL_Signal[CTRL_WIDTH-9*ADDR_WIDTH-9];
    assign bram_C_portb_addr = CTRL_Signal[CTRL_WIDTH-9*ADDR_WIDTH-10 : CTRL_WIDTH-10*ADDR_WIDTH-9];
    assign bram_C_portb_we = CTRL_Signal[CTRL_WIDTH-10*ADDR_WIDTH-10];
    assign bram_C_portc_addr = CTRL_Signal[CTRL_WIDTH-10*ADDR_WIDTH-11 : CTRL_WIDTH-11*ADDR_WIDTH-10];
    assign bram_C_portc_we = CTRL_Signal[CTRL_WIDTH-11*ADDR_WIDTH-11];
    assign bram_C_portd_addr = CTRL_Signal[CTRL_WIDTH-11*ADDR_WIDTH-12 : CTRL_WIDTH-12*ADDR_WIDTH-11];
    assign bram_C_portd_we = CTRL_Signal[CTRL_WIDTH-12*ADDR_WIDTH-12];
    assign bram_D_porta_addr = CTRL_Signal[CTRL_WIDTH-12*ADDR_WIDTH-13 : CTRL_WIDTH-13*ADDR_WIDTH-12];
    assign bram_D_porta_we = CTRL_Signal[CTRL_WIDTH-13*ADDR_WIDTH-13];
    assign bram_D_portb_addr = CTRL_Signal[CTRL_WIDTH-13*ADDR_WIDTH-14 : CTRL_WIDTH-14*ADDR_WIDTH-13];
    assign bram_D_portb_we = CTRL_Signal[CTRL_WIDTH-14*ADDR_WIDTH-14];
    assign bram_D_portc_addr = CTRL_Signal[CTRL_WIDTH-14*ADDR_WIDTH-15 : CTRL_WIDTH-15*ADDR_WIDTH-14];
    assign bram_D_portc_we = CTRL_Signal[CTRL_WIDTH-15*ADDR_WIDTH-15];
    assign bram_D_portd_addr = CTRL_Signal[CTRL_WIDTH-15*ADDR_WIDTH-16 : CTRL_WIDTH-16*ADDR_WIDTH-15];
    assign bram_D_portd_we = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-16];
    assign mac_A_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-0*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-1*AU_SEL_WIDTH-16];
    assign mac_A_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-1*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-2*AU_SEL_WIDTH-16];
    assign mac_A_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-2*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-3*AU_SEL_WIDTH-16];
    assign mac_B_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-3*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-4*AU_SEL_WIDTH-16];
    assign mac_B_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-4*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-5*AU_SEL_WIDTH-16];
    assign mac_B_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-5*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-6*AU_SEL_WIDTH-16];
    assign div_A_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-6*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-7*AU_SEL_WIDTH-16];
    assign div_A_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-7*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-8*AU_SEL_WIDTH-16];
    assign div_B_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-8*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-9*AU_SEL_WIDTH-16];
    assign div_B_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-9*AU_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-16];
    assign bram_A_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-0*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-16];
    assign bram_A_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-1*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-16];
    assign bram_A_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-2*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-16];
    assign bram_A_d_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-3*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-4*BRAM_SEL_WIDTH-16];
    assign bram_B_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-4*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-5*BRAM_SEL_WIDTH-16];
    assign bram_B_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-5*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-6*BRAM_SEL_WIDTH-16];
    assign bram_B_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-6*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-7*BRAM_SEL_WIDTH-16];
    assign bram_B_d_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-7*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-8*BRAM_SEL_WIDTH-16];
    assign bram_C_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-8*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-9*BRAM_SEL_WIDTH-16];
    assign bram_C_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-9*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-10*BRAM_SEL_WIDTH-16];
    assign bram_C_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-10*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-11*BRAM_SEL_WIDTH-16];
    assign bram_C_d_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-11*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-12*BRAM_SEL_WIDTH-16];
    assign bram_D_a_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-12*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-13*BRAM_SEL_WIDTH-16];
    assign bram_D_b_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-13*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-14*BRAM_SEL_WIDTH-16];
    assign bram_D_c_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-14*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-15*BRAM_SEL_WIDTH-16];
    assign bram_D_d_sel = CTRL_Signal[CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-15*BRAM_SEL_WIDTH-17 : CTRL_WIDTH-16*ADDR_WIDTH-10*AU_SEL_WIDTH-16*BRAM_SEL_WIDTH-16];

    //--  CTRL_Signal(0) is actually a complete signal which is required by this module during debugging

    
    assign bram_A_porta_en = locked;
    assign bram_A_portb_en = locked;
    assign bram_A_portc_en = locked;
    assign bram_A_portd_en = locked;
    assign bram_B_porta_en = locked;
    assign bram_B_portb_en = locked;
    assign bram_B_portc_en = locked;
    assign bram_B_portd_en = locked;
    assign bram_C_porta_en = locked;
    assign bram_C_portb_en = locked;
    assign bram_C_portc_en = locked;
    assign bram_C_portd_en = locked;
    assign bram_D_porta_en = locked;
    assign bram_D_portb_en = locked;
    assign bram_D_portc_en = locked;
    assign bram_D_portd_en = locked;
    
    assign RST = !locked;

    

    assign mac_A_a_tvalid = locked;
    assign mac_A_b_tvalid = locked;
    assign mac_A_c_tvalid = locked;
    assign mac_A_operation_tvalid = locked;
    assign mac_A_operation_tdata = 0;// --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    assign mac_A_result_tready = locked;

    

    assign mac_B_a_tvalid = locked;
    assign mac_B_b_tvalid = locked;
    assign mac_B_c_tvalid = locked;
    assign mac_B_operation_tvalid = locked;
    assign mac_B_operation_tdata = 0;// --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    assign mac_B_result_tready = locked;

    

    assign div_A_a_tvalid = locked;
    assign div_A_b_tvalid = locked;
    assign div_A_result_tready = locked;

    

    assign div_B_a_tvalid = locked;
    assign div_B_b_tvalid = locked;
    assign div_B_result_tready = locked;

    
    
endmodule