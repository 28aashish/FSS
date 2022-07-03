Steps to connect the Shakti IP

1. In Soc.defines files :-
  
@As the interface is Slave therfore 

`define Num_Slaves 7 => 'define Num_Slaves 8
  
@Define Number to the Slave 

`define MyNew_slave_num 7

@Under the Defining the Slave address Range(Just take a note of the allowable range of Memory address)

// below two lines are added
`define MyNewBase         'h0005_0000
`define MyNewBound        'h0005_FFFF

2. In Soc.bsv file:-

@ Under "function Bit#(TLog#(`Num_Slaves)) fn_slave_map (Bit#(`paddr) addr);"

    else if (addr >= `MyNewBase && addr <= `MyNewBound)
      slave_num = `MyNew_slave_num;

@ Under "interface Ifc_Soc;" before "interface IOCellSide iocell_io;"

    interface AXI4_Lite_Master_IFC#(`paddr, 32, 0) myip_AXI_LUD_wrapper_v1_0_master;

@ in mkSoc module : Below "interface mem_master = fabric.v_to_slaves [`Memory_slave_num];"
    
    interface myip_AXI_LUD_wrapper_v1_0_master = slow_fabric.v_to_slaves[`MyNew_slave_num];

3. Make genrate_verilog (this will create necessary tcl and Veilog file for Soc and will check BSV Compilation)

4. In fpga_top.v File

@Add Necessary declaration of Signal above "Address width truncation and Reset generation for SoC" 

    // myip_AXI_LUD_wrapper AXI slave
    wire myip_AXI_LUD_wrapper_v1_0_master_awvalid;
    wire [31:0] myip_AXI_LUD_wrapper_v1_0_master_awaddr;
    wire myip_AXI_LUD_wrapper_v1_0_master_wvalid;
    wire [31:0] myip_AXI_LUD_wrapper_v1_0_master_wdata;
    wire [3:0] myip_AXI_LUD_wrapper_v1_0_master_wstrb;
    wire myip_AXI_LUD_wrapper_v1_0_master_bready;
    wire myip_AXI_LUD_wrapper_v1_0_master_arvalid;
    wire [31:0] myip_AXI_LUD_wrapper_v1_0_master_araddr;
    wire myip_AXI_LUD_wrapper_v1_0_master_rready;
    wire myip_AXI_LUD_wrapper_v1_0_master_m_awready_awready;
    wire myip_AXI_LUD_wrapper_v1_0_master_m_wready_wready;
    wire myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bvalid;
    wire [1:0 ]myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bresp;
    wire myip_AXI_LUD_wrapper_v1_0_master_m_arready_arready;
    wire myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rvalid;
    wire [1:0] myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rresp;
    wire [31:0] myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rdata;

@Add Wrapper interface with Wire Declaration above "MIG for DDR3"

  // --------------------------------------------------------------------------------//
  // --------------------- myip_AXI_LUD_wrapper -----------------------//
  myip_AXI_LUD_wrapper myip_AXI_LUD_wrapper (
        .clk_1x(core_clk),
        .s00_axi_aclk(core_clk),
        .s00_axi_aresetn(~soc_reset),
        .s00_axi_awvalid(myip_AXI_LUD_wrapper_v1_0_master_awvalid),
        .s00_axi_awready(myip_AXI_LUD_wrapper_v1_0_master_m_awready_awready),
        .s00_axi_awaddr(myip_AXI_LUD_wrapper_v1_0_master_awaddr),
        .s00_axi_wvalid(myip_AXI_LUD_wrapper_v1_0_master_wvalid),
        .s00_axi_wready(myip_AXI_LUD_wrapper_v1_0_master_m_wready_wready),
        .s00_axi_wdata(myip_AXI_LUD_wrapper_v1_0_master_wdata),
        .s00_axi_wstrb(myip_AXI_LUD_wrapper_v1_0_master_wstrb),
        .s00_axi_arvalid(myip_AXI_LUD_wrapper_v1_0_master_arvalid),
        .s00_axi_arready(myip_AXI_LUD_wrapper_v1_0_master_m_arready_arready),
        .s00_axi_araddr(myip_AXI_LUD_wrapper_v1_0_master_araddr),
        .s00_axi_rvalid(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rvalid),
        .s00_axi_rready(myip_AXI_LUD_wrapper_v1_0_master_rready),
        .s00_axi_rdata(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rdata),
        .s00_axi_rresp(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rresp),
        .s00_axi_bvalid(myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bvalid),
        .s00_axi_bready(myip_AXI_LUD_wrapper_v1_0_master_bready),
        .s00_axi_bresp(myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bresp)
);

@ Decalration of "mkSoc" above  //I2C ports connecting wire with SoC

       //myip_AXI_LUD_wrapper 
      .myip_AXI_LUD_wrapper_v1_0_master_awvalid(myip_AXI_LUD_wrapper_v1_0_master_awvalid),
      .myip_AXI_LUD_wrapper_v1_0_master_awaddr(myip_AXI_LUD_wrapper_v1_0_master_awaddr),
      .myip_AXI_LUD_wrapper_v1_0_master_awprot(),
      .myip_AXI_LUD_wrapper_v1_0_master_awsize(),
      .myip_AXI_LUD_wrapper_v1_0_master_wvalid(myip_AXI_LUD_wrapper_v1_0_master_wvalid),
      .myip_AXI_LUD_wrapper_v1_0_master_wdata(myip_AXI_LUD_wrapper_v1_0_master_wdata),
      .myip_AXI_LUD_wrapper_v1_0_master_wstrb(myip_AXI_LUD_wrapper_v1_0_master_wstrb),
      .myip_AXI_LUD_wrapper_v1_0_master_bready(myip_AXI_LUD_wrapper_v1_0_master_bready),
      .myip_AXI_LUD_wrapper_v1_0_master_arvalid(myip_AXI_LUD_wrapper_v1_0_master_arvalid),
      .myip_AXI_LUD_wrapper_v1_0_master_araddr(myip_AXI_LUD_wrapper_v1_0_master_araddr),
      .myip_AXI_LUD_wrapper_v1_0_master_arprot(),
      .myip_AXI_LUD_wrapper_v1_0_master_arsize(),
      .myip_AXI_LUD_wrapper_v1_0_master_rready(myip_AXI_LUD_wrapper_v1_0_master_rready),
      .myip_AXI_LUD_wrapper_v1_0_master_m_awready_awready(myip_AXI_LUD_wrapper_v1_0_master_m_awready_awready),
      .myip_AXI_LUD_wrapper_v1_0_master_m_wready_wready(myip_AXI_LUD_wrapper_v1_0_master_m_wready_wready),
      .myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bvalid(myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bvalid),
      .myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bresp(myip_AXI_LUD_wrapper_v1_0_master_m_bvalid_bresp),
      .myip_AXI_LUD_wrapper_v1_0_master_m_arready_arready(myip_AXI_LUD_wrapper_v1_0_master_m_arready_arready),
      .myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rvalid(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rvalid),
      .myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rresp(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rresp),
      .myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rdata(myip_AXI_LUD_wrapper_v1_0_master_m_rvalid_rdata),

5. Transfer the TCL and Verilog File on the Shakti Directory.

6. Edit in create_project.tcl To integrate with IPs to the Soc 

source $home_dir/tcl/init_single.tcl

7. Use "make generate_boot_files ip_build arty_build generate_mcs" for check IP,intergrate IP and Create MCS for Xilinx Board is build correctly or not.

8. Use "make program_mcs" to upload to FPGA.After Uploading the code,Reconnect USB of FPGA.

9. shakti-sdk Folder Directory should be as follows:-

SW
├── Makefile
└── src
    ├── float_to_int.h
    ├── FPGALoad_A.h
    ├── FPGALoad_INST.h
    ├── int_to_float.h
    ├── SW.c
    ├── Makefile

Both MakeFile are mandatory and is general which is taken from other software project


10. Alter Makefile in "software" with extra endif

else
ifeq ($(PROGRAM),SW)
filepath := SW/C_files

endif

11. It will require 4 Terminal under shakti sdk (git clone https://gitlab.com/behindbytes/shakti-sdk.git)

  11(a) sudo $(which openocd) -f ftdi.cfg  :-  For Booting the Shakti Processor

  11(b) make software PROGRAM=SW TARGET=parashu :- Program Name and Target 
  
  11(c) sudo miniterm /dev/ttyUSB1 19200  | tee output.log :- use Seial terminal and log into a file output.log
  
  11(d) For Debugging :- 
  
    riscv32-unknown-elf-gdb
    set remotetimeout unlimited
    target remote localhost:3333
    file ./software/examples/SW/C_files/output/SW.shakti
    load
    c
