SOURCES = source/netmon.c
INFO = source/netmon.c

include mk/info.mk
include mk/elf.mk
include mk/install.mk
include mk/arch.mk
include mk/debian.mk
include mk/ocs.mk
include mk/termux.mk
include mk/win.mk
include mk/debug.mk
include mk/opti.mk
include mk/static.mk
include mk/opti_static.mk

default: elf

all: all_bin all_pkg
all_pkg: pkg_arch pkg_debian pkg_ocs pkg_termux
all_bin: default exe debug opti static opti_static

clean: clean_elf clean_exe clean_arch clean_debian clean_ocs clean_termux clean_debug clean_opti clean_static clean_opti_static

purge: clean purge_arch purge_debian purge_ocs purge_termux
