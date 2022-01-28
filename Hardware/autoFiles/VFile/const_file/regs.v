module myReg #(DATA_WIDTH=24) (CLK,ARST,ENA,DIN,DOUT);
    input CLK ;
    input ARST;
    input ENA;
    input [DATA_WIDTH-1:0]DIN;
    output reg [DATA_WIDTH-1:0]DOUT;

    always @(posedge(CLK),posedge(ARST))
        begin
            if(ARST)
                DOUT <= {DATA_WIDTH{1'b0}};
            else
                if(ENA)
                    DOUT <= DIN;
        end
endmodule


module myRegS #(DATA_WIDTH=24)(CLK,SRST,ENA,DIN,DOUT);
    input CLK ;
    input SRST;
    input ENA;
    input [DATA_WIDTH-1:0]DIN;
    output reg [DATA_WIDTH-1:0]DOUT;

    always @(posedge(CLK))
        begin
        if(ENA)
            begin
            if(SRST)
                DOUT<={DATA_WIDTH{1'b0}};
            else
                DOUT<=DIN;
            end
        end
endmodule 


module myReg_single_bit #(parameter DATA_WIDTH=24) (CLK,ARST,ENA,DIN,DOUT);
    input CLK ;
    input ARST;
    input ENA;
    input DIN;
    output reg DOUT;

    always @(posedge(CLK),posedge(ARST))
        begin
            if(ARST)
                DOUT <= {DATA_WIDTH{1'b0}};
            else
                if(ENA)
                    DOUT <= DIN;
        end
endmodule

module myLatch #(parameter DATA_WIDTH=24) (ARST,ENA,DIN,DOUT);
    input ARST;
    input ENA;
    input DIN;
    output reg DOUT;

    always @(ARST,ENA)
        begin
            if(ARST)
                DOUT <= {DATA_WIDTH{1'b0}};
            else
                if(ENA)
                    DOUT <= DIN;
        end
endmodule