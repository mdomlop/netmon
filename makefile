SOURCES = source/netmon.c
INFO = source/netmon.c

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

CFLAGS = -O2 -Wall -ansi -pedantic -static
#CFLAGS = -O2 -Wall -ansi -pedantic -static --std=c18

BINARIES = $(notdir $(basename $(SOURCES)))
INSTALLED_BINARIES = $(addprefix $(DESTDIR)/$(PREFIX)/bin/,$(BINARIES))
ELFS = $(addsuffix .elf,$(addprefix source/,$(BINARIES)))

all: elf

%.elf: %.c
	$(CC) $< -o $@ $(CFLAGS)

elf: $(ELFS)

elf_opti: CFLAGS = -std=c11 -march=native -mtune=native -Wall -pedantic -static -O2
elf_opti: $(ELFS)
install_elf_opti: elf_opti install

debug: CFLAGS = -Wall -ggdb3
debug: source/$(PKGNAME)


install_elf: $(INSTALLED_BINARIES)
$(DESTDIR)/$(PREFIX)/bin/%: source/%.elf
	install -dm 755 $(DESTDIR)/$(PREFIX)/bin/
	install -Dm 755 $^ $@

install: install_elf LICENSE README.md
	install -Dm 644 LICENSE $(DESTDIR)/$(PREFIX)/share/licenses/$(PKGNAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/README

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE)
	rm -f $(PREFIX)/share/licenses/$(EXECUTABLE)/LICENSE


include arch.mk
include debian.mk
include ocs.mk

pkg: pkg_arch pkg_debian pkg_ocs

clean: clean_arch clean_debian clean_ocs
	rm -f $(ELFS)

purge: clean purge_arch purge_debian purge_ocs

