######################################################################
######################## Design BRAM_A ###############################
######################################################################
###################
###### 1024 is the depth
##############
create_bd_design "design_BRAM_A"
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Depth_A {1024} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Use_RSTA_Pin {false} CONFIG.Use_RSTB_Pin {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_cells blk_mem_gen_0]
make_bd_intf_pins_external  [get_bd_cells blk_mem_gen_0]
save_bd_design
close_bd_design [get_bd_designs design_BRAM_A]

######################################################################
######################### Design CTRL ################################
######################################################################
###################
###### Write_Width_A is 357
###### 4096 is the depth
##############
create_bd_design "design_CTRL"
#update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0
set_property -dict [list CONFIG.Write_Width_A {357} CONFIG.Write_Depth_A {4096} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Read_Width_A {357} CONFIG.Write_Width_B {357} CONFIG.Read_Width_B {357} CONFIG.Use_RSTA_Pin {false}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_cells blk_mem_gen_0]
make_bd_intf_pins_external  [get_bd_cells blk_mem_gen_0]
save_bd_design
close_bd_design [get_bd_designs design_CTRL]
######################################################################
######################### Design MAC ################################
######################################################################
###################
###### CONFIG.Operation_Type {FMA} 
###### CONFIG.C_Mult_Usage {Full_Usage}
###### CONFIG.Axi_Optimize_Goal {Performance}
###### CONFIG.Result_Precision_Type {Single} 
###### CONFIG.C_Latency {22}
##############
create_bd_design "design_MAC"
create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_0
set_property -dict [list CONFIG.Operation_Type {FMA} CONFIG.C_Mult_Usage {Full_Usage} CONFIG.Axi_Optimize_Goal {Performance} CONFIG.Result_Precision_Type {Single} CONFIG.C_Result_Exponent_Width {8} CONFIG.C_Result_Fraction_Width {24} CONFIG.C_Latency {22} CONFIG.C_Rate {1}] [get_bd_cells floating_point_0]
make_bd_pins_external  [get_bd_cells floating_point_0]
make_bd_intf_pins_external  [get_bd_cells floating_point_0]
save_bd_design
close_bd_design [get_bd_designs design_MAC]


######################################################################
######################### Design DIV ################################
######################################################################
###################
###### CONFIG.Operation_Type {Divide} 
###### CONFIG.C_Mult_Usage {Full_Usage}
###### CONFIG.Axi_Optimize_Goal {Performance}
###### CONFIG.Result_Precision_Type {Single} 
###### CONFIG.C_Latency {31}
##############
create_bd_design "design_DIV"
create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_0
set_property -dict [list CONFIG.Operation_Type {Divide} CONFIG.Axi_Optimize_Goal {Performance} CONFIG.Result_Precision_Type {Single} CONFIG.C_Result_Exponent_Width {8} CONFIG.C_Result_Fraction_Width {24} CONFIG.C_Mult_Usage {No_Usage} CONFIG.C_Latency {31} CONFIG.C_Rate {1}] [get_bd_cells floating_point_0]
make_bd_pins_external  [get_bd_cells floating_point_0]
make_bd_intf_pins_external  [get_bd_cells floating_point_0]
save_bd_design
close_bd_design [get_bd_designs design_DIV]