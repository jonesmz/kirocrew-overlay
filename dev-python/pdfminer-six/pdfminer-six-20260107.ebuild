# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

# Upstream project name on PyPI is "pdfminer.six"; the eclass normalizes the
# dotted name to the pdfminer_six-${PV}.tar.gz sdist.
PYPI_PN="pdfminer.six"

inherit distutils-r1 pypi

DESCRIPTION="PDF parser and analyzer (community-maintained pdfminer fork)"
HOMEPAGE="
	https://github.com/pdfminer/pdfminer.six/
	https://pdfminersix.readthedocs.io/
	https://pypi.org/project/pdfminer.six/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

# Upstream builds the version string with setuptools-scm from the VCS; feed it
# the ebuild version so the sdist (which ships no .git) builds reproducibly.
export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"

RDEPEND="
	>=dev-python/charset-normalizer-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
