# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/RetroShare/RetroShare.git"
inherit eutils git-r3 gnome2-utils qmake-utils versionator

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.net"

# pegmarkdown can also be used with MIT
LICENSE="GPL-2 GPL-3 Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"

IUSE="cli feedreader gnome-keyring +gui +libressl voip"
REQUIRED_USE="
	|| ( cli gui )
	feedreader? ( gui )
	voip? ( gui )"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlcipher
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl:0 )
	dev-qt/qtcore:5
	gui? (
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtxml:5
	)
	net-libs/libmicrohttpd
	net-libs/libupnp:0
	sys-libs/zlib
	gnome-keyring? ( gnome-base/libgnome-keyring )
	feedreader? (
		dev-libs/libxml2
		dev-libs/libxslt
		net-misc/curl
	)
	gui? (
		dev-qt/designer:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
	voip? (
		media-libs/opencv[-qt4(-)]
		media-libs/speex
		virtual/ffmpeg[encode]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local dir

	sed -i \
		-e "s|/usr/lib/retroshare/extensions6/|/usr/$(get_libdir)/${PN}/extensions6/|" \
		libretroshare/src/rsserver/rsinit.cc \
		|| die "sed on libretroshare/src/rsserver/rsinit.cc failed"

	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src libresapi/src supportlibs/pegmarkdown"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use feedreader && rs_src_dirs="${rs_src_dirs} plugins/FeedReader"
	use gui && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use voip && rs_src_dirs="${rs_src_dirs} plugins/VOIP"

	# Force linking to sqlcipher ONLY
	sed -i \
		-e '/isEmpty(SQLCIPHER_OK) {/aerror(libsqlcipher not found)' \
		retroshare-gui/src/retroshare-gui.pro \
		retroshare-nogui/src/retroshare-nogui.pro || die 'sed on retroshare-gui/src/retroshare-gui.pro failed'

	# Avoid openpgpsdk false dependency on qtgui
	sed -i '2iQT -= gui' openpgpsdk/src/openpgpsdk.pro || die

	eapply_user
}

src_configure() {
	for dir in ${rs_src_dirs} ; do
		pushd "${S}/${dir}" >/dev/null || die
		eqmake5 $(user gnome-keyring && echo CONFIG+=rs_autologin)
		popd >/dev/null || die
	done
}

src_compile() {
	local dir

	for dir in ${rs_src_dirs} ; do
		emake -C "${dir}"
	done

	unset rs_src_dirs
}

src_install() {
	local i
	local extension_dir="/usr/$(get_libdir)/${PN}/extensions6/"

	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use gui && dobin retroshare-gui/src/retroshare

	exeinto "${extension_dir}"
	use feedreader && doexe plugins/FeedReader/*.so*
	use voip && doexe plugins/VOIP/*.so*

	insinto /usr/share/retroshare
	doins libbitdht/src/bitdht/bdboot.txt

	doins -r libresapi/src/webui

	dodoc README.md
	make_desktop_entry RetroShare06
	for i in 24 48 64 128 ; do
		doicon -s ${i} "data/${i}x${i}/apps/retroshare.png"
	done
}

pkg_preinst() {
	local ver
	for ver in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 0.5.9999 ${ver}; then
			elog "You are upgrading from Retroshare 0.5.* to ${PV}"
			elog "Version 0.6.* is backward-incompatible with 0.5 branch"
			elog "and clients with 0.6.* can not connect to clients that have 0.5.*"
			elog "It's recommended to drop all your configuration and either"
			elog "generate a new certificate or import existing from a backup"
			break
		fi
		if version_is_at_least 0.6.0 ${ver}; then
			elog "Main executable was renamed upstream from RetroShare06 to retroshare"
			break
		fi
	done
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
