#***************************************************************************
#
# Filename: synth.tcl
#
# Author: Seth Campbell
# Description: This TCL script synthesizes my code using the xdc specs
#
#***************************************************************************

read_verilog -sv calc.sv alu.sv ../320_lab09/debounce.sv
read_xdc alu.xdc
synth_design -top calc -part xc7a35tcpg236-1 -verbose
write_checkpoint -force calc_synth.dcp