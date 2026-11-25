vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/lib_cdc_v1_0_3
vlib modelsim_lib/msim/proc_sys_reset_v5_0_15
vlib modelsim_lib/msim/xil_defaultlib

vmap lib_cdc_v1_0_3 modelsim_lib/msim/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_15 modelsim_lib/msim/proc_sys_reset_v5_0_15
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work lib_cdc_v1_0_3 -64 -93  \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_15 -64 -93  \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../Lab10_Colorizer.gen/sources_1/ip/proc_sys_reset_0/sim/proc_sys_reset_0.vhd" \


