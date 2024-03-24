NAME = $(shell grep -m1 PROGRAM source/netmon.c | cut -d\" -f2)
EXECUTABLE = $(shell grep -m1 EXECUTABLE source/netmon.c | cut -d\" -f2)
PKGNAME = $(EXECUTABLE)
DESCRIPTION = $(shell grep -m1 DESCRIPTION source/netmon.c | cut -d\" -f2)
VERSION = $(shell grep -m1 VERSION source/netmon.c | cut -d\" -f2)
AUTHOR = $(shell grep -m1 AUTHOR source/netmon.c | cut -d\" -f2)
MAIL := $(shell grep -m1 MAIL source/netmon.c | cut -d\" -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
URL = $(shell grep -m1 URL source/netmon.c | cut -d\" -f2)
LICENSE = $(shell grep -m1 LICENSE source/netmon.c | cut -d\" -f2)

PREFIX = '/usr'
DESTDIR = ''

ARCHPKG = $(EXECUTABLE)-$(VERSION)-1-$(shell uname -m).pkg.tar.xz

CFLAGS = -O2 -Wall -ansi -pedantic -static

source/$(EXECUTABLE): source/$(EXECUTABLE).c

opti: CFLAGS = -march=native -mtune=native -O2 -Wall -ansi -pedantic -static
opti: source/$(EXECUTABLE)
install_opti: opti install

install: source/$(EXECUTABLE) LICENSE README.md
	install -Dm 755 source/$(EXECUTABLE) $(DESTDIR)$(PREFIX)/bin/$(EXECUTABLE)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE)/COPYING
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE)/README

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE)
	rm -f $(PREFIX)/share/licenses/$(EXECUTABLE)/LICENSE


include arch.mk
include debian.mk
include ocs.mk

pkg: pkg_arch pkg_debian pkg_ocs

clean: clean_arch clean_debian clean_ocs
purge: purge_arch purge_debian purge_ocs

.PHONY: clean arch_clean uninstall
