# kirocrew-overlay

A Gentoo overlay packaging **[KiroCrew](https://github.com/kirodotdev/KiroCrew)**
(`app-misc/kirocrew`) — a self-hosted, persistent personal AI agent you chat
with from a web dashboard, the CLI, or messaging channels (Slack, Discord,
Telegram, and others).

## What the ebuild does

KiroCrew is **not published on PyPI**. It is a setuptools project (`pip` install
name `kirocrew`, import package `kiro_crew`) whose wheel bundles a prebuilt
Vite/React dashboard. The ebuild therefore:

1. Fetches the tagged GitHub source archive.
2. Builds the `website/` dashboard with `npm` (Node.js) and stages it into
   `src/kiro_crew/static/dist`, matching upstream's `make build` →
   `kiro_crew.frontend stage` step.
3. Installs the backend with `distutils-r1` (setuptools / PEP 517).

The result exposes the `kirocrew` console script
(`kiro_crew._bootstrap:main`).

## USE flags

The ebuild keeps the core install lean and gates the optional messaging /
media integrations behind USE flags, mirroring KiroCrew's `extras_require`.
See `app-misc/kirocrew/metadata.xml` for the full list.

## Caveats

A handful of KiroCrew's runtime dependencies are not in `::gentoo`
(for example `dev-python/cron-descriptor`, `dev-python/slack-sdk`,
`dev-python/snowballstemmer`, and `dev-util/uv`). Where no tree package
exists, the ebuild documents the gap inline. You may need additional overlays
(e.g. `::guru`) or local ebuilds for those before `kirocrew` will install
cleanly. Treat this ebuild as a working starting point rather than a
tree-ready, fully-dependency-resolved package.

## Enabling the overlay

```sh
eselect repository add kirocrew-overlay git <path-or-url>
# or drop a repos.conf entry pointing location= at this directory
emaint sync -r kirocrew-overlay
emerge -av app-misc/kirocrew
```
