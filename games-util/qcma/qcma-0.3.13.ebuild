# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="Cross-platform content manager assistant for the PS Vita"
HOMEPAGE="https://github.com/codestation/qcma"
SRC_URI="https://github.com/codestation/qcma/archive/v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE="-X -qt4 +qt5"

LANGS="es ja"

REQUIRED_USE="
	|| ( qt4 qt5 )
"

DEPEND="games-util/vitamtp
	qt4? (
		dev-qt/qtcore:4
		X? (
			dev-qt/qtgui:4
			dev-qt/qtdbus:4
			dev-qt/qtsql:4
			dev-qt/qtmultimedia:4
		)
	)
	qt5? (
		dev-qt/qtcore:5
		X? (
			dev-qt/qtgui:5
			dev-qt/qtdbus:5
			dev-qt/qtsql:5
			dev-qt/qtmultimedia:5
		)
	)
	virtual/ffmpeg"

S="${WORKDIR}/qcma-${PV}"

src_prepare() {
	lrelease "${S}"/qcma.pro
}

src_configure() {
	eqmake4 "${S}"/qcma.pro
}
