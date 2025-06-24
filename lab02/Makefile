sim_alu:
	xvlog -sv alu.sv tb_alu.sv --nolog
	xelab tb_alu -debug typical --timescale 1ns/100ps --nolog
	xsim tb_alu --runall -log sim_alu.log

sim_calc_tb:
	xvlog -sv calc.sv tb_calc.sv alu.sv ../320_lab09/debounce.sv --nolog
	xelab tb_calc -debug typical --timescale 1ns/100ps --nolog
	xsim tb_calc --runall -log sim_calc.log

sim_calc:
	xvlog -sv calc.sv alu.sv ../320_lab09/debounce.sv --nolog
	xelab calc -debug typical --generic_top "WAIT_TIME_US=50" --nolog
	xsim calc -gui --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

program:
	djtgcfg prog -d Basys3 -i 0 -f calc.bit

clean:
	rm -rf xsim.dir .Xil *.txt *.bit *.log *.jou *.wdb *.pb *.backup *.backup.log *.backup.jou .Xil alu.bit alu_synth.dcp alu.dcp clockInfo.txt utilization.rpt