
DARCHI = $(shell dpkg --print-architecture)
TERMUXDIR = $(PKGNAME)-$(VERSION)termux_$(DARCHI)
TERMUXPKG = $(TERMUXDIR).deb
TERMUXPREFIX=/data/data/com.termux/files/usr

#DEBIANDEPS = libbtrfsutil1

$(TERMUXDIR)/DEBIAN:
	mkdir -p -m 0775 $@

$(TERMUXDIR)/DEBIAN/copyright: copyright $(TERMUXDIR)/DEBIAN
	@echo Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/ > $@
	@echo Upstream-Name: $(PKGNAME) >> $@
	@echo "Upstream-Contact: Manuel Domínguez López <$(MAIL)>" >> $@
	@echo Source: $(URL) >> $@
	@echo License: $(LICENSE) >> $@
	@echo >> $@
	@echo 'Files: *' >> $@
	@echo "Copyright: $(YEAR) $(AUTHOR) <$(MAIL)>" >> $@
	@echo License: $(LICENSE) >> $@
	cat $< >> $@


$(TERMUXDIR)/DEBIAN/control: $(TERMUXDIR)/DEBIAN
	echo 'Package: $(PKGNAME)' > $@
	echo 'Version: $(VERSION)' >> $@
	echo 'Architecture: $(DARCHI)' >> $@
	echo 'Depends: $(DEBIANDEPS)' >> $@
	echo 'Description: $(DESCRIPTION)' >> $@
	echo 'Section: main' >> $@
	echo 'Priority: optional' >> $@
	echo 'Maintainer: $(AUTHOR) <$(MAIL)>' >> $@
	echo 'Homepage: $(URL)' >> $@
	echo 'Installed-Size: 1' >> $@

#$(TERMUXDIR)/DEBIAN/conffiles: $(TERMUXDIR)/DEBIAN
#	echo '/etc/sstab' > $@

pkg_termux: $(TERMUXPKG)
$(TERMUXPKG): $(TERMUXDIR)
	cp README.md $(TERMUXDIR)/DEBIAN/README
	dpkg-deb --build --root-owner-group $(TERMUXDIR)

#$(TERMUXDIR): $(TERMUXDIR)/DEBIAN/control $(TERMUXDIR)/DEBIAN/copyright $(TERMUXDIR)/DEBIAN/conffiles
$(TERMUXDIR): $(TERMUXDIR)/DEBIAN/control $(TERMUXDIR)/DEBIAN/copyright
	#make install_elf_static DESTDIR=$(TERMUXDIR) PREFIX=$(TERMUXPREFIX) CC=aarch64-linux-gnu-gcc
	make install DESTDIR=$(TERMUXDIR) PREFIX=$(TERMUXPREFIX)
	sed -i "s/Installed-Size:.*/Installed-Size:\ $$(du -ks $(TERMUXDIR) | cut -f1)/" $<

clean_termux:
	rm -rf control DEBIAN DEBIANTEMP $(TERMUXDIR)

purge_termux:
	rm -f $(TERMUXPKG)
