# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

# Live ebuild: the dashboard's npm closure is not pinned (the branch moves), so
# the offline npm.eclass path does not apply. We fetch node_modules with a
# normal `npm ci`, which needs network at build time (FEATURES="-network-sandbox").
inherit distutils-r1 git-r3

DESCRIPTION="Self-hosted persistent personal AI agent (CLI, dashboard, chat channels)"
HOMEPAGE="https://github.com/kirodotdev/KiroCrew"
EGIT_REPO_URI="https://github.com/kirodotdev/KiroCrew.git"
EGIT_BRANCH="main"

LICENSE="Apache-2.0"
SLOT="0"
# Live ebuild: no KEYWORDS so it stays ~unkeyworded (install via keyword mask).

IUSE="otlp perf teams whatsapp feishu voice"

BDEPEND="
	>=net-libs/nodejs-22.12[npm]
"

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

src_compile() {
	if [[ -d website ]]; then
		einfo "Building the KiroCrew dashboard (npm, needs network)"
		pushd website >/dev/null || die
		npm ci || npm install || die "npm install failed"
		npm run build || die "dashboard build failed"
		popd >/dev/null || die

		"${EPYTHON:-python3}" -m kiro_crew.frontend stage . \
			|| die "frontend stage step failed"
	fi

	distutils-r1_src_compile
}

pkg_pretend() {
	ewarn "This live ebuild builds the dashboard with a networked 'npm ci', so"
	ewarn "it needs FEATURES=\"-network-sandbox\". For a reproducible offline"
	ewarn "build, use the versioned app-misc/kirocrew ebuild instead."
}

pkg_postinst() {
	elog "Start the gateway (dashboard + channels + task runner) with:"
	elog "  kirocrew gateway"
	elog
	elog "First-run setup and configuration live under ~/.kiro/ by default."
	elog "See https://github.com/kirodotdev/KiroCrew/blob/main/docs/guides/install.md"
}
