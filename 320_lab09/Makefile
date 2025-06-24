sim_debounce:
	xvlog -sv debounce.sv tb_debounce.sv --nolog
	xelab tb_debounce -debug typical --nolog
	xsim tb_debounce --runall -log sim_debounce.log

sim_debounce_50:
	xvlog -sv debounce.sv tb_debounce.sv --nolog
	xelab --debug typical tb_debounce --generic_top WAIT_TIME_US=50 --nolog
	xsim tb_debounce --runall -log sim_debounce_50.log

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -rf xsim.dir .Xil *.txt *.bit *.log *.jou *.wdb *.pb *.backup *.backup.log *.backup.jou .Xil debounce_top_synth.dcp debounce_top.dcp clockInfo.txt utilization.rpt timing.rpt