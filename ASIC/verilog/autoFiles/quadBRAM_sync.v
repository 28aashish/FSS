module quadPortBRAM #(ADDR_WIDTH = 11,DATA_WIDTH = 32) (CLK_1X,CLK_2X,RST,BRAM_PORTA_ADDR,BRAM_PORTA_DIN,BRAM_PORTA_DOUT,BRAM_PORTA_EN,BRAM_PORTA_WE,
                                                        BRAM_PORTB_ADDR,BRAM_PORTB_DIN,BRAM_PORTB_DOUT,BRAM_PORTB_EN,BRAM_PORTB_WE,
                                                        BRAM_PORTC_ADDR,BRAM_PORTC_DIN,BRAM_PORTC_DOUT,BRAM_PORTC_EN,BRAM_PORTC_WE,
                                                        BRAM_PORTD_ADDR,BRAM_PORTD_DIN,BRAM_PORTD_DOUT,BRAM_PORTD_EN,BRAM_PORTD_WE,
                                                        BLOCK_PORTA_ADDR,BLOCK_PORTA_DIN,BLOCK_PORTA_DOUT,BLOCK_PORTA_EN,BLOCK_PORTA_WE,
                                                        BLOCK_PORTB_ADDR,BLOCK_PORTB_DIN,BLOCK_PORTB_DOUT,BLOCK_PORTB_EN,BLOCK_PORTB_WE);


    input CLK_1X,CLK_2X,RST;
    input [ADDR_WIDTH-1:0] BRAM_PORTA_ADDR,BRAM_PORTB_ADDR,BRAM_PORTC_ADDR,BRAM_PORTD_ADDR;
    input [DATA_WIDTH-1:0] BRAM_PORTA_DIN,BRAM_PORTB_DIN,BRAM_PORTC_DIN,BRAM_PORTD_DIN;
    output [DATA_WIDTH-1:0] BRAM_PORTA_DOUT,BRAM_PORTB_DOUT,BRAM_PORTC_DOUT,BRAM_PORTD_DOUT;
    input BRAM_PORTA_EN,BRAM_PORTB_EN,BRAM_PORTC_EN,BRAM_PORTD_EN;
    input BRAM_PORTA_WE,BRAM_PORTB_WE,BRAM_PORTC_WE,BRAM_PORTD_WE;

    output [ADDR_WIDTH-1:0] BLOCK_PORTA_ADDR,BLOCK_PORTB_ADDR;
    output [DATA_WIDTH-1:0] BLOCK_PORTA_DIN,BLOCK_PORTB_DIN;
    input [DATA_WIDTH-1:0] BLOCK_PORTA_DOUT,BLOCK_PORTB_DOUT;
    output BLOCK_PORTA_EN,BLOCK_PORTB_EN;
    output BLOCK_PORTA_WE,BLOCK_PORTB_WE;



     wire [DATA_WIDTH-1:0]reg_portA;
     wire [ADDR_WIDTH-1:0]reg_portB_addr_out;
     wire [DATA_WIDTH-1:0]reg_portB_din_out;
     wire reg_portB_en_out;
     wire reg_portB_we_out;
     wire [DATA_WIDTH-1:0]reg_portC;
     wire [ADDR_WIDTH-1:0]reg_portD_addr_out;
     wire [DATA_WIDTH-1:0]reg_portD_din_out;
     wire reg_portD_en_out;
     wire reg_portD_we_out;

     wire mux_sel;
     wire reg_ena;
     wire portACOutReg0ENA;

     wire [DATA_WIDTH + ADDR_WIDTH + 1:0] portBInReg_in, portBInReg_out;
     wire [DATA_WIDTH + ADDR_WIDTH + 1:0] portDInReg_in, portDInReg_out;

      assign mux_sel = CLK_1X ^ CLK_2X;
     assign reg_ena = !RST;
     assign portACOutReg0ENA = mux_sel & reg_ena;

     assign BLOCK_PORTA_ADDR = !mux_sel ? BRAM_PORTA_ADDR : reg_portB_addr_out;
     assign BLOCK_PORTA_DIN  = !mux_sel ? BRAM_PORTA_DIN  : reg_portB_din_out;
     assign BLOCK_PORTA_EN   = !mux_sel ? BRAM_PORTA_EN   : reg_portB_en_out;
     assign BLOCK_PORTA_WE   = !mux_sel ? BRAM_PORTA_WE   : reg_portB_we_out;

     assign BLOCK_PORTB_ADDR = !mux_sel ? BRAM_PORTC_ADDR : reg_portD_addr_out;
     assign BLOCK_PORTB_DIN  = !mux_sel ? BRAM_PORTC_DIN  : reg_portD_din_out;
     assign BLOCK_PORTB_EN   = !mux_sel ? BRAM_PORTC_EN   : reg_portD_en_out;
     assign BLOCK_PORTB_WE   = !mux_sel ? BRAM_PORTC_WE   : reg_portD_we_out;


    assign portBInReg_in  = {BRAM_PORTB_ADDR , BRAM_PORTB_DIN , BRAM_PORTB_EN , BRAM_PORTB_WE};
    assign reg_portB_addr_out  = portBInReg_out[DATA_WIDTH + ADDR_WIDTH : 2 + DATA_WIDTH];
    assign reg_portB_din_out   = portBInReg_out[1 + DATA_WIDTH : 2];
    assign reg_portB_en_out    = portBInReg_out[1];
    assign reg_portB_we_out    = portBInReg_out[0];

    myReg #(ADDR_WIDTH + DATA_WIDTH + 2) portBInReg (CLK_1X,RST,reg_ena,portBInReg_in,portBInReg_out);

    myReg #(DATA_WIDTH) portBOutReg (CLK_1X,RST,reg_ena,BLOCK_PORTA_DOUT,BRAM_PORTB_DOUT);

    myReg #(DATA_WIDTH) portAOutReg0 (CLK_2X,RST,portACOutReg0ENA,BLOCK_PORTA_DOUT,reg_portA);

    myReg #(DATA_WIDTH) portAOutReg1 (CLK_1X,RST,reg_ena,reg_portA,BRAM_PORTA_DOUT);


     assign portDInReg_in = {BRAM_PORTD_ADDR , BRAM_PORTD_DIN ,BRAM_PORTD_EN , BRAM_PORTD_WE};
     assign reg_portD_addr_out  = portDInReg_out[DATA_WIDTH + ADDR_WIDTH : 2 + DATA_WIDTH];
     assign reg_portD_din_out   = portDInReg_out[1 + DATA_WIDTH : 2];
     assign reg_portD_en_out    = portDInReg_out[1];
     assign reg_portD_we_out    = portDInReg_out[0];

    myReg #(ADDR_WIDTH + DATA_WIDTH + 2) portDInReg (CLK_1X,RST,reg_ena,portDInReg_in
,portDInReg_out);


    myReg #(DATA_WIDTH) portDOutReg (CLK_1X,RST,reg_ena,BLOCK_PORTB_DOUT,BRAM_PORTD_DOUT);

    myReg #(DATA_WIDTH) portCOutReg0 (CLK_2X,RST,portACOutReg0ENA,BLOCK_PORTB_DOUT,reg_portC);

    myReg #(DATA_WIDTH) portCOutReg1 (CLK_1X,RST,reg_ena,reg_portC,BRAM_PORTC_DOUT);

 endmodule