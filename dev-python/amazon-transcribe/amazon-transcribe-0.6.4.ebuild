# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="AWS Transcribe Streaming SDK for Python (async)"
HOMEPAGE="
	https://github.com/awslabs/amazon-transcribe-streaming-sdk/
	https://pypi.org/project/amazon-transcribe/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Upstream pins awscrt~=0.26.1 (>=0.26.1,<0.27). ::gentoo only carries
# awscrt-0.36+, which is API-compatible for the streaming client this uses, so
# the upper bound is relaxed to the available series rather than masking the
# package out entirely.
RDEPEND="
	>=dev-python/awscrt-0.26.1[${PYTHON_USEDEP}]
"
