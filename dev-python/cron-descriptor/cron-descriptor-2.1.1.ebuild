# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Convert cron expressions into human-readable descriptions"
HOMEPAGE="
	https://github.com/Salamek/cron-descriptor/
	https://pypi.org/project/cron-descriptor/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
