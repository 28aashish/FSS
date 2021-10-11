#start_gui
#create_project test_micro /home/tamrakar/work_vivado_2017_1/test_micro -part xc7k325tffg900-2
#set_property board_part xilinx.com:kc705:part0:1.5 [current_project]
#set_property  ip_repo_paths  /home/tamrakar/work_vivado_2017_1/ip_Dual [current_project]
update_ip_catalog
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.0 mig_7series_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:mig_7series -config {Board_Interface "ddr3_sdram" }  [get_bd_cells mig_7series_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset ( FPGA Reset ) " }  [get_bd_pins mig_7series_0/sys_rst]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {local_mem "16KB" ecc "None" cache "16KB" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "/mig_7series_0/ui_addn_clk_0 (100 MHz)" }  [get_bd_cells microblaze_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
endgroup
set_property -dict [list CONFIG.C_BAUDRATE {115200}] [get_bd_cells axi_uartlite_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "rs232_uart ( UART ) " }  [get_bd_intf_pins axi_uartlite_0/UART]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Cached)" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset ( FPGA Reset ) " }  [get_bd_pins rst_mig_7series_0_100M/ext_reset_in]
endgroup
validate_bd_design
regenerate_bd_layout
startgroup
create_bd_cell -type ip -vlnv user.org:user:myip_LUdecomposition_v2_v1_0:1.0 myip_AXI_LUD_wrapper_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" intc_ip "/microblaze_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins myip_AXI_LUD_wrapper_0/s00_axi]
connect_bd_net [get_bd_pins myip_AXI_LUD_wrapper_0/clk_1x] [get_bd_pins mig_7series_0/ui_addn_clk_0]
regenerate_bd_layout
save_bd_design
validate_bd_design