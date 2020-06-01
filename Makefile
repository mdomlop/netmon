NAME='netmon'
PREFIX = '/usr'
DESTDIR = ''
CFLAGS = -march=native -mtune=native -O2 -Wall -ansi -pedantic -static

src/netmon:

install:
	install -Dm 755 src/$(NAME) $(DESTDIR)$(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(NAME)/README

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/LICENSE

arch_clean:
	rm -rf src/$(NAME) $(NAME)-*.pkg.tar.xz pkg

clean: arch_clean

arch_pkg:
	makepkg
