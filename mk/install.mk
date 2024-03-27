DOCS = $(basename README.md)

INSTALLED_BINARIES = $(addprefix $(DESTDIR)/$(PREFIX)/bin/,$(BINARIES))
$(DESTDIR)/$(PREFIX)/bin/%: %.elf
	install -dm 755 $(DESTDIR)/$(PREFIX)/bin/
	install -Dm 755 $^ $@

INSTALLED_DOCS = $(addprefix $(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/,$(DOCS))
# Markdown to share/doc/
$(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/%: %.md
	install -dm 755 $(DESTDIR)/$(PREFIX)/share/doc/$(PKGNAME)/
	install -Dm 644 $^ $@

INSTALLED_LICENSE = $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE)/COPYING
$(INSTALLED_LICENSE): LICENSE
	install -Dm 644 $^ $@

install_elf: elf $(INSTALLED_BINARIES)
install_docs: $(INSTALLED_DOCS)
install_license: $(INSTALLED_LICENSE)

install: install_elf install_all_docs
install_all_docs: install_docs install_license


uninstall:
	rm -f $(INSTALLED_BINARIES)
	rm -f $(INSTALLED_DOCS)
	rm -f $(INSTALLED_LICENSE)
