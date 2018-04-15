# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Multi Multicast DVB to redistribute streams from DVB or ATSC"
HOMEPAGE="http://mumudvb.net"
SRC_URI="https://github.com/braice/MuMuDVB/archive/2.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	media-tv/dvbtune
	media-tv/linuxtv-dvb-apps"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	S="${WORKDIR}/MuMuDVB-${PV}"
}

src_prepare() {
	autoreconf -i -f
	default
}

src_install() {
	default
	doinitd "${FILESDIR}/mumudvb"
	#doinitd "${S}/scripts/debian/etc/init.d/mumudvb"
	insinto "/etc"
	doins "${FILESDIR}/mumudvb.conf"
}
