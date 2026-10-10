# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Get title, description, image and other metadata from a link (preview)"
HOMEPAGE="
	https://github.com/meyt/linkpreview/
	https://pypi.org/project/linkpreview/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.4.0[${PYTHON_USEDEP}]
"
