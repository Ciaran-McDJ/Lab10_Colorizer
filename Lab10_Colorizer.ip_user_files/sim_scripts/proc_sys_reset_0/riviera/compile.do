transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/lib_cdc_v1_0_3
vlib riviera/proc_sys_reset_v5_0_15
vlib riviera/xil_defaultlib

vmap lib_cdc_v1_0_3 riviera/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_15 riviera/proc_sys_reset_v5_0_15
vmap xil_defaultlib riviera/xil_defaultlib

vcom -work lib_cdc_v1_0_3 -93  -incr \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_15 -93  -incr \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../Lab10_Colorizer.gen/sources_1/ip/proc_sys_reset_0/sim/proc_sys_reset_0.vhd" \


