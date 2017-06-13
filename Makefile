MAKE ?= make
CLEAN ?= make clean
RM ?= rm -f

.PHONY: all example clean

all:
	$(MAKE) -C protobuf

example:
	@$(MAKE) -C example
	@echo
	@echo "run example:"
	@echo
	luajit example/test.lua

clean:
	$(RM) *.lua *.so
	@$(CLEAN) -C protobuf
	@$(CLEAN) -C example
