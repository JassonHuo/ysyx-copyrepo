LIBCAPSTONE = capstone/repo/libcapstone.so.5
CFLAGS += -I capstion/repo/include
csrc/utils/disasm.c: $(LIBCAPSTONE)
$(LIBCAPSTONE):
	$(MAKE) -C capstone
