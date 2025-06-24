#***************************************************************************
#
# Filename: calc_sim.tcl
#
# Author: Seth Campbell
# Description: This TCL script tests the opcode functionalities
#
#***************************************************************************

# Start clock (10ns period, toggling every 5ns)
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns

# Set all control signals and switches to default
add_force btnu 0
add_force btnd 0
add_force btnc 0
add_force btnl 0
add_force btnr 0
add_force sw -radix hex 0000

# Run a bit to settle
run 10000 ns

# --------------------------------------------------------------------------
# Step 1: Reset accumulator with btnu (op1 = 0)
# --------------------------------------------------------------------------

add_force btnu 1
run 20000 ns
add_force btnu 0

# Let the system settle with reset
run 10000 ns

# --------------------------------------------------------------------------
# Step 2: Set sw = 4 (op2) and alu_op = ADD (btnc=0, btnl=0, btnr=0)
# --------------------------------------------------------------------------

add_force sw -radix hex 0004
add_force btnc 0
add_force btnl 0
add_force btnr 0

# Wait a bit before triggering btnd
run 10000 ns

# --------------------------------------------------------------------------
# Step 3: Trigger btnd to update accumulator = op1 + op2 = 0 + 4
# --------------------------------------------------------------------------

# Simulate a one-shot press (useful if debouncer is disabled for sim)
add_force btnd 1
run 50010
add_force btnd 0
run 50010

# Run for long enough for result to settle
run 50000 ns
