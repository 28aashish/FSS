

    module myip_AXI_LUD #
    (
        // Users to add parameters here
        ADDR_WIDTH = 12, //Instruction BRAM
        ADDR_WIDTH_DATA_BRAM = 10,
        CTRL_WIDTH = 307,
        AU_SEL_WIDTH = 5,
        BRAM_SEL_WIDTH = 5,
        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Slave Bus Interface S00_AXI
        C_S_AXI_DATA_WIDTH = 32,
        C_S_AXI_ADDR_WIDTH = 9
    )
    (
        // Users to add ports here
    input wire clk_1x,
        input wire clk_2x,

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

    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg0;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg1;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg2;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg3;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg4;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg5;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg6;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg7;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg8;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg9;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg10;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg11;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg12;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg13;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg14;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg15;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg16;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg17;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg18;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg19;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg20;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg21;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg22;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg23;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg24;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg25;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg26;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg27;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg28;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg29;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg30;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg31;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg32;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg33;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg34;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg35;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg36;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg37;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg38;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg39;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg40;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg41;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg42;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg43;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg44;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg45;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg46;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg47;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg48;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg49;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg50;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg51;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg52;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg53;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg54;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg55;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg56;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg57;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg58;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg59;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg60;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg61;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg62;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg63;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg64;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg65;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg66;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg67;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg68;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg69;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg70;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg71;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg72;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg73;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg74;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg75;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg76;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg77;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg78;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg79;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg80;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg81;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg82;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg83;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg84;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg85;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg86;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg87;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg88;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg89;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg90;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg91;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg92;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg93;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg94;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg95;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg96;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg97;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg98;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg99;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg100;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg101;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg102;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg103;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg104;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg105;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg106;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg107;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg108;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg109;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg110;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg111;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg112;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg113;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg114;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg115;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg116;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg117;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg118;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg119;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg120;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg121;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg122;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg123;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg124;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg125;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg126;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg127;
    wire     slv_reg_rden;
    wire     slv_reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;
    integer  byte_index;
    reg  aw_en;
    
	
    //User Definnd Output Signals  
    
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg3_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg12_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg13_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg14_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg15_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg37_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg38_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg39_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg40_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg41_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg42_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg43_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg44_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg45_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg46_out;
    wire [C_S_AXI_DATA_WIDTH-1 : 0] slv_reg47_out;

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
    
    slv_reg0 <= 0;
    slv_reg1 <= 0;
    slv_reg2 <= 0;
    slv_reg3 <= 0;
    slv_reg4 <= 0;
    slv_reg5 <= 0;
    slv_reg6 <= 0;
    slv_reg7 <= 0;
    slv_reg8 <= 0;
    slv_reg9 <= 0;
    slv_reg10 <= 0;
    slv_reg11 <= 0;
    slv_reg12 <= 0;
    slv_reg13 <= 0;
    slv_reg14 <= 0;
    slv_reg15 <= 0;
    slv_reg16 <= 0;
    slv_reg17 <= 0;
    slv_reg18 <= 0;
    slv_reg19 <= 0;
    slv_reg20 <= 0;
    slv_reg21 <= 0;
    slv_reg22 <= 0;
    slv_reg23 <= 0;
    slv_reg24 <= 0;
    slv_reg25 <= 0;
    slv_reg26 <= 0;
    slv_reg27 <= 0;
    slv_reg28 <= 0;
    slv_reg29 <= 0;
    slv_reg30 <= 0;
    slv_reg31 <= 0;
    slv_reg32 <= 0;
    slv_reg33 <= 0;
    slv_reg34 <= 0;
    slv_reg35 <= 0;
    slv_reg36 <= 0;
    slv_reg37 <= 0;
    slv_reg38 <= 0;
    slv_reg39 <= 0;
    slv_reg40 <= 0;
    slv_reg41 <= 0;
    slv_reg42 <= 0;
    slv_reg43 <= 0;
    slv_reg44 <= 0;
    slv_reg45 <= 0;
    slv_reg46 <= 0;
    slv_reg47 <= 0;
    slv_reg48 <= 0;
    slv_reg49 <= 0;
    slv_reg50 <= 0;
    slv_reg51 <= 0;
    slv_reg52 <= 0;
    slv_reg53 <= 0;
    slv_reg54 <= 0;
    slv_reg55 <= 0;
    slv_reg56 <= 0;
    slv_reg57 <= 0;
    slv_reg58 <= 0;
    slv_reg59 <= 0;
    slv_reg60 <= 0;
    slv_reg61 <= 0;
    slv_reg62 <= 0;
    slv_reg63 <= 0;
    slv_reg64 <= 0;
    slv_reg65 <= 0;
    slv_reg66 <= 0;
    slv_reg67 <= 0;
    slv_reg68 <= 0;
    slv_reg69 <= 0;
    slv_reg70 <= 0;
    slv_reg71 <= 0;
    slv_reg72 <= 0;
    slv_reg73 <= 0;
    slv_reg74 <= 0;
    slv_reg75 <= 0;
    slv_reg76 <= 0;
    slv_reg77 <= 0;
    slv_reg78 <= 0;
    slv_reg79 <= 0;
    slv_reg80 <= 0;
    slv_reg81 <= 0;
    slv_reg82 <= 0;
    slv_reg83 <= 0;
    slv_reg84 <= 0;
    slv_reg85 <= 0;
    slv_reg86 <= 0;
    slv_reg87 <= 0;
    slv_reg88 <= 0;
    slv_reg89 <= 0;
    slv_reg90 <= 0;
    slv_reg91 <= 0;
    slv_reg92 <= 0;
    slv_reg93 <= 0;
    slv_reg94 <= 0;
    slv_reg95 <= 0;
    slv_reg96 <= 0;
    slv_reg97 <= 0;
    slv_reg98 <= 0;
    slv_reg99 <= 0;
    slv_reg100 <= 0;
    slv_reg101 <= 0;
    slv_reg102 <= 0;
    slv_reg103 <= 0;
    slv_reg104 <= 0;
    slv_reg105 <= 0;
    slv_reg106 <= 0;
    slv_reg107 <= 0;
    slv_reg108 <= 0;
    slv_reg109 <= 0;
    slv_reg110 <= 0;
    slv_reg111 <= 0;
    slv_reg112 <= 0;
    slv_reg113 <= 0;
    slv_reg114 <= 0;
    slv_reg115 <= 0;
    slv_reg116 <= 0;
    slv_reg117 <= 0;
    slv_reg118 <= 0;
    slv_reg119 <= 0;
    slv_reg120 <= 0;
    slv_reg121 <= 0;
    slv_reg122 <= 0;
    slv_reg123 <= 0;
    slv_reg124 <= 0;
    slv_reg125 <= 0;
    slv_reg126 <= 0;
    slv_reg127 <= 0;
        end 
      else begin
        if (slv_reg_wren)
          begin
            case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
              7'd0:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 0
                    slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd1:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 1
                    slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd2:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 2
                    slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd3:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 3
                    slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd4:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 4
                    slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd5:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 5
                    slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd6:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 6
                    slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd7:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 7
                    slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd8:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 8
                    slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd9:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 9
                    slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd10:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 10
                    slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd11:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 11
                    slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd12:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 12
                    slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd13:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 13
                    slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd14:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 14
                    slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd15:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 15
                    slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd16:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 16
                    slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd17:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 17
                    slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd18:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 18
                    slv_reg18[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd19:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 19
                    slv_reg19[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd20:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 20
                    slv_reg20[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd21:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 21
                    slv_reg21[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd22:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 22
                    slv_reg22[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd23:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 23
                    slv_reg23[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd24:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 24
                    slv_reg24[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd25:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 25
                    slv_reg25[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd26:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 26
                    slv_reg26[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd27:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 27
                    slv_reg27[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd28:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 28
                    slv_reg28[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd29:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 29
                    slv_reg29[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd30:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 30
                    slv_reg30[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd31:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 31
                    slv_reg31[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd32:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 32
                    slv_reg32[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd33:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 33
                    slv_reg33[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd34:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 34
                    slv_reg34[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd35:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 35
                    slv_reg35[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd36:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 36
                    slv_reg36[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd37:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 37
                    slv_reg37[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd38:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 38
                    slv_reg38[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd39:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 39
                    slv_reg39[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd40:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 40
                    slv_reg40[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd41:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 41
                    slv_reg41[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd42:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 42
                    slv_reg42[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd43:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 43
                    slv_reg43[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd44:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 44
                    slv_reg44[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd45:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 45
                    slv_reg45[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd46:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 46
                    slv_reg46[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd47:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 47
                    slv_reg47[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd48:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 48
                    slv_reg48[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd49:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 49
                    slv_reg49[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd50:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 50
                    slv_reg50[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd51:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 51
                    slv_reg51[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd52:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 52
                    slv_reg52[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd53:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 53
                    slv_reg53[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd54:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 54
                    slv_reg54[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd55:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 55
                    slv_reg55[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd56:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 56
                    slv_reg56[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd57:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 57
                    slv_reg57[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd58:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 58
                    slv_reg58[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd59:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 59
                    slv_reg59[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd60:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 60
                    slv_reg60[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd61:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 61
                    slv_reg61[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd62:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 62
                    slv_reg62[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd63:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 63
                    slv_reg63[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd64:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 64
                    slv_reg64[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd65:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 65
                    slv_reg65[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd66:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 66
                    slv_reg66[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd67:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 67
                    slv_reg67[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd68:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 68
                    slv_reg68[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd69:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 69
                    slv_reg69[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd70:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 70
                    slv_reg70[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd71:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 71
                    slv_reg71[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd72:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 72
                    slv_reg72[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd73:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 73
                    slv_reg73[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd74:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 74
                    slv_reg74[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd75:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 75
                    slv_reg75[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd76:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 76
                    slv_reg76[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd77:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 77
                    slv_reg77[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd78:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 78
                    slv_reg78[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd79:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 79
                    slv_reg79[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd80:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 80
                    slv_reg80[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd81:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 81
                    slv_reg81[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd82:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 82
                    slv_reg82[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd83:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 83
                    slv_reg83[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd84:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 84
                    slv_reg84[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd85:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 85
                    slv_reg85[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd86:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 86
                    slv_reg86[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd87:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 87
                    slv_reg87[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd88:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 88
                    slv_reg88[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd89:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 89
                    slv_reg89[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd90:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 90
                    slv_reg90[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd91:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 91
                    slv_reg91[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd92:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 92
                    slv_reg92[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd93:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 93
                    slv_reg93[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd94:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 94
                    slv_reg94[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd95:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 95
                    slv_reg95[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd96:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 96
                    slv_reg96[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd97:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 97
                    slv_reg97[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd98:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 98
                    slv_reg98[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd99:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 99
                    slv_reg99[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd100:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 100
                    slv_reg100[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd101:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 101
                    slv_reg101[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd102:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 102
                    slv_reg102[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd103:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 103
                    slv_reg103[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd104:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 104
                    slv_reg104[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd105:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 105
                    slv_reg105[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd106:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 106
                    slv_reg106[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd107:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 107
                    slv_reg107[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd108:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 108
                    slv_reg108[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd109:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 109
                    slv_reg109[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd110:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 110
                    slv_reg110[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd111:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 111
                    slv_reg111[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd112:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 112
                    slv_reg112[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd113:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 113
                    slv_reg113[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd114:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 114
                    slv_reg114[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd115:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 115
                    slv_reg115[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd116:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 116
                    slv_reg116[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd117:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 117
                    slv_reg117[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd118:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 118
                    slv_reg118[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd119:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 119
                    slv_reg119[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd120:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 120
                    slv_reg120[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd121:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 121
                    slv_reg121[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd122:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 122
                    slv_reg122[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd123:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 123
                    slv_reg123[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd124:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 124
                    slv_reg124[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd125:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 125
                    slv_reg125[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd126:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 126
                    slv_reg126[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              7'd127:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 127
                    slv_reg127[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
		default: begin
    	            slv_reg0 <= slv_reg0;
    	            slv_reg1 <= slv_reg1;
    	            slv_reg2 <= slv_reg2;
    	            slv_reg3 <= slv_reg3;
    	            slv_reg4 <= slv_reg4;
    	            slv_reg5 <= slv_reg5;
    	            slv_reg6 <= slv_reg6;
    	            slv_reg7 <= slv_reg7;
    	            slv_reg8 <= slv_reg8;
    	            slv_reg9 <= slv_reg9;
    	            slv_reg10 <= slv_reg10;
    	            slv_reg11 <= slv_reg11;
    	            slv_reg12 <= slv_reg12;
    	            slv_reg13 <= slv_reg13;
    	            slv_reg14 <= slv_reg14;
    	            slv_reg15 <= slv_reg15;
    	            slv_reg16 <= slv_reg16;
    	            slv_reg17 <= slv_reg17;
    	            slv_reg18 <= slv_reg18;
    	            slv_reg19 <= slv_reg19;
    	            slv_reg20 <= slv_reg20;
    	            slv_reg21 <= slv_reg21;
    	            slv_reg22 <= slv_reg22;
    	            slv_reg23 <= slv_reg23;
    	            slv_reg24 <= slv_reg24;
    	            slv_reg25 <= slv_reg25;
    	            slv_reg26 <= slv_reg26;
    	            slv_reg27 <= slv_reg27;
    	            slv_reg28 <= slv_reg28;
    	            slv_reg29 <= slv_reg29;
    	            slv_reg30 <= slv_reg30;
    	            slv_reg31 <= slv_reg31;
    	            slv_reg32 <= slv_reg32;
    	            slv_reg33 <= slv_reg33;
    	            slv_reg34 <= slv_reg34;
    	            slv_reg35 <= slv_reg35;
    	            slv_reg36 <= slv_reg36;
    	            slv_reg37 <= slv_reg37;
    	            slv_reg38 <= slv_reg38;
    	            slv_reg39 <= slv_reg39;
    	            slv_reg40 <= slv_reg40;
    	            slv_reg41 <= slv_reg41;
    	            slv_reg42 <= slv_reg42;
    	            slv_reg43 <= slv_reg43;
    	            slv_reg44 <= slv_reg44;
    	            slv_reg45 <= slv_reg45;
    	            slv_reg46 <= slv_reg46;
    	            slv_reg47 <= slv_reg47;
    	            slv_reg48 <= slv_reg48;
    	            slv_reg49 <= slv_reg49;
    	            slv_reg50 <= slv_reg50;
    	            slv_reg51 <= slv_reg51;
    	            slv_reg52 <= slv_reg52;
    	            slv_reg53 <= slv_reg53;
    	            slv_reg54 <= slv_reg54;
    	            slv_reg55 <= slv_reg55;
    	            slv_reg56 <= slv_reg56;
    	            slv_reg57 <= slv_reg57;
    	            slv_reg58 <= slv_reg58;
    	            slv_reg59 <= slv_reg59;
    	            slv_reg60 <= slv_reg60;
    	            slv_reg61 <= slv_reg61;
    	            slv_reg62 <= slv_reg62;
    	            slv_reg63 <= slv_reg63;
    	            slv_reg64 <= slv_reg64;
    	            slv_reg65 <= slv_reg65;
    	            slv_reg66 <= slv_reg66;
    	            slv_reg67 <= slv_reg67;
    	            slv_reg68 <= slv_reg68;
    	            slv_reg69 <= slv_reg69;
    	            slv_reg70 <= slv_reg70;
    	            slv_reg71 <= slv_reg71;
    	            slv_reg72 <= slv_reg72;
    	            slv_reg73 <= slv_reg73;
    	            slv_reg74 <= slv_reg74;
    	            slv_reg75 <= slv_reg75;
    	            slv_reg76 <= slv_reg76;
    	            slv_reg77 <= slv_reg77;
    	            slv_reg78 <= slv_reg78;
    	            slv_reg79 <= slv_reg79;
    	            slv_reg80 <= slv_reg80;
    	            slv_reg81 <= slv_reg81;
    	            slv_reg82 <= slv_reg82;
    	            slv_reg83 <= slv_reg83;
    	            slv_reg84 <= slv_reg84;
    	            slv_reg85 <= slv_reg85;
    	            slv_reg86 <= slv_reg86;
    	            slv_reg87 <= slv_reg87;
    	            slv_reg88 <= slv_reg88;
    	            slv_reg89 <= slv_reg89;
    	            slv_reg90 <= slv_reg90;
    	            slv_reg91 <= slv_reg91;
    	            slv_reg92 <= slv_reg92;
    	            slv_reg93 <= slv_reg93;
    	            slv_reg94 <= slv_reg94;
    	            slv_reg95 <= slv_reg95;
    	            slv_reg96 <= slv_reg96;
    	            slv_reg97 <= slv_reg97;
    	            slv_reg98 <= slv_reg98;
    	            slv_reg99 <= slv_reg99;
    	            slv_reg100 <= slv_reg100;
    	            slv_reg101 <= slv_reg101;
    	            slv_reg102 <= slv_reg102;
    	            slv_reg103 <= slv_reg103;
    	            slv_reg104 <= slv_reg104;
    	            slv_reg105 <= slv_reg105;
    	            slv_reg106 <= slv_reg106;
    	            slv_reg107 <= slv_reg107;
    	            slv_reg108 <= slv_reg108;
    	            slv_reg109 <= slv_reg109;
    	            slv_reg110 <= slv_reg110;
    	            slv_reg111 <= slv_reg111;
    	            slv_reg112 <= slv_reg112;
    	            slv_reg113 <= slv_reg113;
    	            slv_reg114 <= slv_reg114;
    	            slv_reg115 <= slv_reg115;
    	            slv_reg116 <= slv_reg116;
    	            slv_reg117 <= slv_reg117;
    	            slv_reg118 <= slv_reg118;
    	            slv_reg119 <= slv_reg119;
    	            slv_reg120 <= slv_reg120;
    	            slv_reg121 <= slv_reg121;
    	            slv_reg122 <= slv_reg122;
    	            slv_reg123 <= slv_reg123;
    	            slv_reg124 <= slv_reg124;
    	            slv_reg125 <= slv_reg125;
    	            slv_reg126 <= slv_reg126;
    	            slv_reg127 <= slv_reg127;
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
    
    7'd0 : reg_data_out <= slv_reg0;
    7'd1 : reg_data_out <= slv_reg1;
    7'd2 : reg_data_out <= slv_reg2;
    7'd3 : reg_data_out <= slv_reg3_out;
    7'd4 : reg_data_out <= slv_reg4;
    7'd5 : reg_data_out <= slv_reg5;
    7'd6 : reg_data_out <= slv_reg6;
    7'd7 : reg_data_out <= slv_reg7;
    7'd8 : reg_data_out <= slv_reg8;
    7'd9 : reg_data_out <= slv_reg9;
    7'd10 : reg_data_out <= slv_reg10;
    7'd11 : reg_data_out <= slv_reg11;
    7'd12 : reg_data_out <= slv_reg12_out;
    7'd13 : reg_data_out <= slv_reg13_out;
    7'd14 : reg_data_out <= slv_reg14_out;
    7'd15 : reg_data_out <= slv_reg15_out;
    7'd16 : reg_data_out <= slv_reg16;
    7'd17 : reg_data_out <= slv_reg17;
    7'd18 : reg_data_out <= slv_reg18;
    7'd19 : reg_data_out <= slv_reg19;
    7'd20 : reg_data_out <= slv_reg20;
    7'd21 : reg_data_out <= slv_reg21;
    7'd22 : reg_data_out <= slv_reg22;
    7'd23 : reg_data_out <= slv_reg23;
    7'd24 : reg_data_out <= slv_reg24;
    7'd25 : reg_data_out <= slv_reg25;
    7'd26 : reg_data_out <= slv_reg26;
    7'd27 : reg_data_out <= slv_reg27;
    7'd28 : reg_data_out <= slv_reg28;
    7'd29 : reg_data_out <= slv_reg29;
    7'd30 : reg_data_out <= slv_reg30;
    7'd31 : reg_data_out <= slv_reg31;
    7'd32 : reg_data_out <= slv_reg32;
    7'd33 : reg_data_out <= slv_reg33;
    7'd34 : reg_data_out <= slv_reg34;
    7'd35 : reg_data_out <= slv_reg35;
    7'd36 : reg_data_out <= slv_reg36;
    7'd37 : reg_data_out <= slv_reg37_out;
    7'd38 : reg_data_out <= slv_reg38_out;
    7'd39 : reg_data_out <= slv_reg39_out;
    7'd40 : reg_data_out <= slv_reg40_out;
    7'd41 : reg_data_out <= slv_reg41_out;
    7'd42 : reg_data_out <= slv_reg42_out;
    7'd43 : reg_data_out <= slv_reg43_out;
    7'd44 : reg_data_out <= slv_reg44_out;
    7'd45 : reg_data_out <= slv_reg45_out;
    7'd46 : reg_data_out <= slv_reg46_out;
    7'd47 : reg_data_out <= slv_reg47_out;
    7'd48 : reg_data_out <= slv_reg48;
    7'd49 : reg_data_out <= slv_reg49;
    7'd50 : reg_data_out <= slv_reg50;
    7'd51 : reg_data_out <= slv_reg51;
    7'd52 : reg_data_out <= slv_reg52;
    7'd53 : reg_data_out <= slv_reg53;
    7'd54 : reg_data_out <= slv_reg54;
    7'd55 : reg_data_out <= slv_reg55;
    7'd56 : reg_data_out <= slv_reg56;
    7'd57 : reg_data_out <= slv_reg57;
    7'd58 : reg_data_out <= slv_reg58;
    7'd59 : reg_data_out <= slv_reg59;
    7'd60 : reg_data_out <= slv_reg60;
    7'd61 : reg_data_out <= slv_reg61;
    7'd62 : reg_data_out <= slv_reg62;
    7'd63 : reg_data_out <= slv_reg63;
    7'd64 : reg_data_out <= slv_reg64;
    7'd65 : reg_data_out <= slv_reg65;
    7'd66 : reg_data_out <= slv_reg66;
    7'd67 : reg_data_out <= slv_reg67;
    7'd68 : reg_data_out <= slv_reg68;
    7'd69 : reg_data_out <= slv_reg69;
    7'd70 : reg_data_out <= slv_reg70;
    7'd71 : reg_data_out <= slv_reg71;
    7'd72 : reg_data_out <= slv_reg72;
    7'd73 : reg_data_out <= slv_reg73;
    7'd74 : reg_data_out <= slv_reg74;
    7'd75 : reg_data_out <= slv_reg75;
    7'd76 : reg_data_out <= slv_reg76;
    7'd77 : reg_data_out <= slv_reg77;
    7'd78 : reg_data_out <= slv_reg78;
    7'd79 : reg_data_out <= slv_reg79;
    7'd80 : reg_data_out <= slv_reg80;
    7'd81 : reg_data_out <= slv_reg81;
    7'd82 : reg_data_out <= slv_reg82;
    7'd83 : reg_data_out <= slv_reg83;
    7'd84 : reg_data_out <= slv_reg84;
    7'd85 : reg_data_out <= slv_reg85;
    7'd86 : reg_data_out <= slv_reg86;
    7'd87 : reg_data_out <= slv_reg87;
    7'd88 : reg_data_out <= slv_reg88;
    7'd89 : reg_data_out <= slv_reg89;
    7'd90 : reg_data_out <= slv_reg90;
    7'd91 : reg_data_out <= slv_reg91;
    7'd92 : reg_data_out <= slv_reg92;
    7'd93 : reg_data_out <= slv_reg93;
    7'd94 : reg_data_out <= slv_reg94;
    7'd95 : reg_data_out <= slv_reg95;
    7'd96 : reg_data_out <= slv_reg96;
    7'd97 : reg_data_out <= slv_reg97;
    7'd98 : reg_data_out <= slv_reg98;
    7'd99 : reg_data_out <= slv_reg99;
    7'd100 : reg_data_out <= slv_reg100;
    7'd101 : reg_data_out <= slv_reg101;
    7'd102 : reg_data_out <= slv_reg102;
    7'd103 : reg_data_out <= slv_reg103;
    7'd104 : reg_data_out <= slv_reg104;
    7'd105 : reg_data_out <= slv_reg105;
    7'd106 : reg_data_out <= slv_reg106;
    7'd107 : reg_data_out <= slv_reg107;
    7'd108 : reg_data_out <= slv_reg108;
    7'd109 : reg_data_out <= slv_reg109;
    7'd110 : reg_data_out <= slv_reg110;
    7'd111 : reg_data_out <= slv_reg111;
    7'd112 : reg_data_out <= slv_reg112;
    7'd113 : reg_data_out <= slv_reg113;
    7'd114 : reg_data_out <= slv_reg114;
    7'd115 : reg_data_out <= slv_reg115;
    7'd116 : reg_data_out <= slv_reg116;
    7'd117 : reg_data_out <= slv_reg117;
    7'd118 : reg_data_out <= slv_reg118;
    7'd119 : reg_data_out <= slv_reg119;
    7'd120 : reg_data_out <= slv_reg120;
    7'd121 : reg_data_out <= slv_reg121;
    7'd122 : reg_data_out <= slv_reg122;
    7'd123 : reg_data_out <= slv_reg123;
    7'd124 : reg_data_out <= slv_reg124;
    7'd125 : reg_data_out <= slv_reg125;
    7'd126 : reg_data_out <= slv_reg126;
    7'd127 : reg_data_out <= slv_reg127;
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
    clk_1x,
        clk_2x,
        
            slv_reg0[0],
            slv_reg1[0],
            slv_reg2[0],
            slv_reg3_out[0], // output
    
            slv_reg4[ADDR_WIDTH_DATA_BRAM - 1 : 0],
            slv_reg8[31:0],
            slv_reg12_out[31:0], //output
            slv_reg16[0],
            slv_reg20[3:0],
            
            slv_reg5[ADDR_WIDTH_DATA_BRAM - 1 : 0],
            slv_reg9[31:0],
            slv_reg13_out[31:0], //output
            slv_reg17[0],
            slv_reg21[3:0],
            
            slv_reg6[ADDR_WIDTH_DATA_BRAM - 1 : 0],
            slv_reg10[31:0],
            slv_reg14_out[31:0], //output
            slv_reg18[0],
            slv_reg22[3:0],
            
            slv_reg7[ADDR_WIDTH_DATA_BRAM - 1 : 0],
            slv_reg11[31:0],
            slv_reg15_out[31:0], //output
            slv_reg19[0],
            slv_reg23[3:0],
            
            
            
            slv_reg24,
            slv_reg25[0],
            slv_reg26[0],
            
    
            slv_reg27,
            slv_reg28,
            slv_reg29,
            slv_reg30,
            slv_reg31,
            slv_reg32,
            slv_reg33,
            slv_reg34,
            slv_reg35,
            slv_reg36,
    
            slv_reg37_out,
            slv_reg38_out,
            slv_reg39_out,
            slv_reg40_out,
            slv_reg41_out,
            slv_reg42_out,
            slv_reg43_out,
            slv_reg44_out,
            slv_reg45_out,
            slv_reg46_out,
            
            //debug signals
    slv_reg47_out[1:0]
        );

	// User logic ends
endmodule    
    