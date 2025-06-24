#***************************************************************************
#
# Filename: sim_debounce_top.tcl
#
# Author: Seth Campbell
# Description: This TCL script simulates 3 noisy transitions
#
#***************************************************************************

add_force clk {0 0} {1 5ns} -repeat_every 10ns
add_force btnd 1

run 10 ns
add_force btnd 0
run 10 ns

# 1
add_force btnc 1
run 1000000 ns

add_force btnc 0
run 1000000 ns

add_force btnc 1
run 5000010 ns

add_force btnc 0
run 5000010 ns

# 2
add_force btnc 1
run 1000000 ns

add_force btnc 0
run 1000000 ns

add_force btnc 1
run 5000010 ns

add_force btnc 0
run 5000010 ns

# 3
add_force btnc 1
run 1000000 ns

add_force btnc 0
run 1000000 ns

add_force btnc 1
run 4000010 ns

add_force btnc 0
run 4000010 ns

run 1000000 ns
