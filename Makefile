# This Works is placed under the terms of the Copyright Less License,
# see file COPYRIGHT.CLL.  USE AT OWN RISK, ABSOLUTELY NO WARRANTY.

.PHONY: all clean distclean tests
all:	depends
	@echo "to test run: make tests"

.SUFFIXES: .kshcompiledtmp .ksh
clean:
	rm -f *.kshcompiledtmp
	cd unbuffered && make distclean

distclean: clean
	rm -f unbuffered.*

.PHONY: depends
depends:	prepend-script.kshcompiledtmp unbuffered.static unbuffered.dynamic

tests:	prepend-script-test

prepend-script-test:	depends
	ksh prepend-script.kshcompiledtmp

unbuffered.static:	unbuffered/tino/Makefile unbuffered/unbuffered.c
	cd unbuffered && make clean static
	cp unbuffered/unbuffered unbuffered.static
	strip unbuffered.static

unbuffered.dynamic:	unbuffered/tino/Makefile unbuffered/unbuffered.c
	cd unbuffered && make clean all
	cp unbuffered/unbuffered unbuffered.dynamic
	strip unbuffered.dynamic

unbuffered/tino/Makefile:
	git submodule update --init --recursive

.ksh.kshcompiledtmp:
	shcomp "$<" "$@"

