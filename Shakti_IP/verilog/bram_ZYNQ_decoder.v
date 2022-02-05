module bram_ZYNQ_decoder #(width=32)(decoder_in,
      decoder_out_0,
      decoder_out_1,
      sel );

      input [width-1:0]decoder_in;
      output  [width-1:0]decoder_out_0;
      output [width-1:0]decoder_out_1;
      input sel;
      assign  decoder_out_0 = !sel ? decoder_in : {width{1'b0}};
      assign  decoder_out_1 =  sel ? decoder_in : {width{1'b0}};

endmodule