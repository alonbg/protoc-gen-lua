MAKE ?= make
CLEAN ?= make clean
RM ?= rm -f

.PHONY: all example clean

all:
	$(MAKE) -C protobuf

example:
	@$(MAKE) -C example
	@cp example/person_pb.lua .
	@cp example/test.lua .
	@cp protobuf/pb.so .
	@echo
	@echo "run example:"
	@echo
	luajit test.lua

clean:
	$(RM) *.lua *.so
	@$(CLEAN) -C protobuf
	@$(CLEAN) -C example
