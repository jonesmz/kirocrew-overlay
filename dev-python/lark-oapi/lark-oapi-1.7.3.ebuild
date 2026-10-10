# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Feishu/Lark Open Platform SDK for Python"
HOMEPAGE="
	https://github.com/larksuite/oapi-sdk-python/
	https://pypi.org/project/lark-oapi/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/requests-2.25[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.9[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.9[${PYTHON_USEDEP}]
	>=dev-python/websockets-11[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.24[${PYTHON_USEDEP}]
"
