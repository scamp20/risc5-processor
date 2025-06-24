#***************************************************************************
#
# Filename: sim_debounce.tcl
#
# Author: Seth Campbell
# Description: This TCL script simulates debouncing an input
#
#***************************************************************************

add_force clk {0 0} {1 5ns} -repeat_every 10ns
add_force rst 1

run 10 ns
add_force rst 0
run 10 ns

add_force noisy 1
run 1000000 ns

add_force noisy 0
run 1000000 ns

add_force noisy 1
run 5000010 ns

add_force noisy 0
run 5000010 ns

run 1000000 ns
