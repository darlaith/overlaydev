# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="Command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
EGIT_REPO_URI="https://github.com/popcornmix/omxplayer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libpcre
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	virtual/ffmpeg
	sys-apps/dbus
	sys-apps/fbset"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0_p20150421-Makefile.patch

	cat > Makefile.include << EOF
LIBS=-lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX
}

src_compile() {
	emake ${PN}.bin
}

src_install() {
	dobin ${PN} ${PN}.bin
	dodoc README.md
}