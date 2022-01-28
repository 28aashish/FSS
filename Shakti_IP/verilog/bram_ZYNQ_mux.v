
module bram_ZYNQ_mux #(ADDR_WIDTH = 11) (bram_addr_0,
      bram_din_0,
      bram_en_0,
      bram_we_0,
      bram_addr_1,
      bram_din_1,
      bram_en_1,
      bram_we_1,
      bram_addr_out,
      bram_din_out,
      bram_en_out,
      bram_we_out,
      sel);


      input [ADDR_WIDTH-1:0]bram_addr_0;
      input [31:0]bram_din_0;
      input bram_en_0;
      input bram_we_0;
      input [ADDR_WIDTH-1:0]bram_addr_1;
      input [31:0]bram_din_1;
      input bram_en_1;
      input bram_we_1;
      output [ADDR_WIDTH-1:0]bram_addr_out;
      output [31:0]bram_din_out;
      output bram_en_out;
      output bram_we_out;
      input sel;

    assign bram_addr_out = !sel ? bram_addr_0 : bram_addr_1;
    assign bram_din_out = !sel ? bram_din_0 : bram_din_1;
    assign bram_en_out = !sel ? bram_en_0 : bram_en_1;
    assign bram_we_out = !sel ? bram_we_0 : bram_we_1;
            

endmodule