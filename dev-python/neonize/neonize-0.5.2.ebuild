# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# neonize publishes NO sdist: upstream ships prebuilt wheels that bundle the Go
# whatsmeow core as a precompiled shared library. There is no supported way to
# build it from source here, so we install the upstream wheel directly. The
# wheel is tagged py310-none-manylinux (Python-ABI-independent — it is a pure
# ctypes wrapper around the .so), so one wheel per arch serves 3.11-3.13.
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_PV_TAG="py310-none"
DESCRIPTION="Python binding for whatsmeow (WhatsApp Web multidevice library)"
HOMEPAGE="
	https://github.com/krypton-byte/neonize/
	https://pypi.org/project/neonize/
"
SRC_URI="
	amd64? ( https://files.pythonhosted.org/packages/9d/21/5230e201176c1d405bb291dda66bb31efe85f78ac02ef60bc2a6f634990b/${PN}-${PV}-${MY_PV_TAG}-manylinux2014_x86_64.whl )
	arm64? ( https://files.pythonhosted.org/packages/ec/54/be02d1f3eabdb8f7659f16d0ac7c28b75f78bd36fdf151117b33dd49dd7e/${PN}-${PV}-${MY_PV_TAG}-manylinux2014_aarch64.whl )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
# Precompiled binary distribution.
RESTRICT="bindist strip test"

RDEPEND="
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/linkpreview-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/phonenumbers-8.13.52[${PYTHON_USEDEP}]
	>=dev-python/pillow-11.1.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-6.32.1[${PYTHON_USEDEP}]
	>=dev-python/python-magic-0.4.27[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/segno-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.67.1[${PYTHON_USEDEP}]
"

# The .whl is consumed directly from DISTDIR by distutils_wheel_install; no
# unpack of a source tree is needed.
src_unpack() { :; }

python_install() {
	local wheel
	if use amd64; then
		wheel="${DISTDIR}/${PN}-${PV}-${MY_PV_TAG}-manylinux2014_x86_64.whl"
	elif use arm64; then
		wheel="${DISTDIR}/${PN}-${PV}-${MY_PV_TAG}-manylinux2014_aarch64.whl"
	else
		die "no prebuilt neonize wheel for this arch"
	fi
	distutils_wheel_install "${D}$(python_get_sitedir)" "${wheel}"
}
