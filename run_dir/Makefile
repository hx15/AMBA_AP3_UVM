
RUN_CMD = xrun -sv -64 +incdir+"../common" ../common/common_data_types.sv +inddir+"../Top/" +incdir+"../tests" -uvm +incdir+"../master/" +incdir+"../common/" +inddir+"../Top/" ../Top/testbench.sv -clean +UVM_VERBOSITY=UVM_DEBUG -access +rwc -input input.tcl 

TEST_TARGETS = run_simulation

ifdef SIMVISION
	TEST_TARGETS += run_simvision
endif

ifdef ABV
	RUN_CMD += -define ABV
endif

ifdef GUI
	RUN_CMD += -gui
endif



clean:
	rm -rf xcelium.d/ *.key *.log *.dsn *.dump *.trn mcesim.run/ *.history *.vcd  *.shm

run_simulation:
	${RUN_CMD}

run_simvision:
	simvision dump.vcd

quick: ${TEST_TARGETS}



