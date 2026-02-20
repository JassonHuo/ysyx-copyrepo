all:
	@echo "Write this Makefile by your self."

CSRC = /home/jasonhuo/ysyx/ysyx-workbench/npc/csrc/top.cpp

VSRC = /home/jasonhuo/ysyx/ysyx-workbench/npc/vsrc/top.v

sim: $(CSRC) $(VSRC)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	#@echo "Write this Makefile by your self."
	verilator --cc --exe --build -j 0 --trace-vcd $^ 

include ../Makefile
