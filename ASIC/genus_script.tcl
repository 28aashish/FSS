genusset_db init_lib_search_path /vlsi/pdk/scl/v2_dec2016/stdlib/fs120/liberty/lib_flow_ff/
set_db init_hdl_search_path ../src
read_libs tsl18fs120_scl_ff.lib

set runname SKY;
set myFiles [glob ../src/*.v]
set DFTLIB [glob /vlsi/pdk/scl_new/SCL_PDK_V2_CD/SCL_PDK_v2/scl_pdk_v2/stdlib/fs120/verilog/*.v]
set basename LUDHardware;# name of top level modul

read_hdl ${myFiles}
elaborate ${basename}
read_sdc ../constraints/constraints_top.sdc

set_db dft_scan_style muxed_scan 
set_db dft_prefix dft_
define_shift_enable -name SE -active high -create_port SE
check_dft_rules

set_db syn_generic_effort medium
syn_generic
set_db syn_map_effort medium
syn_map
set_db syn_opt_effort medium
syn_opt

check_dft_rules 
set_db design:${basename} .dft_min_number_of_scan_chains 1 
define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -create_ports  

connect_scan_chains -auto_create_chains 
syn_opt -incr

report_scan_chains 
write_dft_atpg -library ${DFTLIB}


### Write out the reports
report timing > ${basename}_${runname}_timing.rep
report gates  > ${basename}_${runname}_cell.rep
report power  > ${basename}_${runname}_power.rep

### Write out the structural Verilog and sdc files
write_hdl -mapped >  ${basename}_${runname}_dft.v
write_sdc >  ${basename}_${runname}_dft.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > dft_delays.sdf
write_scandef > LUDH_scanDEF.scandef