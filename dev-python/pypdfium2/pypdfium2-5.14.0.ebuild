# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# pypdfium2 wraps Google's PDFium C library. Building PDFium from source needs
# Chromium's depot_tools/gn toolchain (impractical for an overlay), and there is
# no PDFium package in ::gentoo to link against. Upstream ships prebuilt wheels
# that bundle the PDFium shared library; the Python half is a py3-none
# (ABI-independent) ctypes wrapper, so one glibc wheel per arch serves 3.11-3.13.
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python bindings to PDFium (bundled prebuilt PDFium library)"
HOMEPAGE="
	https://github.com/pypdfium2-team/pypdfium2/
	https://pypi.org/project/pypdfium2/
"
SRC_URI="
	amd64? ( https://files.pythonhosted.org/packages/4f/a3/c9cc797fc8bdfb8f37b9b0f8b9d02a5fc196b2015f408d53624cab5b0519/${PN}-${PV}-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl )
	arm64? ( https://files.pythonhosted.org/packages/92/b4/0c31aa51887cd6cd032191dfe010a6d01ed43cf03204cfbd2184ebe4b715/${PN}-${PV}-py3-none-manylinux_2_17_aarch64.manylinux2014_aarch64.whl )
"

# pypdfium2 itself: BSD-3 OR Apache-2.0. The bundled PDFium library is
# BSD-3-Clause (Google/Chromium PDF engine).
LICENSE="|| ( Apache-2.0 BSD ) BSD"
SLOT="0"
KEYWORDS="-* amd64 arm64"
RESTRICT="bindist strip test"

src_unpack() { :; }

python_install() {
	local wheel
	if use amd64; then
		wheel="${DISTDIR}/${PN}-${PV}-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
	elif use arm64; then
		wheel="${DISTDIR}/${PN}-${PV}-py3-none-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
	else
		die "no prebuilt pypdfium2 wheel for this arch"
	fi
	distutils_wheel_install "${D}$(python_get_sitedir)" "${wheel}"
}
