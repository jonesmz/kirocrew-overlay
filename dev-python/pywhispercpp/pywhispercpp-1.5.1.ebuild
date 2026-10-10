# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for whisper.cpp (OpenAI Whisper speech recognition)"
HOMEPAGE="
	https://github.com/absadiki/pywhispercpp/
	https://pypi.org/project/pywhispercpp/
"

# The sdist vendors the whisper.cpp and pybind11 git submodules, so the C++
# core builds self-contained (no network, no system whisper.cpp needed).
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
"
# pybind11 extension compiled through cmake + ninja (declared in build-system
# requires); provide the native toolchain at build time.
BDEPEND="
	>=dev-build/cmake-3.18
	dev-build/ninja
	dev-python/pybind11[${PYTHON_USEDEP}]
"
