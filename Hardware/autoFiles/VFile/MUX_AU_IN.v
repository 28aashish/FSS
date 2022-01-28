module MUX_AU_IN(
        SEL
    
        ,DIN0
        ,DIN1
        ,DIN2
        ,DIN3
        ,DIN4
        ,DIN5
        ,DIN6
        ,DIN7
        ,DIN8
        ,DIN9
        ,DIN10
        ,DIN11
        ,DIN12
        ,DIN13
        ,DIN14
        ,DIN15
        ,DIN16
        ,DIN17
        ,DIN18
        ,DIN19
        ,DIN20
            ,DOUT
    );
        input [5-1:0]SEL;
        input [31:0]DIN0,DIN1,DIN2,DIN3,DIN4,DIN5,DIN6,DIN7,DIN8,DIN9,DIN10,DIN11,DIN12,DIN13,DIN14,DIN15,DIN16,DIN17,DIN18,DIN19,DIN20;

    output reg [31:0]DOUT;

    always @(SEL,DIN0,DIN1,DIN2,DIN3,DIN4,DIN5,DIN6,DIN7,DIN8,DIN9,DIN10,DIN11,DIN12,DIN13,DIN14,DIN15,DIN16,DIN17,DIN18,DIN19,DIN20)
    begin
        case(SEL)
            5'd0:DOUT=DIN0;
            5'd1:DOUT=DIN1;
            5'd2:DOUT=DIN2;
            5'd3:DOUT=DIN3;
            5'd4:DOUT=DIN4;
            5'd5:DOUT=DIN5;
            5'd6:DOUT=DIN6;
            5'd7:DOUT=DIN7;
            5'd8:DOUT=DIN8;
            5'd9:DOUT=DIN9;
            5'd10:DOUT=DIN10;
            5'd11:DOUT=DIN11;
            5'd12:DOUT=DIN12;
            5'd13:DOUT=DIN13;
            5'd14:DOUT=DIN14;
            5'd15:DOUT=DIN15;
            5'd16:DOUT=DIN16;
            5'd17:DOUT=DIN17;
            5'd18:DOUT=DIN18;
            5'd19:DOUT=DIN19;
            5'd20:DOUT=DIN20;
            default:DOUT= {32{1'hx}};
        endcase
    end
endmodule        
        