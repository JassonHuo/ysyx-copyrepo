TOPNAME = Vtop
NXDC_FILE = constr/top.nxdc
INC_PATH ?= 

VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc -O3 --x-assign fast \
					--x-initial fast --noassert
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/audo_bind.cpp)
$(SRC_AUTO_BIND) : $(NXDC_FILE)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cpp")
CSRCS += $(SRC_AUDO_BIND)

INCFLAGS = $(addprefix -I, $(NVBOARD_ARCHIVE))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"v$(TOPNAME)\""

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS, $(CXXFLAGS)) $(addprefix -LDFLAGS, $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))


all: default
	@echo "Write this Makefile by your self."

run: $(BIN)
	@$^

clean: $(BIN)
	rm -rf $(BUILD_DIR)

CSRC = /home/jasonhuo/ysyx/ysyx-workbench/npc/csrc/nv_switch.cpp

VSRC = /home/jasonhuo/ysyx/ysyx-workbench/npc/vsrc/top.v

sim: $(CSRC) $(VSRC)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	#@echo "Write this Makefile by your self."

include ../Makefile $(NVBOARD_HOME)/scripts/nvboard.mk

.PHONY: default all clean run
