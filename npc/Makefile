TOPNAME = top
NXDC_FILE = constr/top.nxdc
INC_PATH ?= 

include ../Makefile 


VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc -O3 --x-assign fast \
					--x-initial fast --noassert
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

#include $(FILELIST_MK)
LIBCAPSTONE = $(NPC_HOME)/capstone/repo/libcapstone.so.5
LDFLAGS += -ldl
INC_PATH += $(NPC_HOME)/capstone/repo/include
LIBNEMUDIFF = $(NEMU_HOME)/build/riscv32-nemu-interpreter-so
INC_PATH += $(NEMU_HOME)/include

$(LIBCAPSTONE):
	$(MAKE) -C $(NPC_HOME)/capstone

csrc/disasm.c: $(LIBCAPSTONE)
csrc/main.cpp: $(LIBCAPSTONE)


default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

#SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
#$(SRC_AUTO_BIND) : $(NXDC_FILE)
#	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

VSRC = $(NPC_HOME)/vsrc/*.v
CSRC = $(NPC_HOME)/csrc/*.c
CSRC += $(NPC_HOME)/csrc/*.cpp

INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""
#CXXFLAGS += -DCONFIG_ITRACE
#CXXFLAGS += -DCONFIG_MTRACE
#CXXFLAGS += -DCONFIG_FTRACE
CXXFLAGS += -DCONFIG_DIFFTEST
#CXXFLAGS += -DCONFIG_MEMDIFFTEST
#CXXFLAGS += -DCONFIG_WAVE
#$(info INCFLAGS = $(INCFLAGS))

LDFLAGS += -lreadline -g


$(BIN): $(VSRC) $(CSRC)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))\
		-j 0 -I$(NPC_HOME)/vsrc\
		--trace-vcd
#		-LDFLAGS "-lreadline"

IMG ?= $(NPC_HOME)/csrc/dummy.bin
ELF ?= $(NPC_HOME)/csrc/dummy.elf


all: default
#	@echo "Write this Makefile by your self."

run: $(BIN)
#	@$^
	$(BIN) -f $(IMG) $(NPCFLAGS) -e $(ELF) -b

gdb: $(BIN)
	gdb $(BIN) -f $(IMG) $(NPCFLAGS) -e $(ELF) 

clean: 
	rm -rf $(BUILD_DIR)


sim: run 
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	#@echo "Write this Makefile by your self."

.PHONY: default all clean run
