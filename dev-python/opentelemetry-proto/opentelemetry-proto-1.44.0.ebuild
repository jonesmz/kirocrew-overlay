# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_P="opentelemetry-python-${PV}"
DESCRIPTION="OpenTelemetry Python Proto (protobuf-generated OTLP types)"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-proto/
	https://github.com/open-telemetry/opentelemetry-python/
"
# Same monorepo tarball as ::gentoo's dev-python/opentelemetry-api, so the
# distfile is shared; only S differs (this package lives in a subdirectory).
SRC_URI="
	https://github.com/open-telemetry/opentelemetry-python/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/protobuf-5[${PYTHON_USEDEP}]
	<dev-python/protobuf-8[${PYTHON_USEDEP}]
"
