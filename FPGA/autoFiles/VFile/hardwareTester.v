module LUDH_TESTER #(ADDR_WIDTH = 12,
        CTRL_WIDTH = 72)
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
    .BRAM_PORTA_addr(muxout_addr) ,
    .BRAM_PORTA_clk(CLK_100),
    .BRAM_PORTA_din(muxout_din) ,
    .BRAM_PORTA_dout(decoder_input) ,
    .BRAM_PORTA_en(muxout_en) ,
    .BRAM_PORTA_we(muxout_we)
    );

    assign muxout_addr =!sync_start ? bram_ZYNQ_INST_addr :ctrl_addr;
    assign muxout_din =!sync_start ? bram_ZYNQ_INST_din :{ADDR_WIDTH{1'b0}};
    assign muxout_en =!sync_start ? bram_ZYNQ_INST_en :1;
    assign muxout_we =!sync_start ? bram_ZYNQ_INST_we :0;
    
    bram_ZYNQ_decoder #(CTRL_WIDTH) bram_ZYNQ_decoder_INST(
     decoder_input,
     bram_ZYNQ_INST_dout,
     CTRL_SIGNAL_temp,
     sync_start);

    
    assign CTRL_SIGNAL = !sync_start ? 0 :CTRL_SIGNAL_temp;

endmodule