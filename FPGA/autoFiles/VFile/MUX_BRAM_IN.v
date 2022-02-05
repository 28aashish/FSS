module MUX_BRAM_IN(
        SEL
        ,DIN0
        ,DIN1
        ,DIN2
        ,DIN3
        ,DIN4
        ,DIN5
            ,DOUT
    );
        input [3-1:0]SEL;
        input [31:0]DIN0,DIN1,DIN2,DIN3,DIN4,DIN5;

    output reg [31:0]DOUT;

    always @(SEL,DIN0,DIN1,DIN2,DIN3,DIN4,DIN5)
    begin
        case(SEL)
            3'd0:DOUT=DIN0;
            3'd1:DOUT=DIN1;
            3'd2:DOUT=DIN2;
            3'd3:DOUT=DIN3;
            3'd4:DOUT=DIN4;
            3'd5:DOUT=DIN5;
            default:DOUT= {32{1'hx}};
        endcase
    end
endmodule        
        