# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel-next/genkernel-next-60.ebuild,v 1.1 2015/01/20 08:25:58 lxnay Exp $

EAPI=5

#if [[ "${PV}" != "9999" ]]; then
#	SRC_URI="http://dev.gentoo.org/~lxnay/genkernel-next/${P}.tar.xz"
#else
#	EGIT_REPO_URI="git://github.com/Sabayon/genkernel-next.git"
#	inherit git-2
#fi
SRC_URL="https://github.com/cs0rbagomba/genkernel-next/archive/denes.zip"

inherit bash-completion-r1 eutils

#if [[ "${PV}" == "9999" ]]; then
#	KEYWORDS=""
#else
#	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~x86"
#fi
KEYWORDS="~amd64"

#DESCRIPTION="Gentoo automatic kernel building scripts, reloaded"
#HOMEPAGE="http://www.gentoo.org"
DESCRIPTION="Fork of genkernel-next with sakaki's staticgpg and rmeote LUKS header."
HOMEPAGE="https://github.com/cs0rbagomba/genkernel-next/"


LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
#IUSE="cryptsetup dmraid gpg iscsi plymouth selinux"
IUSE="cryptsetup staticgpg zfs"


DEPEND="app-text/asciidoc
	sys-fs/e2fsprogs
	!sys-fs/eudev[-kmod,modutils]
	selinux? ( sys-libs/libselinux )"

#RDEPEND="${DEPEND}
#	!sys-kernel/genkernel
#	cryptsetup? ( sys-fs/cryptsetup )
#	dmraid? ( >=sys-fs/dmraid-1.0.0_rc16 )
#	gpg? ( app-crypt/gnupg )
#	iscsi? ( sys-block/open-iscsi )
#	plymouth? ( sys-boot/plymouth )
#	app-portage/portage-utils
#	app-arch/cpio
#	>=app-misc/pax-utils-0.6
#	!<sys-apps/openrc-0.9.9
#	sys-apps/util-linux
#	sys-block/thin-provisioning-tools
#	sys-fs/lvm2"

RDEPEND="${DEPEND}
	!sys-kernel/genkernel
	!sys-kernel/genkernel-next
	cryptsetup? ( sys-fs/cryptsetup )
	staticgpg? ( app-crypt/staticgpg )
	zfs ? ( sys-kernel/zfs )
	app-portage/portage-utils
	app-arch/cpio
	>=app-misc/pax-utils-0.6
	!<sys-apps/openrc-0.9.9
	sys-apps/util-linux
	sys-block/thin-provisioning-tools
	sys-fs/lvm2"


src_prepare() {
	sed -i "/^GK_V=/ s:GK_V=.*:GK_V=${PV}:g" "${S}/genkernel" || \
		die "Could not setup release"

	epatch_user
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	doman "${S}"/genkernel.8 || die "doman"
	dodoc "${S}"/AUTHORS || die "dodoc"

	newbashcomp "${S}"/genkernel.bash genkernel
}
