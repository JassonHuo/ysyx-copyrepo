ME = miniRV
SRCS = miniRV.c
include $(AM_HOME)/Makefile

$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
debug : 
	make ARCH=native run -j16

	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!

.PHONY: debug
