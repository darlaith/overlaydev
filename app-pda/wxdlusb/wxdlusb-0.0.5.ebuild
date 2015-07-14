# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="User-friendly Linux support for the Timex Data Link USB Watch"
HOMEPAGE="http://wxdlusb.sourceforge.net/index.htm"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/wxGTK
	
"
RDEPEND="${DEPEND}"