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


def hardwareMUX_verilog():
    MUX_AU_IN  = open("./autoFiles/VFile/MUX_AU_IN.v", 'w')
    MUX_BRAM_IN  = open("./autoFiles/VFile/MUX_BRAM_IN.v", 'w')
    MUX_AU_IN.write("""module MUX_AU_IN(
        SEL
    """)
    MUX_BRAM_IN.write("""module MUX_BRAM_IN(
        SEL""")
#NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT
    stringer="""
        ,DIN{0}"""
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
       MUX_AU_IN.write(stringer.format(idx))
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
       MUX_BRAM_IN.write(stringer.format(idx))
    stringer="""
            ,DOUT
    );
        input [{0}-1:0]SEL;
        input [31:0]DIN0"""
    MUX_AU_IN.write(stringer.format(AU_SEL_WIDTH))
    MUX_BRAM_IN.write(stringer.format(BRAM_SEL_WIDTH))
    stringer=""",DIN{0}"""

    for idx in range(1,NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
       MUX_AU_IN.write(stringer.format(idx))
    for idx in range(1,NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
       MUX_BRAM_IN.write(stringer.format(idx))
    MUX_AU_IN.write(""";

    output reg [31:0]DOUT;

    always @(SEL""")
    MUX_BRAM_IN.write(""";

    output reg [31:0]DOUT;

    always @(SEL""")
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
       MUX_AU_IN.write(stringer.format(idx))
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
       MUX_BRAM_IN.write(stringer.format(idx))    
    MUX_AU_IN.write(""")
    begin
        case(SEL)""")
    MUX_BRAM_IN.write(""")
    begin
        case(SEL)""")
    stringer="""
            {1}'d{0}:DOUT=DIN{0};"""
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT+1):
       MUX_AU_IN.write(stringer.format(idx,AU_SEL_WIDTH))
    for idx in range(NUM_MAC_DIV_S*2+NUM_BRAM*NUM_PORT):
       MUX_BRAM_IN.write(stringer.format(idx,BRAM_SEL_WIDTH))
    MUX_AU_IN.write("""
            default:DOUT= {32{1'hx}};
        endcase
    end
endmodule        
        """)       
    MUX_BRAM_IN.write("""
            default:DOUT= {32{1'hx}};
        endcase
    end
endmodule        
        """)       

def hardwareTester_verilog():       
    vhdFile  = open("./autoFiles/VFile/hardwareTester.v", 'w')
    stringer="""module LUDH_TESTER #(ADDR_WIDTH = {0},
        CTRL_WIDTH = {1})
        (CLK_100,locked,RST,CTRL_SIGNAL,COMPLETED,START,
        bram_ZYNQ_INST_addr,
        bram_ZYNQ_INST_din,
        bram_ZYNQ_INST_dout,
        bram_ZYNQ_INST_en,
        bram_ZYNQ_INST_we,
        debug_state
        );

        input CLK_100,locked,RST;
        inout [CTRL_WIDTH-1 : 0] CTRL_SIGNAL;
        output COMPLETED;
        input START;

        input [ADDR_WIDTH - 1 : 0]bram_ZYNQ_INST_addr;
        input [CTRL_WIDTH - 1 : 0]bram_ZYNQ_INST_din;
        output [CTRL_WIDTH - 1 : 0]bram_ZYNQ_INST_dout;
        input bram_ZYNQ_INST_en;
        input bram_ZYNQ_INST_we;
        
        output [1:0] debug_state;


    wire [CTRL_WIDTH-1:0]CTRL_SIGNAL_temp;
    
    wire [ADDR_WIDTH-1 : 0]ctrl_addr, ctrl_addr_in;

    reg run_test, test_completed;
    wire sync_start;
    wire reg_en, complete_bit;
    reg reset_counter_reg;
    wire reset_counter;
    
    reg [1:0] pr_state,nxt_state ;
    
    //--Mux signals
    wire [ADDR_WIDTH-1:0]muxout_addr;
    wire [CTRL_WIDTH-1:0]muxout_din;
    wire [CTRL_WIDTH-1:0]decoder_input;
    wire muxout_en;
    wire muxout_we;
    

    //--debug signals
    assign debug_state = pr_state;

    assign complete_bit = CTRL_SIGNAL[0];
    
    assign reg_en = locked & run_test;

    assign COMPLETED = test_completed; //This signal is such that it will be 0 only when LUD hardware is running. Else it will be 1
                                 //This is required for the individual cycle bram dump in test bench
    
    assign reset_counter = RST | reset_counter_reg;
    
    //--once operation is completed, the address will no longer be incremented
    assign ctrl_addr_in = reg_en ? ctrl_addr + 1'b1 : 0;

    
    myReg #(ADDR_WIDTH) ctrlAddrReg (
        .CLK(CLK_100),
        .ARST(reset_counter),
        .ENA(reg_en),
        .DIN(ctrl_addr_in),
        .DOUT(ctrl_addr));


    assign sync_start = START;
    
    //--FSM
    //--sync_start and complete_bit are the input to FSM. test_completed, reset_counter_reg, and run_test are the output to FSM

    always @(posedge CLK_100)
        begin
            if(RST)
                pr_state<=0;
            else
                pr_state<=nxt_state;
        end

    always @(pr_state, sync_start, complete_bit)
    begin
    case(pr_state)
    2'b00:
        begin
            test_completed = 1;
            run_test = 0;
            reset_counter_reg = 1;
            if(sync_start) 
                nxt_state = 2'b01;
            else
                nxt_state = 2'b00;
        end
    2'b01:
        begin
            test_completed = 0;
            run_test = 1;
            reset_counter_reg = 0;
            if(sync_start) 
                begin
                    if(complete_bit)
                        nxt_state = 2'b10;
                    else
                        nxt_state = 2'b01;
                end
            else
                nxt_state = 2'b00;
        end
    2'b10:
        begin
            test_completed = 1;
            run_test = 0;
            reset_counter_reg = 0;
            if(sync_start) 
                nxt_state = 2'b10;
            else
                nxt_state = 2'b00;
        end
    default:
        begin
            test_completed = 1;
            run_test = 0;
            reset_counter_reg = 1;
            nxt_state = 2'b00;
        end
    endcase
    end
    
    design_CTRL_wrapper ctrlStorage(
    muxout_addr ,
    CLK_100,
    muxout_din ,
    decoder_input ,
    muxout_en ,
    muxout_we
    );

    assign muxout_addr =!sync_start ? bram_ZYNQ_INST_addr :ctrl_addr;
    assign muxout_din =!sync_start ? bram_ZYNQ_INST_din :{{ADDR_WIDTH{{1'b0}}}};
    assign muxout_en =!sync_start ? bram_ZYNQ_INST_en :1;
    assign muxout_we =!sync_start ? bram_ZYNQ_INST_we :0;
    
    bram_ZYNQ_decoder #(CTRL_WIDTH) bram_ZYNQ_decoder_INST(
     decoder_input,
     bram_ZYNQ_INST_dout,
     CTRL_SIGNAL_temp,
     sync_start);

    
    assign CTRL_SIGNAL = !sync_start ? 0 :CTRL_SIGNAL_temp;

endmodule"""
    vhdFile.write(stringer.format(ADDR_WIDTH,CTRL_WIDTH,ADDR_WIDTH-1,CTRL_WIDTH-1))
    vhdFile.close()

def LUDHardware_verilog():
    vhdFile  = open("./autoFiles/VFile/LUDHardware.v", 'w')
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
    wire mac_{0}_result_tready;
    wire mac_{0}_result_tvalid;

    wire [31:0] mac_{0}_a_tdata;
    wire mac_{0}_a_tready;
    wire mac_{0}_a_tvalid;

    wire [31:0]mac_{0}_b_tdata;
    wire mac_{0}_b_tready;
    wire mac_{0}_b_tvalid;

    wire [31:0] mac_{0}_c_tdata;
    wire mac_{0}_c_tready;
    wire mac_{0}_c_tvalid;

    wire [7:0] mac_{0}_operation_tdata;
    wire mac_{0}_operation_tready;
    wire mac_{0}_operation_tvalid;
    wire mac_{0}_a_signInv;

    wire [31:0]mac_{0}_a_tdataIN;
    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))  
    stringer=""" 
    wire [31:0] div_{0}_result_tdata;
    wire div_{0}_result_tready;
    wire div_{0}_result_tvalid;

    wire [31:0] div_{0}_a_tdata;
    wire div_{0}_a_tready;
    wire div_{0}_a_tvalid;

    wire [31:0] div_{0}_b_tdata;
    wire div_{0}_b_tready;
    wire div_{0}_b_tvalid;
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

    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    design_MAC_wrapper MAC_{0} (
        .M_AXIS_RESULT_tdata(mac_{0}_result_tdata),
        .M_AXIS_RESULT_tready(mac_{0}_result_tready),
        .M_AXIS_RESULT_tvalid(mac_{0}_result_tvalid),
        .S_AXIS_A_tdata(mac_{0}_a_tdata),
        .S_AXIS_A_tready(mac_{0}_a_tready),
        .S_AXIS_A_tvalid(mac_{0}_a_tvalid),
        .S_AXIS_B_tdata(mac_{0}_b_tdata),
        .S_AXIS_B_tready(mac_{0}_b_tready),
        .S_AXIS_B_tvalid(mac_{0}_b_tvalid),
        .S_AXIS_C_tdata(mac_{0}_c_tdata),
        .S_AXIS_C_tready(mac_{0}_c_tready),
        .S_AXIS_C_tvalid(mac_{0}_c_tvalid),
        .S_AXIS_OPERATION_tdata(mac_{0}_operation_tdata),
        .S_AXIS_OPERATION_tready(mac_{0}_operation_tready),
        .S_AXIS_OPERATION_tvalid(mac_{0}_operation_tvalid),
        .aclk(CLK_100)
    );        
        """
        vhdFile.write(stringer.format(chr(id0)))
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        stringer="""
    design_DIV_wrapper DIV_{0} (
        .M_AXIS_RESULT_tdata(div_{0}_result_tdata),
        .M_AXIS_RESULT_tready(div_{0}_result_tready),
        .M_AXIS_RESULT_tvalid(div_{0}_result_tvalid),
        .S_AXIS_A_tdata(div_{0}_a_tdata),
        .S_AXIS_A_tready(div_{0}_a_tready),
        .S_AXIS_A_tvalid(div_{0}_a_tvalid),
        .S_AXIS_B_tdata(div_{0}_b_tdata),
        .S_AXIS_B_tready(div_{0}_b_tready),
        .S_AXIS_B_tvalid(div_{0}_b_tvalid),
        .aclk(CLK_100)
    );  
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

    assign mac_{0}_a_tvalid = locked;
    assign mac_{0}_b_tvalid = locked;
    assign mac_{0}_c_tvalid = locked;
    assign mac_{0}_operation_tvalid = locked;
    assign mac_{0}_operation_tdata = 0;// --Indicates substraction(AB-C). 1 indicates addition(AB+C)
    assign mac_{0}_result_tready = locked;

    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))
    stringer="""

    assign div_{0}_a_tvalid = locked;
    assign div_{0}_b_tvalid = locked;
    assign div_{0}_result_tready = locked;

    """
    for id0 in range(65, 65 + NUM_MAC_DIV_S):
        vhdFile.write(stringer.format(chr(id0)))
    vhdFile.write("""
    
endmodule""")
    vhdFile.close()

def hardwareTesterWrapper_verilog():
	vhdFile  = open("./autoFiles/VFile/HardwareTesterWrapper.v", 'w')
	stringer="""module LUDH_TEST_WRAPPER 
    #(
        ADDR_WIDTH = {0}, //Instruction BRAM
        ADDR_WIDTH_DATA_BRAM = {1},
        CTRL_WIDTH = {2},
        AU_SEL_WIDTH = {3},
        BRAM_SEL_WIDTH = {4}
    )
    (
        input CLK_100,
    """
	vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH))
	if NUM_PORT==4:
		vhdFile.write("""input CLK_200,""")
	vhdFile.write("""
        input locked,
        input RST_IN,
        input START,
        output COMPLETED,""")
	stringer="""

        input [ADDR_WIDTH_DATA_BRAM-1:0] bram_ZYNQ_block_{0}_addr,
        input [31:0] bram_ZYNQ_block_{0}_din,
        output [31:0] bram_ZYNQ_block_{0}_dout,
        input bram_ZYNQ_block_{0}_en,
        input [3:0] bram_ZYNQ_block_{0}_we,
    
    """
	for idx in range(65, 65 + NUM_BRAM):
		vhdFile.write(stringer.format(chr(idx)))
	vhdFile.write("""
        input [31:0]bram_ZYNQ_INST_addr,
        input bram_ZYNQ_INST_en,
        input bram_ZYNQ_INST_we,
    """)
	stringer="""
        input [31:0] bram_ZYNQ_INST_din_part_{0},"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)):
	    vhdFile.write(stringer.format(idx))
	stringer="""

        output [31:0] bram_ZYNQ_INST_dout_part_{0},"""
	vhdFile.write("""
    	""")
	for idx in range(math.ceil(CTRL_WIDTH/32.0)):
	    vhdFile.write(stringer.format(idx))
	vhdFile.write("""


        //debug signals
        output [1:0] debug_state
    );

    wire [CTRL_WIDTH-1:0] ctrl_signal; 
    
    //Instruction memory
    """)
	stringer="""
    wire [{0}:0] bram_ZYNQ_INST_din; 
    wire [{0}:0] bram_ZYNQ_INST_dout;
    
    assign bram_ZYNQ_INST_din ={{
"""
	vhdFile.write(stringer.format(32*(math.ceil(CTRL_WIDTH/32.0))-1))
	stringer="""bram_ZYNQ_INST_din_part_{0}"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)-1,-1,-1):
	    vhdFile.write(stringer.format(idx))
	    if idx != 0:
	        vhdFile.write(""" , """)
	vhdFile.write("""};
	""")
	stringer="""
    assign bram_ZYNQ_INST_dout_part_{0} = bram_ZYNQ_INST_dout[{1} : {2}];"""
	for idx in range(math.ceil(CTRL_WIDTH/32.0)-1):
	    vhdFile.write(stringer.format(idx,(idx+1)*32-1,idx*32))
	stringer="""
    assign bram_ZYNQ_INST_dout_part_{0} = {{ {3}'b{2} , bram_ZYNQ_INST_dout[CTRL_WIDTH-1 : {1}]}};
	"""
	vhdFile.write(stringer.format((idx+1),(idx+1)*32,((str(0))) *(32*math.ceil(CTRL_WIDTH/32.0)- CTRL_WIDTH),(32*math.ceil(CTRL_WIDTH/32.0)- CTRL_WIDTH)))

	vhdFile.write("""    
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
        CLK_100,""")
	if NUM_PORT==4:
	    vhdFile.write("""CLK_200,
	    """)
	vhdFile.write("""
		locked,
        ctrl_signal,
        
    """)
	stringer="""
		bram_ZYNQ_block_{0}_addr[ADDR_WIDTH_DATA_BRAM - 1 : 0],
        bram_ZYNQ_block_{0}_din,
        bram_ZYNQ_block_{0}_dout,
        bram_ZYNQ_block_{0}_en,
        bram_ZYNQ_block_{0}_we[0],
    """
	for idx in range(65, 65 + NUM_BRAM):
	    vhdFile.write(stringer.format(chr(idx)))
	vhdFile.write("""        
        START
    );

endmodule
    """)
	vhdFile.close()

def AXI_V() :
    vhdFile  = open("./autoFiles/VFile/myip_AXI_LUD.v", 'w')
    stringer="""

    module myip_AXI_LUD #
    (
        // Users to add parameters here
        ADDR_WIDTH = {0}, //Instruction BRAM
        ADDR_WIDTH_DATA_BRAM = {1},
        CTRL_WIDTH = {2},
        AU_SEL_WIDTH = {3},
        BRAM_SEL_WIDTH = {4},
        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH = 32,
        C_S_AXI_ADDR_WIDTH = 9
    )
    (
        // Users to add ports here
    input wire clk_1x,
        """
    vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,math.ceil(math.log2(4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0))+1)))
    if NUM_PORT==4:
        vhdFile.write("""input wire clk_2x,
""")
    vhdFile.write("""
        // User ports ends
        // Do not modify the ports beyond this line

        // Global Clock Signal
        input wire  S_AXI_ACLK,
        // Global Reset Signal. This Signal is Active LOW
        input wire  S_AXI_ARESETN,
        // Write address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
        // Write channel Protection type. This signal indicates the
            // privilege and security level of the transaction, and whether
            // the transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_AWPROT,
        // Write address valid. This signal indicates that the master signaling
            // valid write address and control information.
        input wire  S_AXI_AWVALID,
        // Write address ready. This signal indicates that the slave is ready
            // to accept an address and associated control signals.
        output wire  S_AXI_AWREADY,
        // Write data (issued by master, acceped by Slave) 
        input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
        // Write strobes. This signal indicates which byte lanes hold
            // valid data. There is one write strobe bit for each eight
            // bits of the write data bus.    
        input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
        // Write valid. This signal indicates that valid write
            // data and strobes are available.
        input wire  S_AXI_WVALID,
        // Write ready. This signal indicates that the slave
            // can accept the write data.
        output wire  S_AXI_WREADY,
        // Write response. This signal indicates the status
            // of the write transaction.
        output wire [1 : 0] S_AXI_BRESP,
        // Write response valid. This signal indicates that the channel
            // is signaling a valid write response.
        output wire  S_AXI_BVALID,
        // Response ready. This signal indicates that the master
            // can accept a write response.
        input wire  S_AXI_BREADY,
        // Read address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
        // Protection type. This signal indicates the privilege
            // and security level of the transaction, and whether the
            // transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_ARPROT,
        // Read address valid. This signal indicates that the channel
            // is signaling valid read address and control information.
        input wire  S_AXI_ARVALID,
        // Read address ready. This signal indicates that the slave is
            // ready to accept an address and associated control signals.
        output wire  S_AXI_ARREADY,
        // Read data (issued by slave)
        output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
        // Read response. This signal indicates the status of the
            // read transfer.
        output wire [1 : 0] S_AXI_RRESP,
        // Read valid. This signal indicates that the channel is
            // signaling the required read data.
        output wire  S_AXI_RVALID,
        // Read ready. This signal indicates that the master can
            // accept the read data and response information.
        input wire  S_AXI_RREADY
    );

    // AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_awaddr;
    reg     axi_awready;
    reg     axi_wready;
    reg [1 : 0]     axi_bresp;
    reg     axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_araddr;
    reg     axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0]  axi_rdata;
    reg [1 : 0]     axi_rresp;
    reg     axi_rvalid;

    // Example-specific design signals
    // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    // ADDR_LSB is used for addressing 32/64 bit registers/memories
    // ADDR_LSB = 2 for 32 bits (n downto 2)
    // ADDR_LSB = 3 for 64 bits (n downto 3)
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 6;
    //----------------------------------------------
    //-- Signals for user logic register space example
    //------------------------------------------------
    //-- Number of Slave Registers 128
""")
    stringer="""
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg{0};"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
    wire     slv_reg_rden;
    wire     slv_reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;
    integer  byte_index;
    reg  aw_en;
    
	
    //User Definnd Output Signals  
    """)
    stringer="""
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg{0}_out;"""
    L=list([3])
    L+=list(range(4+2*NUM_BRAM,4+3*NUM_BRAM))
    L+=list(range(4+5*NUM_BRAM+3+math.ceil(CTRL_WIDTH/32.0),4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0)+1))
    for i in L:
        ##print(i)
        vhdFile.write(stringer.format(i))
    vhdFile.write("""

    // I/O Connections assignments

    assign S_AXI_AWREADY    = axi_awready;
    assign S_AXI_WREADY = axi_wready;
    assign S_AXI_BRESP  = axi_bresp;
    assign S_AXI_BVALID = axi_bvalid;
    assign S_AXI_ARREADY    = axi_arready;
    assign S_AXI_RDATA  = axi_rdata;
    assign S_AXI_RRESP  = axi_rresp;
    assign S_AXI_RVALID = axi_rvalid;
    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awready <= 1'b0;
          aw_en <= 1'b1;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // slave is ready to accept write address when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_awready <= 1'b1;
              aw_en <= 1'b0;
            end
            else if (S_AXI_BREADY && axi_bvalid)
                begin
                  aw_en <= 1'b1;
                  axi_awready <= 1'b0;
                end
          else           
            begin
              axi_awready <= 1'b0;
            end
        end 
    end       

    // Implement axi_awaddr latching
    // This process is used to latch the address when both 
    // S_AXI_AWVALID and S_AXI_WVALID are valid. 

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awaddr <= 0;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // Write Address latching 
              axi_awaddr <= S_AXI_AWADDR;
            end
        end 
    end       

    // Implement axi_wready generation
    // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    // de-asserted when reset is low. 

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_wready <= 1'b0;
        end 
      else
        begin    
          if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
            begin
              // slave is ready to accept write data when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_wready <= 1'b1;
            end
          else
            begin
              axi_wready <= 1'b0;
            end
        end 
    end       

    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
	


    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
    """)
    stringer="""
    slv_reg{0} <= 0;"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
        end 
      else begin
        if (slv_reg_wren)
          begin
            case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )""")
    stringer="""
              7'd{0}:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register {0}
                    slv_reg{0}[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  """
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
		default: begin""")
    stringer="""
    	            slv_reg{0} <= slv_reg{0};"""
    for i in range(128):
        vhdFile.write(stringer.format(i))
    vhdFile.write("""
                        end
            endcase
          end
      end
    end 


    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave 
    // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    // This marks the acceptance of address and indicates the status of 
    // write transaction.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_bvalid  <= 0;
          axi_bresp   <= 2'b0;
        end 
      else
        begin    
          if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
            begin
              // indicates a valid write response is available
              axi_bvalid <= 1'b1;
              axi_bresp  <= 2'b0; // 'OKAY' response 
            end                   // work error responses in future
          else
            begin
              if (S_AXI_BREADY && axi_bvalid) 
                //check if bready is asserted while bvalid is high) 
                //(there is a possibility that bready is always asserted high)   
                begin
                  axi_bvalid <= 1'b0; 
                end  
            end
        end
    end   

    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXI_ACLK clock cycle when
    // S_AXI_ARVALID is asserted. axi_awready is 
    // de-asserted when reset (active low) is asserted. 
    // The read address is also latched when S_AXI_ARVALID is 
    // asserted. axi_araddr is reset to zero on reset assertion.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_arready <= 1'b0;
          axi_araddr  <= 32'b0;
        end 
      else
        begin    
          if (~axi_arready && S_AXI_ARVALID)
            begin
              // indicates that the slave has acceped the valid read address
              axi_arready <= 1'b1;
              // Read address latching
              axi_araddr  <= S_AXI_ARADDR;
            end
          else
            begin
              axi_arready <= 1'b0;
            end
        end 
    end       

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    // data are available on the axi_rdata bus at this instance. The 
    // assertion of axi_rvalid marks the validity of read data on the 
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    // is deasserted on reset (active low). axi_rresp and axi_rdata are 
    // cleared to zero on reset (active low).  
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rvalid <= 0;
          axi_rresp  <= 0;
        end 
      else
        begin    
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
              // Valid read data is available at the read data bus
              axi_rvalid <= 1'b1;
              axi_rresp  <= 2'b0; // 'OKAY' response
            end   
          else if (axi_rvalid && S_AXI_RREADY)
            begin
              // Read data is accepted by the master
              axi_rvalid <= 1'b0;
            end                
        end
    end    

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    always @(*)
    begin
          // Address decoding for reading 
          case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
    """)
#    stringer="""slv_reg{0},"""
#    for i in range(128):
#        vhdFile.write(stringer.format(i))
#    stringer="""slv_reg{0}_out,"""
#    for i in L:
#        vhdFile.write(stringer.format(i))
#    vhdFile.write(""" axi_araddr, S_AXI_ARESETN, slv_reg_rden)
#	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);	
#    begin
#	    -- Address decoding for reading registers
#	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
#	    case loc_addr is
#""")
    S0="""
    7'd{0} : reg_data_out <= slv_reg{0};"""
    S1="""
    7'd{0} : reg_data_out <= slv_reg{0}_out;"""
#format(5,'b').zfill(5)
    for i in range(128):
        if i in L:
            vhdFile.write(S1.format(i))
        else :
            vhdFile.write(S0.format(i))
    vhdFile.write("""
               default : reg_data_out <= 0;
          endcase
    end

    // Output register or memory read data
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rdata  <= 0;
        end 
      else
        begin    
          // When there is a valid read address (S_AXI_ARVALID) with 
          // acceptance of read address by the slave (axi_arready), 
          // output the read dada 
          if (slv_reg_rden)
            begin
              axi_rdata <= reg_data_out;     // register read data
            end   
        end
    end    

    // Add user logic here
    LUDH_TEST_WRAPPER #(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH) HARDware 
    (
    clk_1x,""")
    if NUM_PORT==4:
        vhdFile.write("""
        clk_2x,
        """)
    vhdFile.write("""
            slv_reg0[0],
            slv_reg1[0],
            slv_reg2[0],
            slv_reg3_out[0], // output
    """)
    stringer="""
            slv_reg{0}[ADDR_WIDTH_DATA_BRAM - 1 : 0],
            slv_reg{1}[31:0],
            slv_reg{2}_out[31:0], //output
            slv_reg{3}[0],
            slv_reg{4}[3:0],
            """
    for i in range(NUM_BRAM):
        vhdFile.write(stringer.format(i+4,i+4+NUM_BRAM,i+4+2*NUM_BRAM,i+4+3*NUM_BRAM,i+4+4*NUM_BRAM))
    stringer="""
            
            
            slv_reg{0},
            slv_reg{1}[0],
            slv_reg{2}[0],
            
    """
    vhdFile.write(stringer.format(NUM_BRAM+4+4*NUM_BRAM,NUM_BRAM+4+4*NUM_BRAM+1,NUM_BRAM+4+4*NUM_BRAM+2));
    stringer="""
            slv_reg{1},"""
    for i in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(i,i+4+NUM_BRAM*5+3))
    vhdFile.write("""
    """)
    stringer="""
            slv_reg{1}_out,"""
    for i in range(math.ceil(CTRL_WIDTH/32.0)):
        vhdFile.write(stringer.format(i,i+4+NUM_BRAM*5+3+math.ceil(CTRL_WIDTH/32.0)))
    vhdFile.write("""
            
            //debug signals""")
    stringer="""
    slv_reg{0}_out[1:0]"""
    vhdFile.write(stringer.format(4+NUM_BRAM*5+3+2*math.ceil(CTRL_WIDTH/32.0)))
    vhdFile.write("""
        );

	// User logic ends
endmodule    
    """)
    vhdFile.close()
    vhdFile  = open("./autoFiles/VFile/myip_AXI_LUD_wrapper.v", 'w')
    stringer="""
    module myip_AXI_LUD_wrapper #
    (
        // Users to add parameters here
        ADDR_WIDTH = {0}, //Instruction BRAM
        ADDR_WIDTH_DATA_BRAM = {1},
        CTRL_WIDTH = {2},
        AU_SEL_WIDTH = {3},
        BRAM_SEL_WIDTH = {4},
        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH = 32,
        C_S_AXI_ADDR_WIDTH = 9
    )
    (
        // Users to add ports here
        input wire clk_1x,
        """
    vhdFile.write(stringer.format(ADDR_WIDTH,ADDR_WIDTH_DATA_BRAM,CTRL_WIDTH,AU_SEL_WIDTH,BRAM_SEL_WIDTH,math.ceil(math.log2(4+5*NUM_BRAM+3+2*math.ceil(CTRL_WIDTH/32.0))+1)))
    if NUM_PORT==4:
        vhdFile.write("""input wire clk_2x,
""")
    vhdFile.write("""
        input wire  s00_axi_aclk,
        input wire  s00_axi_aresetn,
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
        input wire [2 : 0] s00_axi_awprot,
        input wire  s00_axi_awvalid,
        output wire  s00_axi_awready,
        input wire [C_S_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
        input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
        input wire  s00_axi_wvalid,
        output wire  s00_axi_wready,
        output wire [1 : 0] s00_axi_bresp,
        output wire  s00_axi_bvalid,
        input wire  s00_axi_bready,
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
        input wire [2 : 0] s00_axi_arprot,
        input wire  s00_axi_arvalid,
        output wire  s00_axi_arready,
        output wire [C_S_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
        output wire [1 : 0] s00_axi_rresp,
        output wire  s00_axi_rvalid,
        input wire  s00_axi_rready
    );
// Instantiation of Axi Bus Interface S00_AXI
    myip_AXI_LUD # ( 
        .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
    ) my_AXI_LUD_Verilog_v1_0_S00_AXI_inst (
	    .clk_1x(clk_1x),
""")
    if NUM_PORT==4:
        vhdFile.write(""".clk_2x(clk_2x),
""")
    vhdFile.write("""
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWPROT(s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WSTRB(s00_axi_wstrb),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready)
    );

    // Add user logic here

    // User logic ends

    endmodule""")


if __name__ == "__main__":
    os.makedirs("./autoFiles/VFile", exist_ok=True)
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
hardwareMUX_verilog()
hardwareTester_verilog()
LUDHardware_verilog()
hardwareTesterWrapper_verilog()
AXI_V()
