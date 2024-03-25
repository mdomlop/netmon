OCSPKG = $(PKGNAME).tar.xz

pkg_ocs: $(OCSPKG)
$(OCSPKG):
	make install DESTDIR=$(PKGNAME) PREFIX=$(PREFIX)
	tar cJf $(PKGNAME).tar.xz $(PKGNAME)

clean_ocs:
	rm -rf $(PKGNAME)

purge_ocs:
	rm -f $(OCSPKG)
