# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qmake-utils git-r3

DESCRIPTION="Cross-platform content manager assistant for the PS Vita"
HOMEPAGE="https://github.com/codestation/qcma"
#SRC_URI="https://github.com/codestation/qcma/archive/v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm"
IUSE="-X -qt4 +qt5"

LANGS="es ja"

EGIT_REPO_URI="ssh://system@aldebaran/var/lib/git_repos/sonyps/qcma.git"
EGIT_BRANCH="develop"

REQUIRED_USE="
	|| ( qt4 qt5 )
"

DEPEND="games-util/vitamtp
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtnetwork:4
		dev-qt/qtsql:4[sqlite]
		X? (
			dev-qt/linguist-tools:4
			dev-qt/qtgui:4
			dev-qt/qtmultimedia:4
		)
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtsql:5[sqlite]
		X? (
			dev-qt/linguist-tools:5
			dev-qt/qtgui:5
			dev-qt/qtmultimedia:5
		)
	)
	virtual/ffmpeg
"

S="${WORKDIR}/qcma-${PV}"

src_prepare() {
	if use X ; then
		lrelease "${S}"/qcma.pro
	fi
}

src_configure() {
	if use qt4 ; then
		eqmake4 "${S}"/qcma.pro
	else
		#eqmake5 "${S}"/cli/cli.pro
		eqmake5 "${S}"/qcma.pro
		eqmake5 $(use !X && echo CONFIG-=gui)
	fi
}
