# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdrm/libdrm-2.4.62.ebuild,v 1.1 2015/07/02 00:32:21 mattst88 Exp $

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2 git-2

DESCRIPTION="X.Org libdrm library (amdgpu branch)"
HOMEPAGE="http://dri.freedesktop.org/"

#EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"
EGIT_REPO_URI="git://people.freedesktop.org/~agd5f/drm"
EGIT_BRANCH="amdgpu"

#LICENSE=""
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux"
VIDEO_CARDS="exynos freedreno intel nouveau omap radeon amdgpu tegra vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} libkms valgrind"
RESTRICT="test" # see bug #236845

RDEPEND=">=dev-libs/libpthread-stubs-0.3-r1:=[${MULTILIB_USEDEP}]
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"

src_prepare() {
	# tests are restricted, no point in building them
	sed -ie 's/tests //' "${S}"/Makefile.am
	# bug in makefile include
	sed -ie 's|<drm/drm.h|<drm.h>|g' "${S}"/include/drm/amdgpu_drm.h
	xorg-2_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		# Udev is only used by tests now.
		--disable-udev
		--disable-cairo-tests
		$(use_enable video_cards_exynos exynos-experimental-api)
		$(use_enable video_cards_freedreno freedreno)
		$(use_enable video_cards_intel intel)
		$(use_enable video_cards_nouveau nouveau)
		$(use_enable video_cards_omap omap-experimental-api)
		$(use_enable video_cards_radeon radeon)
		$(use_enable video_cards_amdgpu amdgpu)
		$(use_enable video_cards_tegra tegra-experimental-api)
		$(use_enable video_cards_vmware vmwgfx)
		$(use_enable libkms)
		# valgrind installs its .pc file to the pkgconfig for the primary arch
		--enable-valgrind=$(usex valgrind auto no)
	)

	xorg-2_src_configure
}
