# Maintainer: Manuel Domínguez López <mdomlop at gmail dot com>

_pkgver_year=2020
_pkgver_month=06
_pkgver_day=01

pkgname=netmon
pkgver=0.9
pkgrel=1
pkgdesc="Simple console network traffic monitor."
arch=('i686' 'x86_64')
url="https://github.com/mdomlop/$pkgname"
source=()
license=('GPL3')

build() {
    cd $startdir
    make
    }

package() {
    cd $startdir
    make install DESTDIR=$pkgdir
}
