# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A small loopback mount utility using FUSE"
HOMEPAGE="https://github.com/jmattsson/fuseloop"
SRC_URI="https://github.com/jmattsson/fuseloop/archive/1.0.3.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-fs/fuse
	sys-libs/zlib
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( LICENSE.txt README.md )

