NAME = $(shell grep PROGRAM src/netmon.c | cut -d\" -f2)
EXECUTABLE = $(shell grep EXECUTABLE src/netmon.c | cut -d\" -f2)
DESCRIPTION = Simple console network traffic monitor for Linux.
VERSION = $(shell grep VERSION src/netmon.c | cut -d\" -f2)
AUTHOR = $(shell grep AUTHOR src/netmon.c | cut -d\" -f2)
MAIL := $(shell grep MAIL src/netmon.c | cut -d\" -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
URL = $(shell grep URL src/netmon.c | cut -d\" -f2)
LICENSE = GPL3

PREFIX = '/usr'
DESTDIR = ''

ARCHPKG = $(EXECUTABLE)-$(VERSION)-1-$(shell uname -m).pkg.tar.xz

CFLAGS = -march=native -mtune=native -O2 -Wall -ansi -pedantic -static

src/$(EXECUTABLE): src/$(EXECUTABLE).c

install: src/$(EXECUTABLE) LICENSE README.md
	install -Dm 755 src/$(EXECUTABLE) $(DESTDIR)$(PREFIX)/bin/$(EXECUTABLE)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE)/COPYING
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE)/README

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE)
	rm -f $(PREFIX)/share/licenses/$(EXECUTABLE)/LICENSE

arch_clean:
	rm -rf pkg
	rm -f $(ARCHPKG)

clean: arch_clean
	rm -rf src/$(EXECUTABLE)

arch_pkg: $(ARCHPKG)
$(ARCHPKG): PKGBUILD Makefile src/$(EXECUTABLE) LICENSE README.md
	sed -i "s|pkgname=.*|pkgname=$(EXECUTABLE)|" PKGBUILD
	sed -i "s|pkgver=.*|pkgver=$(VERSION)|" PKGBUILD
	sed -i "s|pkgdesc=.*|pkgdesc='$(DESCRIPTION)'|" PKGBUILD
	sed -i "s|url=.*|url='$(URL)'|" PKGBUILD
	sed -i "s|license=.*|license=('$(LICENSE)')|" PKGBUILD
	makepkg -df
	@echo
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $@

.PHONY: clean arch_clean uninstall
