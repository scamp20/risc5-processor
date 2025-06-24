#***************************************************************************
#
# Filename: implement.tcl
#
# Author: Seth Campbell
# Description: This TCL script implements a fully synthesized design as a bitstream
#
#***************************************************************************

open_checkpoint debounce_top_synth.dcp
opt_design
place_design
route_design
report_timing_summary -max_paths 2 -report_unconstrained -file timing.rpt -warn_on_violation
report_utilization -file utilization.rpt
write_bitstream -force debounce_top.bit
write_checkpoint -force debounce_top.dcp