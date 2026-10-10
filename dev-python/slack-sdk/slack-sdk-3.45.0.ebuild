# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Slack Developer Kit (SDK) for Python"
HOMEPAGE="
	https://slack.dev/python-slack-sdk/
	https://github.com/slackapi/python-slack-sdk/
	https://pypi.org/project/slack-sdk/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# The core package has no mandatory runtime dependencies: every entry in
# upstream's requires_dist is gated behind the "optional" extra (aiohttp,
# websockets, SQLAlchemy, boto3, ...). KiroCrew only uses the core Web/RTM
# clients over its own aiohttp, which is already pulled by app-misc/kirocrew.
# Hence no RDEPEND is declared.
