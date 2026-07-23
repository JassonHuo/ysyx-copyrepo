LIBCAPSTONE = $(NPC_HOME)/capstone/repo/libcapstone.so.5
LDFLAGS += -l$(NPC_HOME)/capstone/repo/include
csrc/utils/disasm.c: $(LIBCAPSTONE)
$(LIBCAPSTONE):
	$(MAKE) -C capstone
