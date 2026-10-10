# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Upstream declares requires-python >=3.12 and only tests/ships 3.12-3.13.
PYTHON_COMPAT=( python3_{12..13} )

# npm.eclass supplies the offline dashboard build (NPM_DEPS -> NPM_SRC_URI,
# npm_ci, npm_run). NPM_DEPS is a PRE_INHERIT variable, so it must be set
# before `inherit npm`. We inherit distutils-r1 LAST so its src_* phase
# functions win the EXPORT_FUNCTIONS race; the ebuild then defines its own
# src_unpack/src_compile that call the npm helpers explicitly.
NPM_NODE_MIN=22

# @VARIABLE: NPM_DEPS
# The FULL package-lock.json closure of website/ (KiroCrew's Vite/React
# dashboard). This is a placeholder: regenerate it on every version bump with
#
#   scripts/gen-npm-deps.py <checkout>/website/package-lock.json
#
# and paste the output here, then `ebuild <this> manifest` to hash every
# dependency distfile. Until it is populated, the dashboard cannot be built
# offline (see src_compile's fallback and pkg_pretend).
NPM_DEPS="
	REGENERATE_WITH_scripts/gen-npm-deps.py
"

inherit npm distutils-r1

DESCRIPTION="Self-hosted persistent personal AI agent (CLI, dashboard, chat channels)"
HOMEPAGE="https://github.com/kirodotdev/KiroCrew"

# KiroCrew is NOT published on PyPI; the pip name is "kirocrew" but the only
# source of truth is the GitHub repo. Upstream tags clean releases as vX.Y.Z
# (ignoring the parallel v*-insider / v*-rc preview tags). The GitHub archive
# unpacks to KiroCrew-${PV}, hence S below.
MY_PN="KiroCrew"
SRC_URI="
	https://github.com/kirodotdev/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${NPM_SRC_URI}
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Optional messaging channels / integrations mirror upstream's
# [options.extras_require]. Core install stays lean; each flag pulls the
# distributions that extra documents. See metadata.xml.
IUSE="otlp perf teams whatsapp feishu voice"

# net-libs/nodejs is pulled in by npm.eclass via NPM_NODE_MIN.

# Runtime dependencies, from setup.cfg install_requires. The platform-gated
# entries (truststore/darwin, tzdata/tzlocal/pywinpty/Windows,
# pysqlite3-binary/linux-x86_64) are omitted: they are no-ops or source-provided
# on a Linux Gentoo system. Every dependency below is provided either by
# ::gentoo or by this overlay (see dev-python/* and dev-util/uv here).
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/aiohttp-3.9[${PYTHON_USEDEP}]
		dev-python/yarl[${PYTHON_USEDEP}]
		dev-python/multidict[${PYTHON_USEDEP}]
		dev-python/slack-sdk[${PYTHON_USEDEP}]
		>=dev-python/websockets-12[${PYTHON_USEDEP}]
		dev-python/cron-descriptor[${PYTHON_USEDEP}]
		dev-python/croniter[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.12[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-4.26[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21[${PYTHON_USEDEP}]
		dev-python/snowballstemmer[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.1[${PYTHON_USEDEP}]
		>=dev-python/python-docx-1[${PYTHON_USEDEP}]
		>=dev-python/pdfplumber-0.10[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7[${PYTHON_USEDEP}]
		>=dev-python/qrcode-7.4[${PYTHON_USEDEP}]
		>=dev-python/cryptography-42[${PYTHON_USEDEP}]
		>=dev-python/requests-2.28[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-api-1[${PYTHON_USEDEP}]
		>=dev-python/opentelemetry-sdk-1[${PYTHON_USEDEP}]
		>=dev-util/uv-0.6.7[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		otlp? ( dev-python/opentelemetry-exporter-otlp-proto-http[${PYTHON_USEDEP}] )
		teams? ( dev-python/pyjwt[${PYTHON_USEDEP}] )
		feishu? ( dev-python/lark-oapi[${PYTHON_USEDEP}] )
		voice? (
			>=dev-python/boto3-1.34[${PYTHON_USEDEP}]
			dev-python/amazon-transcribe[${PYTHON_USEDEP}]
			dev-python/pywhispercpp[${PYTHON_USEDEP}]
		)
	')
	whatsapp? ( dev-python/neonize )
	perf? ( dev-util/py-spy )
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

# npm.eclass and distutils-r1 both EXPORT_FUNCTIONS for src_unpack/src_compile.
# Define them here so the ebuild's versions win and we can interleave the two:
# npm's offline dashboard build, then the normal Python PEP517 build.

src_unpack() {
	# npm_src_unpack unpacks only the project source (the GitHub archive) and
	# leaves the ~thousand npm dependency tarballs in DISTDIR for npm_ci to read.
	npm_src_unpack
}

src_compile() {
	# 1. Build the Vite/React dashboard offline, then stage it into
	#    src/kiro_crew/static/dist exactly as upstream's `make build` does
	#    (npm run build -> `kiro_crew.frontend stage`), so the wheel carries it.
	if [[ -d website ]]; then
		einfo "Building the KiroCrew dashboard offline (npm.eclass)"
		pushd website >/dev/null || die
		npm_ci
		npm_run build
		popd >/dev/null || die

		# Stage the built dashboard into the Python package tree. Uses the
		# first configured interpreter; the staged assets are pure data shared
		# by every python_compile pass.
		local stage_py="${EPYTHON:-python3}"
		"${stage_py}" -m kiro_crew.frontend stage . \
			|| die "frontend stage step failed"
	fi

	distutils-r1_src_compile
}

pkg_pretend() {
	if [[ ${NPM_DEPS} == *REGENERATE_WITH* ]]; then
		ewarn "NPM_DEPS in this ebuild is a placeholder. The dashboard cannot be"
		ewarn "built offline until it is regenerated from website/package-lock.json:"
		ewarn "  scripts/gen-npm-deps.py <checkout>/website/package-lock.json"
		ewarn "then re-run: ebuild ${P}.ebuild manifest"
	fi
}

pkg_postinst() {
	elog "Start the gateway (dashboard + channels + task runner) with:"
	elog "  kirocrew gateway"
	elog
	elog "First-run setup and configuration live under ~/.kiro/ by default."
	elog "See https://github.com/kirodotdev/KiroCrew/blob/main/docs/guides/install.md"
}
