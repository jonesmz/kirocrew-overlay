# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Plumb a PDF for detailed information about each text char, rect, and line"
HOMEPAGE="
	https://github.com/jsvine/pdfplumber/
	https://pypi.org/project/pdfplumber/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

# pdfminer.six is packaged in ::gentoo as app-text/pdfminer (same upstream,
# same PyPI id). pdfplumber pins pdfminer.six==20260107.
RDEPEND="
	~app-text/pdfminer-20260107[${PYTHON_USEDEP}]
	>=dev-python/pillow-12.2.0[${PYTHON_USEDEP}]
	>=dev-python/pypdfium2-5.9.0[${PYTHON_USEDEP}]
"
