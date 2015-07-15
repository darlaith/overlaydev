# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-amdgpu/xf86-video-amdgpu-0.1.ebuild,v 1.8 2015/02/24 08:37:58 ago Exp $

EAPI=5

XORG_DRI=always
inherit linux-info xorg-2

DESCRIPTION="AMDGPU video driver"
HOMEPAGE="http://www.x.org/wiki/ati/"

KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="+glamor udev"

EGIT_REPO_URI="git://anongit.freedesktop.org/git/xorg/driver/xf86-video-amdgpu"

RDEPEND=">=x11-libs/libdrm-2.4.58[video_cards_radeon,video_card_amdgpu]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( || (
		x11-base/xorg-server[glamor]
		>=x11-libs/glamor-0.6
	) )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}