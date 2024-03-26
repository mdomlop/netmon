NAME = $(shell grep -m1 PROGRAM $(firstword $(INFO)) | cut -d\" -f2)
EXECUTABLE = $(shell grep -m1 EXECUTABLE $(firstword $(INFO)) | cut -d\" -f2)
DESCRIPTION = $(shell grep -m1 DESCRIPTION $(firstword $(INFO)) | cut -d\" -f2)
VERSION = $(shell grep -m1 VERSION $(firstword $(INFO)) | cut -d\" -f2)
AUTHOR = $(shell grep -m1 AUTHOR $(firstword $(INFO)) | cut -d\" -f2)
MAIL := $(shell grep -m1 MAIL $(firstword $(INFO)) | cut -d\" -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
URL = $(shell grep -m1 URL $(firstword $(INFO)) | cut -d\" -f2)
LICENSE = $(shell grep -m1 LICENSE $(firstword $(INFO)) | cut -d\" -f2)
PKGNAME = $(EXECUTABLE)
PKGDESCRIPTION = $(DESCRIPTION)

PREFIX = '/usr/local'
DESTDIR = ''

#CFLAGS = -O2 -Wall -ansi -pedantic -static --std=c18
CFLAGS := -O2 -Wall -ansi -pedantic
CFLAGS_OPTI := $(CFLAGS) -march=native -mtune=native -O3
CFLAGS_STATIC := $(CFLAGS) -static
CFLAGS_OPTI_STATIC := $(CFLAGS_OPTI) -static
CFLAGS_DEBUG := -Wall -ggdb3

EXECC = x86_64-w64-mingw32-gcc

BINARIES = $(notdir $(basename $(SOURCES)))
INSTALLED_BINARIES = $(addprefix $(DESTDIR)/$(PREFIX)/bin/,$(BINARIES))

DOCS = $(basename README.md)
INSTALLED_DOCS = $(addprefix $(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/,$(DOCS))
INSTALLED_LICENSE = $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE)/COPYING

ELFS = $(addsuffix .elf,$(addprefix source/,$(BINARIES)))
ELFS_OPTI = $(addsuffix .opti.elf,$(addprefix source/,$(BINARIES)))
ELFS_STATIC = $(addsuffix .static.elf,$(addprefix source/,$(BINARIES)))
ELFS_OPTI_STATIC = $(addsuffix .opti.static.elf,$(addprefix source/,$(BINARIES)))
ELFS_DEBUG = $(addsuffix .debug.elf,$(addprefix source/,$(BINARIES)))

EXES = $(addsuffix .exe,$(addprefix source/,$(BINARIES)))
EXES_OPTI = $(addsuffix .opti.exe,$(addprefix source/,$(BINARIES)))
EXES_STATIC = $(addsuffix .static.exe,$(addprefix source/,$(BINARIES)))
EXES_OPTI_STATIC = $(addsuffix .opti.static.exe,$(addprefix source/,$(BINARIES)))
EXES_DEBUG = $(addsuffix .debug.exe,$(addprefix source/,$(BINARIES)))

default: elf
debug: elf_debug exe_debug

all_opti: elf_opti exe_opti
all_static: elf_static exe_static
all_opti_static: elf_opti_static exe_opti_static
all_bin: default all_opti all_static all_opti_static debug
all_pkg: pkg_arch pkg_debian pkg_ocs pkg_termux
all: all_bin all_pkg

elf: $(ELFS)
elf_opti: CFLAGS = $(CFLAGS_OPTI)
elf_opti: $(ELFS_OPTI)
elf_static: CFLAGS = $(CFLAGS_STATIC)
elf_static: $(ELFS_STATIC)
elf_opti_static: CFLAGS = $(CFLAGS_OPTI_STATIC)
elf_opti_static: $(ELFS_OPTI_STATIC)
elf_debug: CFLAGS = $(CFLAGS_DEBUG)
elf_debug: $(ELFS_DEBUG)

exe: CC = $(EXECC)
exe: $(EXES)
exe_opti: CFLAGS = $(CFLAGS_OPTI)
exe_opti: $(EXES_OPTI)
exe_static: CFLAGS = $(CFLAGS_STATIC)
exe_static: $(EXES_STATIC)
exe_opti_static: CFLAGS = $(CFLAGS_OPTI_STATIC)
exe_opti_static: $(EXES_OPTI_STATIC)
exe_debug: CFLAGS = $(CFLAGS_DEBUG)
exe_debug: $(EXES_DEBUG)

%.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)
%.opti.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)
%.static.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)
%.opti.static.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)
%.debug.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)

%.exe: %.c
	$(CC) $< -o $@ $(CFLAGS) -Wno-format-zero-length
%.opti.exe: %.c
	$(CC) $< -o $@ $(CFLAGS) -Wno-format-zero-length
%.static.exe: %.c
	$(CC) $< -o $@ $(CFLAGS) -Wno-format-zero-length
%.opti.static.exe: %.c
	$(CC) $< -o $@ $(CFLAGS) -Wno-format-zero-length
%.debug.exe: %.c
	$(CC) $< -o $@ $(CFLAGS) -Wno-format-zero-length

# Markdown to share/doc/
$(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/%: %.md
	install -dm 755 $(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/
	install -Dm 644 $^ $@

$(INSTALLED_LICENSE): LICENSE
	install -Dm 644 $^ $@

install_elf: elf
install_elf_opti: elf_opti
install_elf_static: elf_static
install_elf_opti_static: elf_opti_static

$(DESTDIR)/$(PREFIX)/bin/%: source/%.elf
	install -dm 755 $(DESTDIR)/$(PREFIX)/bin/
	install -Dm 755 $^ $@


install: install_elf install_all_docs

install_elf: elf install_all_docs install_bin_dir
	install -Dm 755 source/$(EXECUTABLE).elf $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)
install_elf_opti: elf_opti install_all_docs install_bin_dir
	install -Dm 755 source/$(EXECUTABLE).opti.elf $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)
install_static: elf_static install_all_docs install_bin_dir
	install -Dm 755 source/$(EXECUTABLE).static.elf $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)
install_elf_opti_static: opti_static install_all_docs install_bin_dir
	install -Dm 755 source/$(EXECUTABLE).opti.static.elf $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE)

install_all_docs: install_docs install_license
install_docs: $(INSTALLED_DOCS)
install_license: $(INSTALLED_LICENSE)
install_bin_dir:
	install -dm 755 $(DESTDIR)/$(PREFIX)/bin/


uninstall:
	rm -f $(INSTALLED_BINARIES)
	rm -f $(INSTALLED_DOCS)
	rm -f $(INSTALLED_LICENSE)



clean: clean_arch clean_debian clean_ocs clean_termux
	rm -f $(ELFS)
	rm -f $(ELFS_OPTI)
	rm -f $(ELFS_STATIC)
	rm -f $(ELFS_OPTI_STATIC)
	rm -f $(ELFS_DEBUG)
	rm -f $(EXES)
	rm -f $(EXES_OPTI)
	rm -f $(EXES_STATIC)
	rm -f $(EXES_OPTI_STATIC)
	rm -f $(EXES_DEBUG)

purge: clean purge_arch purge_debian purge_ocs purge_termux

.PHONY: clean arch_clean uninstall
