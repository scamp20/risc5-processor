#***************************************************************************
#
# Filename: synth.tcl
#
# Author: Seth Campbell
# Description: This TCL script synthesizes my code using the xdc specs
#
#***************************************************************************

read_verilog -sv debounce_top.sv debounce.sv ../lab07/seven_segment4.sv
read_xdc deb.xdc
synth_design -top debounce_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force debounce_top_synth.dcp