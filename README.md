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

## Dependencies

Every KiroCrew runtime dependency resolves against `::gentoo` plus this
overlay. The ones not in the tree are packaged here:

- `dev-python/slack-sdk`, `cron-descriptor`, `python-docx`, `linkpreview`
- `dev-python/pdfplumber` (+ `pypdfium2`; pdfminer.six is the tree's
  `app-text/pdfminer`)
- `dev-python/lark-oapi` (feishu), `amazon-transcribe` + `pywhispercpp`
  (voice), `neonize` (whatsapp)
- `dev-python/opentelemetry-proto`,
  `opentelemetry-exporter-otlp-proto-{common,http}` (otlp)

`uv` is **not** shipped here — it is already in the tree as
`dev-python/uv`. `neonize` and `pypdfium2` install upstream prebuilt
wheels (they bundle a Go / PDFium shared library with no practical source
build); everything else builds from source.

KiroCrew drives the proprietary `kiro-cli` agent runtime, pulled in as
`dev-util/kiro-cli-bin`. That package lives in the **stowe-verlay**
overlay, not `::gentoo` and not here, so enable that overlay too (or
provide your own `dev-util/kiro-cli-bin`) for the dependency to resolve.

Only `kirocrew` and its always-pulled chain are keyworded stable. The
optional `voice`, `whatsapp`, and `perf` flags pull dependencies that are
`~arch` (they track `~arch` tree packages such as `dev-util/py-spy`), so
enabling one needs the matching `package.accept_keywords` entry.

## Enabling the overlay

```sh
eselect repository add kirocrew-overlay git <path-or-url>
# or drop a repos.conf entry pointing location= at this directory
emaint sync -r kirocrew-overlay
emerge -av app-misc/kirocrew
```
