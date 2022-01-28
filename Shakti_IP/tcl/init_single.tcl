######################################################################
######################## Design BRAM_A ###############################
######################################################################
###################
###### 1024 is the depth
##############
create_ip -name blk_mem_gen -version 8.4 -vendor xilinx.com -library ip -module_name design_BRAM_A
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Depth_A {1024} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Use_RSTA_Pin {false} CONFIG.Use_RSTB_Pin {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_bd_cells design_BRAM_A]
set_property generate_synth_checkpoint false [get_files design_BRAM_A.xci]
generate_target {synthesis simulation} [get_files design_BRAM_A.xci]
######################################################################
######################### Design CTRL ################################
######################################################################
###################
###### Write_Width_A is 307
###### 4096 is the depth
##############
create_ip -name blk_mem_gen -version 8.4 -vendor xilinx.com -library ip -module_name design_CTRL
set_property -dict [list CONFIG.Write_Width_A {307} CONFIG.Write_Depth_A {4096} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Read_Width_A {307} CONFIG.Write_Width_B {307} CONFIG.Read_Width_B {307} CONFIG.Use_RSTA_Pin {false}] [get_bd_cells design_CTRL]
set_property generate_synth_checkpoint false [get_files design_CTRL.xci]
generate_target {synthesis simulation} [get_files design_CTRL.xci]


######################################################################
######################### Design MAC ################################
######################################################################
###################
###### CONFIG.Operation_Type {FMA} 
###### CONFIG.C_Mult_Usage {Full_Usage}
###### CONFIG.Axi_Optimize_Goal {Performance}
###### CONFIG.Result_Precision_Type {Single} 
###### CONFIG.C_Latency 11
##############
create_ip -name floating_point -version 7.1 -vendor xilinx.com -library ip -module_name design_MAC
set_property -dict [list CONFIG.Operation_Type {FMA} CONFIG.C_Mult_Usage {Full_Usage} CONFIG.Axi_Optimize_Goal {Performance} CONFIG.Result_Precision_Type {Single} CONFIG.C_Result_Exponent_Width {8} CONFIG.C_Result_Fraction_Width {24} CONFIG.Maximum_Latency {false} CONFIG.C_Latency {11} CONFIG.C_Rate {1}] [get_bd_cells design_MAC]
make_bd_pins_external  [get_bd_cells floating_point_0]
set_property generate_synth_checkpoint false [get_files design_MAC.xci]
generate_target {synthesis simulation} [get_files design_MAC.xci]


######################################################################
######################### Design DIV ################################
######################################################################
###################
###### CONFIG.Operation_Type {Divide}
###### CONFIG.C_Mult_Usage {Full_Usage}
###### CONFIG.Axi_Optimize_Goal {Performance}
###### CONFIG.Result_Precision_Type {Single} 
###### CONFIG.C_Latency 10
##############
create_ip -name floating_point -version 7.1 -vendor xilinx.com -library ip -module_name design_DIV
set_property -dict [list CONFIG.Operation_Type {Divide} CONFIG.Axi_Optimize_Goal {Performance} CONFIG.Result_Precision_Type {Single} CONFIG.C_Result_Exponent_Width {8} CONFIG.C_Result_Fraction_Width {24} CONFIG.C_Mult_Usage {No_Usage} CONFIG.Maximum_Latency {false} CONFIG.C_Latency {10} CONFIG.C_Rate {1}] [get_bd_cells design_DIV]
make_bd_pins_external  [get_bd_cells floating_point_0]
set_property generate_synth_checkpoint false [get_files design_DIV.xci]
generate_target {synthesis simulation} [get_files design_DIV.xci]
