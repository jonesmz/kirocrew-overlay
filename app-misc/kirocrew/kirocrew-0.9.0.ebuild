# Copyright 2026 Michael Jones
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Upstream declares requires-python >=3.12 and only tests/ships 3.12-3.13.
PYTHON_COMPAT=( python3_{12..14} )

# npm.eclass supplies the offline dashboard build (NPM_DEPS -> NPM_SRC_URI,
# npm_ci, npm_run). NPM_DEPS is a PRE_INHERIT variable, so it must be set
# before `inherit npm`. We inherit distutils-r1 LAST so its src_* phase
# functions win the EXPORT_FUNCTIONS race; the ebuild then defines its own
# src_unpack/src_compile that call the npm helpers explicitly.
NPM_NODE_MIN=22

# @VARIABLE: NPM_DEPS
# The FULL package-lock.json closure of website/ (KiroCrew's Vite/React
# dashboard), the dependency set the offline build installs. Regenerate on
# every version bump with:
#
#   scripts/gen-npm-deps.py <checkout>/website/package-lock.json
#
# then re-run `pkgdev manifest` (or `ebuild <this> manifest`) to hash every
# dependency distfile.
NPM_DEPS="
	https://registry.npmjs.org/@adobe/css-tools/-/css-tools-4.5.0.tgz adobe+css-tools+css-tools-4.5.0.tgz
	https://registry.npmjs.org/@antfu/install-pkg/-/install-pkg-1.1.0.tgz antfu+install-pkg+install-pkg-1.1.0.tgz
	https://registry.npmjs.org/@asamuzakjp/css-color/-/css-color-3.2.0.tgz asamuzakjp+css-color+css-color-3.2.0.tgz
	https://registry.npmjs.org/@axe-core/react/-/react-4.11.3.tgz axe-core+react+react-4.11.3.tgz
	https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.29.7.tgz babel+code-frame+code-frame-7.29.7.tgz
	https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.29.7.tgz babel+compat-data+compat-data-7.29.7.tgz
	https://registry.npmjs.org/@babel/core/-/core-7.29.7.tgz babel+core+core-7.29.7.tgz
	https://registry.npmjs.org/@babel/generator/-/generator-7.29.7.tgz babel+generator+generator-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.29.7.tgz babel+helper-compilation-targets+helper-compilation-targets-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-globals/-/helper-globals-7.29.7.tgz babel+helper-globals+helper-globals-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.29.7.tgz babel+helper-module-imports+helper-module-imports-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.29.7.tgz babel+helper-module-transforms+helper-module-transforms-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.29.7.tgz babel+helper-string-parser+helper-string-parser-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.29.7.tgz babel+helper-validator-identifier+helper-validator-identifier-7.29.7.tgz
	https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.29.7.tgz babel+helper-validator-option+helper-validator-option-7.29.7.tgz
	https://registry.npmjs.org/@babel/helpers/-/helpers-7.29.7.tgz babel+helpers+helpers-7.29.7.tgz
	https://registry.npmjs.org/@babel/parser/-/parser-7.29.7.tgz babel+parser+parser-7.29.7.tgz
	https://registry.npmjs.org/@babel/runtime/-/runtime-7.29.7.tgz babel+runtime+runtime-7.29.7.tgz
	https://registry.npmjs.org/@babel/template/-/template-7.29.7.tgz babel+template+template-7.29.7.tgz
	https://registry.npmjs.org/@babel/traverse/-/traverse-7.29.7.tgz babel+traverse+traverse-7.29.7.tgz
	https://registry.npmjs.org/@babel/types/-/types-7.29.7.tgz babel+types+types-7.29.7.tgz
	https://registry.npmjs.org/@bcoe/v8-coverage/-/v8-coverage-1.0.2.tgz bcoe+v8-coverage+v8-coverage-1.0.2.tgz
	https://registry.npmjs.org/@braintree/sanitize-url/-/sanitize-url-6.0.2.tgz braintree+sanitize-url+sanitize-url-6.0.2.tgz
	https://registry.npmjs.org/@braintree/sanitize-url/-/sanitize-url-7.1.2.tgz braintree+sanitize-url+sanitize-url-7.1.2.tgz
	https://registry.npmjs.org/@chevrotain/types/-/types-11.1.2.tgz chevrotain+types+types-11.1.2.tgz
	https://registry.npmjs.org/@colors/colors/-/colors-1.5.0.tgz colors+colors+colors-1.5.0.tgz
	https://registry.npmjs.org/@csstools/color-helpers/-/color-helpers-5.1.0.tgz csstools+color-helpers+color-helpers-5.1.0.tgz
	https://registry.npmjs.org/@csstools/css-calc/-/css-calc-2.1.4.tgz csstools+css-calc+css-calc-2.1.4.tgz
	https://registry.npmjs.org/@csstools/css-color-parser/-/css-color-parser-3.1.0.tgz csstools+css-color-parser+css-color-parser-3.1.0.tgz
	https://registry.npmjs.org/@csstools/css-parser-algorithms/-/css-parser-algorithms-3.0.5.tgz csstools+css-parser-algorithms+css-parser-algorithms-3.0.5.tgz
	https://registry.npmjs.org/@csstools/css-tokenizer/-/css-tokenizer-3.0.4.tgz csstools+css-tokenizer+css-tokenizer-3.0.4.tgz
	https://registry.npmjs.org/@dicebear/core/-/core-9.4.3.tgz dicebear+core+core-9.4.3.tgz
	https://registry.npmjs.org/@dnd-kit/accessibility/-/accessibility-3.1.1.tgz dnd-kit+accessibility+accessibility-3.1.1.tgz
	https://registry.npmjs.org/@dnd-kit/core/-/core-6.3.1.tgz dnd-kit+core+core-6.3.1.tgz
	https://registry.npmjs.org/@dnd-kit/sortable/-/sortable-10.0.0.tgz dnd-kit+sortable+sortable-10.0.0.tgz
	https://registry.npmjs.org/@dnd-kit/utilities/-/utilities-3.2.2.tgz dnd-kit+utilities+utilities-3.2.2.tgz
	https://registry.npmjs.org/@egjs/hammerjs/-/hammerjs-2.0.17.tgz egjs+hammerjs+hammerjs-2.0.17.tgz
	https://registry.npmjs.org/@emnapi/core/-/core-1.11.0.tgz emnapi+core+core-1.11.0.tgz
	https://registry.npmjs.org/@emnapi/core/-/core-1.9.2.tgz emnapi+core+core-1.9.2.tgz
	https://registry.npmjs.org/@emnapi/runtime/-/runtime-1.11.0.tgz emnapi+runtime+runtime-1.11.0.tgz
	https://registry.npmjs.org/@emnapi/runtime/-/runtime-1.9.2.tgz emnapi+runtime+runtime-1.9.2.tgz
	https://registry.npmjs.org/@emnapi/wasi-threads/-/wasi-threads-1.2.1.tgz emnapi+wasi-threads+wasi-threads-1.2.1.tgz
	https://registry.npmjs.org/@emnapi/wasi-threads/-/wasi-threads-1.2.2.tgz emnapi+wasi-threads+wasi-threads-1.2.2.tgz
	https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.25.12.tgz esbuild+aix-ppc64+aix-ppc64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.25.12.tgz esbuild+android-arm+android-arm-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.25.12.tgz esbuild+android-arm64+android-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.25.12.tgz esbuild+android-x64+android-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.25.12.tgz esbuild+darwin-arm64+darwin-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.25.12.tgz esbuild+darwin-x64+darwin-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.25.12.tgz esbuild+freebsd-arm64+freebsd-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.25.12.tgz esbuild+freebsd-x64+freebsd-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.25.12.tgz esbuild+linux-arm+linux-arm-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.25.12.tgz esbuild+linux-arm64+linux-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.25.12.tgz esbuild+linux-ia32+linux-ia32-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.25.12.tgz esbuild+linux-loong64+linux-loong64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.25.12.tgz esbuild+linux-mips64el+linux-mips64el-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.25.12.tgz esbuild+linux-ppc64+linux-ppc64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.25.12.tgz esbuild+linux-riscv64+linux-riscv64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.25.12.tgz esbuild+linux-s390x+linux-s390x-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.25.12.tgz esbuild+linux-x64+linux-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/netbsd-arm64/-/netbsd-arm64-0.25.12.tgz esbuild+netbsd-arm64+netbsd-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.25.12.tgz esbuild+netbsd-x64+netbsd-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/openbsd-arm64/-/openbsd-arm64-0.25.12.tgz esbuild+openbsd-arm64+openbsd-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.25.12.tgz esbuild+openbsd-x64+openbsd-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/openharmony-arm64/-/openharmony-arm64-0.25.12.tgz esbuild+openharmony-arm64+openharmony-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.25.12.tgz esbuild+sunos-x64+sunos-x64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.25.12.tgz esbuild+win32-arm64+win32-arm64-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.25.12.tgz esbuild+win32-ia32+win32-ia32-0.25.12.tgz
	https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.25.12.tgz esbuild+win32-x64+win32-x64-0.25.12.tgz
	https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.9.1.tgz eslint-community+eslint-utils+eslint-utils-4.9.1.tgz
	https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.12.2.tgz eslint-community+regexpp+regexpp-4.12.2.tgz
	https://registry.npmjs.org/@eslint/config-array/-/config-array-0.21.2.tgz eslint+config-array+config-array-0.21.2.tgz
	https://registry.npmjs.org/@eslint/config-helpers/-/config-helpers-0.4.2.tgz eslint+config-helpers+config-helpers-0.4.2.tgz
	https://registry.npmjs.org/@eslint/core/-/core-0.17.0.tgz eslint+core+core-0.17.0.tgz
	https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-3.3.5.tgz eslint+eslintrc+eslintrc-3.3.5.tgz
	https://registry.npmjs.org/@eslint/js/-/js-9.39.4.tgz eslint+js+js-9.39.4.tgz
	https://registry.npmjs.org/@eslint/object-schema/-/object-schema-2.1.7.tgz eslint+object-schema+object-schema-2.1.7.tgz
	https://registry.npmjs.org/@eslint/plugin-kit/-/plugin-kit-0.4.1.tgz eslint+plugin-kit+plugin-kit-0.4.1.tgz
	https://registry.npmjs.org/@excalidraw/excalidraw/-/excalidraw-0.18.1.tgz excalidraw+excalidraw+excalidraw-0.18.1.tgz
	https://registry.npmjs.org/@excalidraw/laser-pointer/-/laser-pointer-1.3.1.tgz excalidraw+laser-pointer+laser-pointer-1.3.1.tgz
	https://registry.npmjs.org/@excalidraw/markdown-to-text/-/markdown-to-text-0.1.2.tgz excalidraw+markdown-to-text+markdown-to-text-0.1.2.tgz
	https://registry.npmjs.org/@excalidraw/mermaid-to-excalidraw/-/mermaid-to-excalidraw-2.2.2.tgz excalidraw+mermaid-to-excalidraw+mermaid-to-excalidraw-2.2.2.tgz
	https://registry.npmjs.org/@excalidraw/random-username/-/random-username-1.1.0.tgz excalidraw+random-username+random-username-1.1.0.tgz
	https://registry.npmjs.org/@floating-ui/core/-/core-1.8.0.tgz floating-ui+core+core-1.8.0.tgz
	https://registry.npmjs.org/@floating-ui/dom/-/dom-1.8.0.tgz floating-ui+dom+dom-1.8.0.tgz
	https://registry.npmjs.org/@floating-ui/react-dom/-/react-dom-2.1.9.tgz floating-ui+react-dom+react-dom-2.1.9.tgz
	https://registry.npmjs.org/@floating-ui/react/-/react-0.27.20.tgz floating-ui+react+react-0.27.20.tgz
	https://registry.npmjs.org/@floating-ui/utils/-/utils-0.2.12.tgz floating-ui+utils+utils-0.2.12.tgz
	https://registry.npmjs.org/@humanfs/core/-/core-0.19.1.tgz humanfs+core+core-0.19.1.tgz
	https://registry.npmjs.org/@humanfs/node/-/node-0.16.7.tgz humanfs+node+node-0.16.7.tgz
	https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz humanwhocodes+module-importer+module-importer-1.0.1.tgz
	https://registry.npmjs.org/@humanwhocodes/retry/-/retry-0.4.3.tgz humanwhocodes+retry+retry-0.4.3.tgz
	https://registry.npmjs.org/@iconify/types/-/types-2.0.0.tgz iconify+types+types-2.0.0.tgz
	https://registry.npmjs.org/@iconify/utils/-/utils-3.1.3.tgz iconify+utils+utils-3.1.3.tgz
	https://registry.npmjs.org/@inquirer/ansi/-/ansi-2.0.4.tgz inquirer+ansi+ansi-2.0.4.tgz
	https://registry.npmjs.org/@inquirer/confirm/-/confirm-6.0.10.tgz inquirer+confirm+confirm-6.0.10.tgz
	https://registry.npmjs.org/@inquirer/core/-/core-11.1.7.tgz inquirer+core+core-11.1.7.tgz
	https://registry.npmjs.org/@inquirer/figures/-/figures-2.0.4.tgz inquirer+figures+figures-2.0.4.tgz
	https://registry.npmjs.org/@inquirer/type/-/type-4.0.4.tgz inquirer+type+type-4.0.4.tgz
	https://registry.npmjs.org/@joshwooding/vite-plugin-react-docgen-typescript/-/vite-plugin-react-docgen-typescript-0.7.0.tgz joshwooding+vite-plugin-react-docgen-typescript+vite-plugin-react-docgen-typescript-0.7.0.tgz
	https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.13.tgz jridgewell+gen-mapping+gen-mapping-0.3.13.tgz
	https://registry.npmjs.org/@jridgewell/remapping/-/remapping-2.3.5.tgz jridgewell+remapping+remapping-2.3.5.tgz
	https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz jridgewell+resolve-uri+resolve-uri-3.1.2.tgz
	https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz jridgewell+sourcemap-codec+sourcemap-codec-1.5.5.tgz
	https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.31.tgz jridgewell+trace-mapping+trace-mapping-0.3.31.tgz
	https://registry.npmjs.org/@jscpd/core/-/core-3.5.10.tgz jscpd+core+core-3.5.10.tgz
	https://registry.npmjs.org/@jscpd/finder/-/finder-3.5.10.tgz jscpd+finder+finder-3.5.10.tgz
	https://registry.npmjs.org/@jscpd/html-reporter/-/html-reporter-3.5.10.tgz jscpd+html-reporter+html-reporter-3.5.10.tgz
	https://registry.npmjs.org/@jscpd/tokenizer/-/tokenizer-3.5.4.tgz jscpd+tokenizer+tokenizer-3.5.4.tgz
	https://registry.npmjs.org/@lexical/a11y/-/a11y-0.50.0.tgz lexical+a11y+a11y-0.50.0.tgz
	https://registry.npmjs.org/@lexical/clipboard/-/clipboard-0.50.0.tgz lexical+clipboard+clipboard-0.50.0.tgz
	https://registry.npmjs.org/@lexical/code-core/-/code-core-0.50.0.tgz lexical+code-core+code-core-0.50.0.tgz
	https://registry.npmjs.org/@lexical/devtools-core/-/devtools-core-0.50.0.tgz lexical+devtools-core+devtools-core-0.50.0.tgz
	https://registry.npmjs.org/@lexical/dragon/-/dragon-0.50.0.tgz lexical+dragon+dragon-0.50.0.tgz
	https://registry.npmjs.org/@lexical/extension/-/extension-0.50.0.tgz lexical+extension+extension-0.50.0.tgz
	https://registry.npmjs.org/@lexical/hashtag/-/hashtag-0.50.0.tgz lexical+hashtag+hashtag-0.50.0.tgz
	https://registry.npmjs.org/@lexical/history/-/history-0.50.0.tgz lexical+history+history-0.50.0.tgz
	https://registry.npmjs.org/@lexical/html/-/html-0.50.0.tgz lexical+html+html-0.50.0.tgz
	https://registry.npmjs.org/@lexical/internal/-/internal-0.50.0.tgz lexical+internal+internal-0.50.0.tgz
	https://registry.npmjs.org/@lexical/link/-/link-0.50.0.tgz lexical+link+link-0.50.0.tgz
	https://registry.npmjs.org/@lexical/list/-/list-0.50.0.tgz lexical+list+list-0.50.0.tgz
	https://registry.npmjs.org/@lexical/mark/-/mark-0.50.0.tgz lexical+mark+mark-0.50.0.tgz
	https://registry.npmjs.org/@lexical/markdown/-/markdown-0.50.0.tgz lexical+markdown+markdown-0.50.0.tgz
	https://registry.npmjs.org/@lexical/overflow/-/overflow-0.50.0.tgz lexical+overflow+overflow-0.50.0.tgz
	https://registry.npmjs.org/@lexical/plain-text/-/plain-text-0.50.0.tgz lexical+plain-text+plain-text-0.50.0.tgz
	https://registry.npmjs.org/@lexical/react/-/react-0.50.0.tgz lexical+react+react-0.50.0.tgz
	https://registry.npmjs.org/@lexical/rich-text/-/rich-text-0.50.0.tgz lexical+rich-text+rich-text-0.50.0.tgz
	https://registry.npmjs.org/@lexical/selection/-/selection-0.50.0.tgz lexical+selection+selection-0.50.0.tgz
	https://registry.npmjs.org/@lexical/table/-/table-0.50.0.tgz lexical+table+table-0.50.0.tgz
	https://registry.npmjs.org/@lexical/text/-/text-0.50.0.tgz lexical+text+text-0.50.0.tgz
	https://registry.npmjs.org/@lexical/utils/-/utils-0.50.0.tgz lexical+utils+utils-0.50.0.tgz
	https://registry.npmjs.org/@lexical/yjs/-/yjs-0.50.0.tgz lexical+yjs+yjs-0.50.0.tgz
	https://registry.npmjs.org/@mermaid-js/parser/-/parser-1.2.0.tgz mermaid-js+parser+parser-1.2.0.tgz
	https://registry.npmjs.org/@mswjs/interceptors/-/interceptors-0.41.3.tgz mswjs+interceptors+interceptors-0.41.3.tgz
	https://registry.npmjs.org/@napi-rs/wasm-runtime/-/wasm-runtime-1.2.3.tgz napi-rs+wasm-runtime+wasm-runtime-1.2.3.tgz
	https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz nodelib+fs.scandir+fs.scandir-2.1.5.tgz
	https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz nodelib+fs.stat+fs.stat-2.0.5.tgz
	https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz nodelib+fs.walk+fs.walk-1.2.8.tgz
	https://registry.npmjs.org/@open-draft/deferred-promise/-/deferred-promise-2.2.0.tgz open-draft+deferred-promise+deferred-promise-2.2.0.tgz
	https://registry.npmjs.org/@open-draft/logger/-/logger-0.3.0.tgz open-draft+logger+logger-0.3.0.tgz
	https://registry.npmjs.org/@open-draft/until/-/until-2.1.0.tgz open-draft+until+until-2.1.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-android-arm-eabi/-/binding-android-arm-eabi-0.127.0.tgz oxc-parser+binding-android-arm-eabi+binding-android-arm-eabi-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-android-arm-eabi/-/binding-android-arm-eabi-0.148.0.tgz oxc-parser+binding-android-arm-eabi+binding-android-arm-eabi-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-android-arm64/-/binding-android-arm64-0.127.0.tgz oxc-parser+binding-android-arm64+binding-android-arm64-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-android-arm64/-/binding-android-arm64-0.148.0.tgz oxc-parser+binding-android-arm64+binding-android-arm64-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-darwin-arm64/-/binding-darwin-arm64-0.127.0.tgz oxc-parser+binding-darwin-arm64+binding-darwin-arm64-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-darwin-arm64/-/binding-darwin-arm64-0.148.0.tgz oxc-parser+binding-darwin-arm64+binding-darwin-arm64-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-darwin-x64/-/binding-darwin-x64-0.127.0.tgz oxc-parser+binding-darwin-x64+binding-darwin-x64-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-darwin-x64/-/binding-darwin-x64-0.148.0.tgz oxc-parser+binding-darwin-x64+binding-darwin-x64-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-freebsd-x64/-/binding-freebsd-x64-0.127.0.tgz oxc-parser+binding-freebsd-x64+binding-freebsd-x64-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-freebsd-x64/-/binding-freebsd-x64-0.148.0.tgz oxc-parser+binding-freebsd-x64+binding-freebsd-x64-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-0.127.0.tgz oxc-parser+binding-linux-arm-gnueabihf+binding-linux-arm-gnueabihf-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-0.148.0.tgz oxc-parser+binding-linux-arm-gnueabihf+binding-linux-arm-gnueabihf-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm-musleabihf/-/binding-linux-arm-musleabihf-0.127.0.tgz oxc-parser+binding-linux-arm-musleabihf+binding-linux-arm-musleabihf-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm-musleabihf/-/binding-linux-arm-musleabihf-0.148.0.tgz oxc-parser+binding-linux-arm-musleabihf+binding-linux-arm-musleabihf-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-0.127.0.tgz oxc-parser+binding-linux-arm64-gnu+binding-linux-arm64-gnu-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-0.148.0.tgz oxc-parser+binding-linux-arm64-gnu+binding-linux-arm64-gnu-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm64-musl/-/binding-linux-arm64-musl-0.127.0.tgz oxc-parser+binding-linux-arm64-musl+binding-linux-arm64-musl-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-arm64-musl/-/binding-linux-arm64-musl-0.148.0.tgz oxc-parser+binding-linux-arm64-musl+binding-linux-arm64-musl-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-0.127.0.tgz oxc-parser+binding-linux-ppc64-gnu+binding-linux-ppc64-gnu-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-0.148.0.tgz oxc-parser+binding-linux-ppc64-gnu+binding-linux-ppc64-gnu-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-riscv64-gnu/-/binding-linux-riscv64-gnu-0.127.0.tgz oxc-parser+binding-linux-riscv64-gnu+binding-linux-riscv64-gnu-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-riscv64-gnu/-/binding-linux-riscv64-gnu-0.148.0.tgz oxc-parser+binding-linux-riscv64-gnu+binding-linux-riscv64-gnu-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-riscv64-musl/-/binding-linux-riscv64-musl-0.127.0.tgz oxc-parser+binding-linux-riscv64-musl+binding-linux-riscv64-musl-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-riscv64-musl/-/binding-linux-riscv64-musl-0.148.0.tgz oxc-parser+binding-linux-riscv64-musl+binding-linux-riscv64-musl-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-0.127.0.tgz oxc-parser+binding-linux-s390x-gnu+binding-linux-s390x-gnu-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-0.148.0.tgz oxc-parser+binding-linux-s390x-gnu+binding-linux-s390x-gnu-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-x64-gnu/-/binding-linux-x64-gnu-0.127.0.tgz oxc-parser+binding-linux-x64-gnu+binding-linux-x64-gnu-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-x64-gnu/-/binding-linux-x64-gnu-0.148.0.tgz oxc-parser+binding-linux-x64-gnu+binding-linux-x64-gnu-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-x64-musl/-/binding-linux-x64-musl-0.127.0.tgz oxc-parser+binding-linux-x64-musl+binding-linux-x64-musl-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-linux-x64-musl/-/binding-linux-x64-musl-0.148.0.tgz oxc-parser+binding-linux-x64-musl+binding-linux-x64-musl-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-openharmony-arm64/-/binding-openharmony-arm64-0.127.0.tgz oxc-parser+binding-openharmony-arm64+binding-openharmony-arm64-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-openharmony-arm64/-/binding-openharmony-arm64-0.148.0.tgz oxc-parser+binding-openharmony-arm64+binding-openharmony-arm64-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-wasm32-wasi/-/binding-wasm32-wasi-0.127.0.tgz oxc-parser+binding-wasm32-wasi+binding-wasm32-wasi-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-0.127.0.tgz oxc-parser+binding-win32-arm64-msvc+binding-win32-arm64-msvc-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-0.148.0.tgz oxc-parser+binding-win32-arm64-msvc+binding-win32-arm64-msvc-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-ia32-msvc/-/binding-win32-ia32-msvc-0.127.0.tgz oxc-parser+binding-win32-ia32-msvc+binding-win32-ia32-msvc-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-ia32-msvc/-/binding-win32-ia32-msvc-0.148.0.tgz oxc-parser+binding-win32-ia32-msvc+binding-win32-ia32-msvc-0.148.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-x64-msvc/-/binding-win32-x64-msvc-0.127.0.tgz oxc-parser+binding-win32-x64-msvc+binding-win32-x64-msvc-0.127.0.tgz
	https://registry.npmjs.org/@oxc-parser/binding-win32-x64-msvc/-/binding-win32-x64-msvc-0.148.0.tgz oxc-parser+binding-win32-x64-msvc+binding-win32-x64-msvc-0.148.0.tgz
	https://registry.npmjs.org/@oxc-project/types/-/types-0.127.0.tgz oxc-project+types+types-0.127.0.tgz
	https://registry.npmjs.org/@oxc-project/types/-/types-0.143.0.tgz oxc-project+types+types-0.143.0.tgz
	https://registry.npmjs.org/@oxc-project/types/-/types-0.148.0.tgz oxc-project+types+types-0.148.0.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-android-arm-eabi/-/binding-android-arm-eabi-11.21.2.tgz oxc-resolver+binding-android-arm-eabi+binding-android-arm-eabi-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-android-arm64/-/binding-android-arm64-11.21.2.tgz oxc-resolver+binding-android-arm64+binding-android-arm64-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-darwin-arm64/-/binding-darwin-arm64-11.21.2.tgz oxc-resolver+binding-darwin-arm64+binding-darwin-arm64-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-darwin-x64/-/binding-darwin-x64-11.21.2.tgz oxc-resolver+binding-darwin-x64+binding-darwin-x64-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-freebsd-x64/-/binding-freebsd-x64-11.21.2.tgz oxc-resolver+binding-freebsd-x64+binding-freebsd-x64-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-11.21.2.tgz oxc-resolver+binding-linux-arm-gnueabihf+binding-linux-arm-gnueabihf-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-arm-musleabihf/-/binding-linux-arm-musleabihf-11.21.2.tgz oxc-resolver+binding-linux-arm-musleabihf+binding-linux-arm-musleabihf-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-11.21.2.tgz oxc-resolver+binding-linux-arm64-gnu+binding-linux-arm64-gnu-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-arm64-musl/-/binding-linux-arm64-musl-11.21.2.tgz oxc-resolver+binding-linux-arm64-musl+binding-linux-arm64-musl-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-11.21.2.tgz oxc-resolver+binding-linux-ppc64-gnu+binding-linux-ppc64-gnu-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-riscv64-gnu/-/binding-linux-riscv64-gnu-11.21.2.tgz oxc-resolver+binding-linux-riscv64-gnu+binding-linux-riscv64-gnu-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-riscv64-musl/-/binding-linux-riscv64-musl-11.21.2.tgz oxc-resolver+binding-linux-riscv64-musl+binding-linux-riscv64-musl-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-11.21.2.tgz oxc-resolver+binding-linux-s390x-gnu+binding-linux-s390x-gnu-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-x64-gnu/-/binding-linux-x64-gnu-11.21.2.tgz oxc-resolver+binding-linux-x64-gnu+binding-linux-x64-gnu-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-linux-x64-musl/-/binding-linux-x64-musl-11.21.2.tgz oxc-resolver+binding-linux-x64-musl+binding-linux-x64-musl-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-openharmony-arm64/-/binding-openharmony-arm64-11.21.2.tgz oxc-resolver+binding-openharmony-arm64+binding-openharmony-arm64-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-wasm32-wasi/-/binding-wasm32-wasi-11.21.2.tgz oxc-resolver+binding-wasm32-wasi+binding-wasm32-wasi-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-11.21.2.tgz oxc-resolver+binding-win32-arm64-msvc+binding-win32-arm64-msvc-11.21.2.tgz
	https://registry.npmjs.org/@oxc-resolver/binding-win32-x64-msvc/-/binding-win32-x64-msvc-11.21.2.tgz oxc-resolver+binding-win32-x64-msvc+binding-win32-x64-msvc-11.21.2.tgz
	https://registry.npmjs.org/@parcel/watcher-android-arm64/-/watcher-android-arm64-2.6.0.tgz parcel+watcher-android-arm64+watcher-android-arm64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-darwin-arm64/-/watcher-darwin-arm64-2.6.0.tgz parcel+watcher-darwin-arm64+watcher-darwin-arm64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-darwin-x64/-/watcher-darwin-x64-2.6.0.tgz parcel+watcher-darwin-x64+watcher-darwin-x64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-freebsd-x64/-/watcher-freebsd-x64-2.6.0.tgz parcel+watcher-freebsd-x64+watcher-freebsd-x64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-arm-glibc/-/watcher-linux-arm-glibc-2.6.0.tgz parcel+watcher-linux-arm-glibc+watcher-linux-arm-glibc-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-arm-musl/-/watcher-linux-arm-musl-2.6.0.tgz parcel+watcher-linux-arm-musl+watcher-linux-arm-musl-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-arm64-glibc/-/watcher-linux-arm64-glibc-2.6.0.tgz parcel+watcher-linux-arm64-glibc+watcher-linux-arm64-glibc-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-arm64-musl/-/watcher-linux-arm64-musl-2.6.0.tgz parcel+watcher-linux-arm64-musl+watcher-linux-arm64-musl-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-x64-glibc/-/watcher-linux-x64-glibc-2.6.0.tgz parcel+watcher-linux-x64-glibc+watcher-linux-x64-glibc-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-linux-x64-musl/-/watcher-linux-x64-musl-2.6.0.tgz parcel+watcher-linux-x64-musl+watcher-linux-x64-musl-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-win32-arm64/-/watcher-win32-arm64-2.6.0.tgz parcel+watcher-win32-arm64+watcher-win32-arm64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher-win32-x64/-/watcher-win32-x64-2.6.0.tgz parcel+watcher-win32-x64+watcher-win32-x64-2.6.0.tgz
	https://registry.npmjs.org/@parcel/watcher/-/watcher-2.6.0.tgz parcel+watcher+watcher-2.6.0.tgz
	https://registry.npmjs.org/@pierre/diffs/-/diffs-1.3.5.tgz pierre+diffs+diffs-1.3.5.tgz
	https://registry.npmjs.org/@pierre/theme/-/theme-2.0.0.tgz pierre+theme+theme-2.0.0.tgz
	https://registry.npmjs.org/@pierre/theming/-/theming-1.0.1.tgz pierre+theming+theming-1.0.1.tgz
	https://registry.npmjs.org/@pierre/trees/-/trees-1.0.0-beta.6.tgz pierre+trees+trees-1.0.0-beta.6.tgz
	https://registry.npmjs.org/@playwright/test/-/test-1.58.2.tgz playwright+test+test-1.58.2.tgz
	https://registry.npmjs.org/@preact/signals-core/-/signals-core-1.14.4.tgz preact+signals-core+signals-core-1.14.4.tgz
	https://registry.npmjs.org/@radix-ui/number/-/number-1.1.3.tgz radix-ui+number+number-1.1.3.tgz
	https://registry.npmjs.org/@radix-ui/primitive/-/primitive-1.0.0.tgz radix-ui+primitive+primitive-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/primitive/-/primitive-1.1.1.tgz radix-ui+primitive+primitive-1.1.1.tgz
	https://registry.npmjs.org/@radix-ui/primitive/-/primitive-1.1.4.tgz radix-ui+primitive+primitive-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/primitive/-/primitive-1.1.7.tgz radix-ui+primitive+primitive-1.1.7.tgz
	https://registry.npmjs.org/@radix-ui/react-arrow/-/react-arrow-1.1.10.tgz radix-ui+react-arrow+react-arrow-1.1.10.tgz
	https://registry.npmjs.org/@radix-ui/react-arrow/-/react-arrow-1.1.15.tgz radix-ui+react-arrow+react-arrow-1.1.15.tgz
	https://registry.npmjs.org/@radix-ui/react-arrow/-/react-arrow-1.1.2.tgz radix-ui+react-arrow+react-arrow-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-collection/-/react-collection-1.0.1.tgz radix-ui+react-collection+react-collection-1.0.1.tgz
	https://registry.npmjs.org/@radix-ui/react-collection/-/react-collection-1.1.10.tgz radix-ui+react-collection+react-collection-1.1.10.tgz
	https://registry.npmjs.org/@radix-ui/react-collection/-/react-collection-1.1.15.tgz radix-ui+react-collection+react-collection-1.1.15.tgz
	https://registry.npmjs.org/@radix-ui/react-compose-refs/-/react-compose-refs-1.0.0.tgz radix-ui+react-compose-refs+react-compose-refs-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-compose-refs/-/react-compose-refs-1.1.1.tgz radix-ui+react-compose-refs+react-compose-refs-1.1.1.tgz
	https://registry.npmjs.org/@radix-ui/react-compose-refs/-/react-compose-refs-1.1.3.tgz radix-ui+react-compose-refs+react-compose-refs-1.1.3.tgz
	https://registry.npmjs.org/@radix-ui/react-compose-refs/-/react-compose-refs-1.1.5.tgz radix-ui+react-compose-refs+react-compose-refs-1.1.5.tgz
	https://registry.npmjs.org/@radix-ui/react-context-menu/-/react-context-menu-2.3.1.tgz radix-ui+react-context-menu+react-context-menu-2.3.1.tgz
	https://registry.npmjs.org/@radix-ui/react-context/-/react-context-1.0.0.tgz radix-ui+react-context+react-context-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-context/-/react-context-1.1.1.tgz radix-ui+react-context+react-context-1.1.1.tgz
	https://registry.npmjs.org/@radix-ui/react-context/-/react-context-1.1.4.tgz radix-ui+react-context+react-context-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-context/-/react-context-1.2.2.tgz radix-ui+react-context+react-context-1.2.2.tgz
	https://registry.npmjs.org/@radix-ui/react-dialog/-/react-dialog-1.1.23.tgz radix-ui+react-dialog+react-dialog-1.1.23.tgz
	https://registry.npmjs.org/@radix-ui/react-direction/-/react-direction-1.0.0.tgz radix-ui+react-direction+react-direction-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-direction/-/react-direction-1.1.2.tgz radix-ui+react-direction+react-direction-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-direction/-/react-direction-1.1.4.tgz radix-ui+react-direction+react-direction-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-dismissable-layer/-/react-dismissable-layer-1.1.13.tgz radix-ui+react-dismissable-layer+react-dismissable-layer-1.1.13.tgz
	https://registry.npmjs.org/@radix-ui/react-dismissable-layer/-/react-dismissable-layer-1.1.19.tgz radix-ui+react-dismissable-layer+react-dismissable-layer-1.1.19.tgz
	https://registry.npmjs.org/@radix-ui/react-dropdown-menu/-/react-dropdown-menu-2.1.18.tgz radix-ui+react-dropdown-menu+react-dropdown-menu-2.1.18.tgz
	https://registry.npmjs.org/@radix-ui/react-focus-guards/-/react-focus-guards-1.1.4.tgz radix-ui+react-focus-guards+react-focus-guards-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-focus-guards/-/react-focus-guards-1.1.6.tgz radix-ui+react-focus-guards+react-focus-guards-1.1.6.tgz
	https://registry.npmjs.org/@radix-ui/react-focus-scope/-/react-focus-scope-1.1.10.tgz radix-ui+react-focus-scope+react-focus-scope-1.1.10.tgz
	https://registry.npmjs.org/@radix-ui/react-focus-scope/-/react-focus-scope-1.1.16.tgz radix-ui+react-focus-scope+react-focus-scope-1.1.16.tgz
	https://registry.npmjs.org/@radix-ui/react-id/-/react-id-1.0.0.tgz radix-ui+react-id+react-id-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-id/-/react-id-1.1.0.tgz radix-ui+react-id+react-id-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-id/-/react-id-1.1.2.tgz radix-ui+react-id+react-id-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-id/-/react-id-1.1.4.tgz radix-ui+react-id+react-id-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-menu/-/react-menu-2.1.18.tgz radix-ui+react-menu+react-menu-2.1.18.tgz
	https://registry.npmjs.org/@radix-ui/react-popover/-/react-popover-1.1.23.tgz radix-ui+react-popover+react-popover-1.1.23.tgz
	https://registry.npmjs.org/@radix-ui/react-popover/-/react-popover-1.1.6.tgz radix-ui+react-popover+react-popover-1.1.6.tgz
	https://registry.npmjs.org/@radix-ui/react-popper/-/react-popper-1.2.2.tgz radix-ui+react-popper+react-popper-1.2.2.tgz
	https://registry.npmjs.org/@radix-ui/react-popper/-/react-popper-1.3.1.tgz radix-ui+react-popper+react-popper-1.3.1.tgz
	https://registry.npmjs.org/@radix-ui/react-popper/-/react-popper-1.3.7.tgz radix-ui+react-popper+react-popper-1.3.7.tgz
	https://registry.npmjs.org/@radix-ui/react-portal/-/react-portal-1.1.12.tgz radix-ui+react-portal+react-portal-1.1.12.tgz
	https://registry.npmjs.org/@radix-ui/react-portal/-/react-portal-1.1.17.tgz radix-ui+react-portal+react-portal-1.1.17.tgz
	https://registry.npmjs.org/@radix-ui/react-portal/-/react-portal-1.1.4.tgz radix-ui+react-portal+react-portal-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-presence/-/react-presence-1.0.0.tgz radix-ui+react-presence+react-presence-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-presence/-/react-presence-1.1.10.tgz radix-ui+react-presence+react-presence-1.1.10.tgz
	https://registry.npmjs.org/@radix-ui/react-presence/-/react-presence-1.1.2.tgz radix-ui+react-presence+react-presence-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-presence/-/react-presence-1.1.6.tgz radix-ui+react-presence+react-presence-1.1.6.tgz
	https://registry.npmjs.org/@radix-ui/react-primitive/-/react-primitive-1.0.1.tgz radix-ui+react-primitive+react-primitive-1.0.1.tgz
	https://registry.npmjs.org/@radix-ui/react-primitive/-/react-primitive-2.0.2.tgz radix-ui+react-primitive+react-primitive-2.0.2.tgz
	https://registry.npmjs.org/@radix-ui/react-primitive/-/react-primitive-2.1.10.tgz radix-ui+react-primitive+react-primitive-2.1.10.tgz
	https://registry.npmjs.org/@radix-ui/react-primitive/-/react-primitive-2.1.6.tgz radix-ui+react-primitive+react-primitive-2.1.6.tgz
	https://registry.npmjs.org/@radix-ui/react-progress/-/react-progress-1.1.16.tgz radix-ui+react-progress+react-progress-1.1.16.tgz
	https://registry.npmjs.org/@radix-ui/react-roving-focus/-/react-roving-focus-1.0.2.tgz radix-ui+react-roving-focus+react-roving-focus-1.0.2.tgz
	https://registry.npmjs.org/@radix-ui/react-roving-focus/-/react-roving-focus-1.1.13.tgz radix-ui+react-roving-focus+react-roving-focus-1.1.13.tgz
	https://registry.npmjs.org/@radix-ui/react-roving-focus/-/react-roving-focus-1.1.19.tgz radix-ui+react-roving-focus+react-roving-focus-1.1.19.tgz
	https://registry.npmjs.org/@radix-ui/react-select/-/react-select-2.3.7.tgz radix-ui+react-select+react-select-2.3.7.tgz
	https://registry.npmjs.org/@radix-ui/react-slot/-/react-slot-1.0.1.tgz radix-ui+react-slot+react-slot-1.0.1.tgz
	https://registry.npmjs.org/@radix-ui/react-slot/-/react-slot-1.1.2.tgz radix-ui+react-slot+react-slot-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-slot/-/react-slot-1.3.0.tgz radix-ui+react-slot+react-slot-1.3.0.tgz
	https://registry.npmjs.org/@radix-ui/react-slot/-/react-slot-1.3.3.tgz radix-ui+react-slot+react-slot-1.3.3.tgz
	https://registry.npmjs.org/@radix-ui/react-tabs/-/react-tabs-1.0.2.tgz radix-ui+react-tabs+react-tabs-1.0.2.tgz
	https://registry.npmjs.org/@radix-ui/react-tabs/-/react-tabs-1.1.21.tgz radix-ui+react-tabs+react-tabs-1.1.21.tgz
	https://registry.npmjs.org/@radix-ui/react-use-callback-ref/-/react-use-callback-ref-1.0.0.tgz radix-ui+react-use-callback-ref+react-use-callback-ref-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-callback-ref/-/react-use-callback-ref-1.1.0.tgz radix-ui+react-use-callback-ref+react-use-callback-ref-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-callback-ref/-/react-use-callback-ref-1.1.2.tgz radix-ui+react-use-callback-ref+react-use-callback-ref-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-use-callback-ref/-/react-use-callback-ref-1.1.4.tgz radix-ui+react-use-callback-ref+react-use-callback-ref-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-use-controllable-state/-/react-use-controllable-state-1.0.0.tgz radix-ui+react-use-controllable-state+react-use-controllable-state-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-controllable-state/-/react-use-controllable-state-1.1.0.tgz radix-ui+react-use-controllable-state+react-use-controllable-state-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-controllable-state/-/react-use-controllable-state-1.2.3.tgz radix-ui+react-use-controllable-state+react-use-controllable-state-1.2.3.tgz
	https://registry.npmjs.org/@radix-ui/react-use-controllable-state/-/react-use-controllable-state-1.2.6.tgz radix-ui+react-use-controllable-state+react-use-controllable-state-1.2.6.tgz
	https://registry.npmjs.org/@radix-ui/react-use-effect-event/-/react-use-effect-event-0.0.3.tgz radix-ui+react-use-effect-event+react-use-effect-event-0.0.3.tgz
	https://registry.npmjs.org/@radix-ui/react-use-effect-event/-/react-use-effect-event-0.0.5.tgz radix-ui+react-use-effect-event+react-use-effect-event-0.0.5.tgz
	https://registry.npmjs.org/@radix-ui/react-use-escape-keydown/-/react-use-escape-keydown-1.1.2.tgz radix-ui+react-use-escape-keydown+react-use-escape-keydown-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-use-is-hydrated/-/react-use-is-hydrated-0.1.3.tgz radix-ui+react-use-is-hydrated+react-use-is-hydrated-0.1.3.tgz
	https://registry.npmjs.org/@radix-ui/react-use-layout-effect/-/react-use-layout-effect-1.0.0.tgz radix-ui+react-use-layout-effect+react-use-layout-effect-1.0.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-layout-effect/-/react-use-layout-effect-1.1.0.tgz radix-ui+react-use-layout-effect+react-use-layout-effect-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-layout-effect/-/react-use-layout-effect-1.1.2.tgz radix-ui+react-use-layout-effect+react-use-layout-effect-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-use-layout-effect/-/react-use-layout-effect-1.1.4.tgz radix-ui+react-use-layout-effect+react-use-layout-effect-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-use-previous/-/react-use-previous-1.1.4.tgz radix-ui+react-use-previous+react-use-previous-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-use-rect/-/react-use-rect-1.1.0.tgz radix-ui+react-use-rect+react-use-rect-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-rect/-/react-use-rect-1.1.2.tgz radix-ui+react-use-rect+react-use-rect-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-use-rect/-/react-use-rect-1.1.4.tgz radix-ui+react-use-rect+react-use-rect-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-use-size/-/react-use-size-1.1.0.tgz radix-ui+react-use-size+react-use-size-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/react-use-size/-/react-use-size-1.1.2.tgz radix-ui+react-use-size+react-use-size-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/react-use-size/-/react-use-size-1.1.4.tgz radix-ui+react-use-size+react-use-size-1.1.4.tgz
	https://registry.npmjs.org/@radix-ui/react-visually-hidden/-/react-visually-hidden-1.2.11.tgz radix-ui+react-visually-hidden+react-visually-hidden-1.2.11.tgz
	https://registry.npmjs.org/@radix-ui/rect/-/rect-1.1.0.tgz radix-ui+rect+rect-1.1.0.tgz
	https://registry.npmjs.org/@radix-ui/rect/-/rect-1.1.2.tgz radix-ui+rect+rect-1.1.2.tgz
	https://registry.npmjs.org/@radix-ui/rect/-/rect-1.1.3.tgz radix-ui+rect+rect-1.1.3.tgz
	https://registry.npmjs.org/@reduxjs/toolkit/-/toolkit-2.12.0.tgz reduxjs+toolkit+toolkit-2.12.0.tgz
	https://registry.npmjs.org/@rolldown/binding-android-arm64/-/binding-android-arm64-1.2.3.tgz rolldown+binding-android-arm64+binding-android-arm64-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-darwin-arm64/-/binding-darwin-arm64-1.2.3.tgz rolldown+binding-darwin-arm64+binding-darwin-arm64-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-darwin-x64/-/binding-darwin-x64-1.2.3.tgz rolldown+binding-darwin-x64+binding-darwin-x64-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-freebsd-x64/-/binding-freebsd-x64-1.2.3.tgz rolldown+binding-freebsd-x64+binding-freebsd-x64-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-1.2.3.tgz rolldown+binding-linux-arm-gnueabihf+binding-linux-arm-gnueabihf-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-1.2.3.tgz rolldown+binding-linux-arm64-gnu+binding-linux-arm64-gnu-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-arm64-musl/-/binding-linux-arm64-musl-1.2.3.tgz rolldown+binding-linux-arm64-musl+binding-linux-arm64-musl-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-1.2.3.tgz rolldown+binding-linux-ppc64-gnu+binding-linux-ppc64-gnu-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-1.2.3.tgz rolldown+binding-linux-s390x-gnu+binding-linux-s390x-gnu-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-x64-gnu/-/binding-linux-x64-gnu-1.2.3.tgz rolldown+binding-linux-x64-gnu+binding-linux-x64-gnu-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-linux-x64-musl/-/binding-linux-x64-musl-1.2.3.tgz rolldown+binding-linux-x64-musl+binding-linux-x64-musl-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-openharmony-arm64/-/binding-openharmony-arm64-1.2.3.tgz rolldown+binding-openharmony-arm64+binding-openharmony-arm64-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-1.2.3.tgz rolldown+binding-win32-arm64-msvc+binding-win32-arm64-msvc-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/binding-win32-x64-msvc/-/binding-win32-x64-msvc-1.2.3.tgz rolldown+binding-win32-x64-msvc+binding-win32-x64-msvc-1.2.3.tgz
	https://registry.npmjs.org/@rolldown/pluginutils/-/pluginutils-1.0.1.tgz rolldown+pluginutils+pluginutils-1.0.1.tgz
	https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-5.4.0.tgz rollup+pluginutils+pluginutils-5.4.0.tgz
	https://registry.npmjs.org/@shadcn/lint/-/lint-0.1.3.tgz shadcn+lint+lint-0.1.3.tgz
	https://registry.npmjs.org/@shikijs/core/-/core-4.4.2.tgz shikijs+core+core-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/engine-javascript/-/engine-javascript-4.4.2.tgz shikijs+engine-javascript+engine-javascript-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/engine-oniguruma/-/engine-oniguruma-4.4.2.tgz shikijs+engine-oniguruma+engine-oniguruma-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/langs/-/langs-4.4.2.tgz shikijs+langs+langs-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/primitive/-/primitive-4.4.2.tgz shikijs+primitive+primitive-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/themes/-/themes-4.4.2.tgz shikijs+themes+themes-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/transformers/-/transformers-4.4.2.tgz shikijs+transformers+transformers-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/types/-/types-4.4.2.tgz shikijs+types+types-4.4.2.tgz
	https://registry.npmjs.org/@shikijs/vscode-textmate/-/vscode-textmate-10.0.2.tgz shikijs+vscode-textmate+vscode-textmate-10.0.2.tgz
	https://registry.npmjs.org/@standard-schema/spec/-/spec-1.1.0.tgz standard-schema+spec+spec-1.1.0.tgz
	https://registry.npmjs.org/@standard-schema/utils/-/utils-0.3.0.tgz standard-schema+utils+utils-0.3.0.tgz
	https://registry.npmjs.org/@storybook/addon-a11y/-/addon-a11y-10.5.10.tgz storybook+addon-a11y+addon-a11y-10.5.10.tgz
	https://registry.npmjs.org/@storybook/addon-themes/-/addon-themes-10.5.10.tgz storybook+addon-themes+addon-themes-10.5.10.tgz
	https://registry.npmjs.org/@storybook/builder-vite/-/builder-vite-10.5.10.tgz storybook+builder-vite+builder-vite-10.5.10.tgz
	https://registry.npmjs.org/@storybook/csf-plugin/-/csf-plugin-10.5.10.tgz storybook+csf-plugin+csf-plugin-10.5.10.tgz
	https://registry.npmjs.org/@storybook/global/-/global-5.0.0.tgz storybook+global+global-5.0.0.tgz
	https://registry.npmjs.org/@storybook/icons/-/icons-2.1.0.tgz storybook+icons+icons-2.1.0.tgz
	https://registry.npmjs.org/@storybook/react-dom-shim/-/react-dom-shim-10.5.10.tgz storybook+react-dom-shim+react-dom-shim-10.5.10.tgz
	https://registry.npmjs.org/@storybook/react-vite/-/react-vite-10.5.10.tgz storybook+react-vite+react-vite-10.5.10.tgz
	https://registry.npmjs.org/@storybook/react/-/react-10.5.10.tgz storybook+react+react-10.5.10.tgz
	https://registry.npmjs.org/@tailwindcss/browser/-/browser-4.1.13.tgz tailwindcss+browser+browser-4.1.13.tgz
	https://registry.npmjs.org/@tailwindcss/node/-/node-4.3.3.tgz tailwindcss+node+node-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-android-arm64/-/oxide-android-arm64-4.3.3.tgz tailwindcss+oxide-android-arm64+oxide-android-arm64-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-darwin-arm64/-/oxide-darwin-arm64-4.3.3.tgz tailwindcss+oxide-darwin-arm64+oxide-darwin-arm64-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-darwin-x64/-/oxide-darwin-x64-4.3.3.tgz tailwindcss+oxide-darwin-x64+oxide-darwin-x64-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-freebsd-x64/-/oxide-freebsd-x64-4.3.3.tgz tailwindcss+oxide-freebsd-x64+oxide-freebsd-x64-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-linux-arm-gnueabihf/-/oxide-linux-arm-gnueabihf-4.3.3.tgz tailwindcss+oxide-linux-arm-gnueabihf+oxide-linux-arm-gnueabihf-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-linux-arm64-gnu/-/oxide-linux-arm64-gnu-4.3.3.tgz tailwindcss+oxide-linux-arm64-gnu+oxide-linux-arm64-gnu-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-linux-arm64-musl/-/oxide-linux-arm64-musl-4.3.3.tgz tailwindcss+oxide-linux-arm64-musl+oxide-linux-arm64-musl-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-linux-x64-gnu/-/oxide-linux-x64-gnu-4.3.3.tgz tailwindcss+oxide-linux-x64-gnu+oxide-linux-x64-gnu-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-linux-x64-musl/-/oxide-linux-x64-musl-4.3.3.tgz tailwindcss+oxide-linux-x64-musl+oxide-linux-x64-musl-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-wasm32-wasi/-/oxide-wasm32-wasi-4.3.3.tgz tailwindcss+oxide-wasm32-wasi+oxide-wasm32-wasi-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-win32-arm64-msvc/-/oxide-win32-arm64-msvc-4.3.3.tgz tailwindcss+oxide-win32-arm64-msvc+oxide-win32-arm64-msvc-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide-win32-x64-msvc/-/oxide-win32-x64-msvc-4.3.3.tgz tailwindcss+oxide-win32-x64-msvc+oxide-win32-x64-msvc-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/oxide/-/oxide-4.3.3.tgz tailwindcss+oxide+oxide-4.3.3.tgz
	https://registry.npmjs.org/@tailwindcss/vite/-/vite-4.3.3.tgz tailwindcss+vite+vite-4.3.3.tgz
	https://registry.npmjs.org/@tanstack/query-core/-/query-core-5.96.0.tgz tanstack+query-core+query-core-5.96.0.tgz
	https://registry.npmjs.org/@tanstack/react-query/-/react-query-5.96.0.tgz tanstack+react-query+react-query-5.96.0.tgz
	https://registry.npmjs.org/@tanstack/react-table/-/react-table-8.21.3.tgz tanstack+react-table+react-table-8.21.3.tgz
	https://registry.npmjs.org/@tanstack/table-core/-/table-core-8.21.3.tgz tanstack+table-core+table-core-8.21.3.tgz
	https://registry.npmjs.org/@testing-library/dom/-/dom-10.4.1.tgz testing-library+dom+dom-10.4.1.tgz
	https://registry.npmjs.org/@testing-library/jest-dom/-/jest-dom-6.9.1.tgz testing-library+jest-dom+jest-dom-6.9.1.tgz
	https://registry.npmjs.org/@testing-library/react/-/react-16.3.2.tgz testing-library+react+react-16.3.2.tgz
	https://registry.npmjs.org/@testing-library/user-event/-/user-event-14.6.1.tgz testing-library+user-event+user-event-14.6.1.tgz
	https://registry.npmjs.org/@tybys/wasm-util/-/wasm-util-0.10.3.tgz tybys+wasm-util+wasm-util-0.10.3.tgz
	https://registry.npmjs.org/@types/aria-query/-/aria-query-5.0.4.tgz types+aria-query+aria-query-5.0.4.tgz
	https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz types+babel__core+babel__core-7.20.5.tgz
	https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.27.0.tgz types+babel__generator+babel__generator-7.27.0.tgz
	https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz types+babel__template+babel__template-7.4.4.tgz
	https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.28.0.tgz types+babel__traverse+babel__traverse-7.28.0.tgz
	https://registry.npmjs.org/@types/chai/-/chai-5.2.3.tgz types+chai+chai-5.2.3.tgz
	https://registry.npmjs.org/@types/d3-array/-/d3-array-3.2.2.tgz types+d3-array+d3-array-3.2.2.tgz
	https://registry.npmjs.org/@types/d3-axis/-/d3-axis-3.0.6.tgz types+d3-axis+d3-axis-3.0.6.tgz
	https://registry.npmjs.org/@types/d3-brush/-/d3-brush-3.0.6.tgz types+d3-brush+d3-brush-3.0.6.tgz
	https://registry.npmjs.org/@types/d3-chord/-/d3-chord-3.0.6.tgz types+d3-chord+d3-chord-3.0.6.tgz
	https://registry.npmjs.org/@types/d3-color/-/d3-color-3.1.3.tgz types+d3-color+d3-color-3.1.3.tgz
	https://registry.npmjs.org/@types/d3-contour/-/d3-contour-3.0.6.tgz types+d3-contour+d3-contour-3.0.6.tgz
	https://registry.npmjs.org/@types/d3-delaunay/-/d3-delaunay-6.0.4.tgz types+d3-delaunay+d3-delaunay-6.0.4.tgz
	https://registry.npmjs.org/@types/d3-dispatch/-/d3-dispatch-3.0.7.tgz types+d3-dispatch+d3-dispatch-3.0.7.tgz
	https://registry.npmjs.org/@types/d3-drag/-/d3-drag-3.0.7.tgz types+d3-drag+d3-drag-3.0.7.tgz
	https://registry.npmjs.org/@types/d3-dsv/-/d3-dsv-3.0.7.tgz types+d3-dsv+d3-dsv-3.0.7.tgz
	https://registry.npmjs.org/@types/d3-ease/-/d3-ease-3.0.2.tgz types+d3-ease+d3-ease-3.0.2.tgz
	https://registry.npmjs.org/@types/d3-fetch/-/d3-fetch-3.0.7.tgz types+d3-fetch+d3-fetch-3.0.7.tgz
	https://registry.npmjs.org/@types/d3-force/-/d3-force-3.0.10.tgz types+d3-force+d3-force-3.0.10.tgz
	https://registry.npmjs.org/@types/d3-format/-/d3-format-3.0.4.tgz types+d3-format+d3-format-3.0.4.tgz
	https://registry.npmjs.org/@types/d3-geo/-/d3-geo-3.1.0.tgz types+d3-geo+d3-geo-3.1.0.tgz
	https://registry.npmjs.org/@types/d3-hierarchy/-/d3-hierarchy-3.1.7.tgz types+d3-hierarchy+d3-hierarchy-3.1.7.tgz
	https://registry.npmjs.org/@types/d3-interpolate/-/d3-interpolate-3.0.4.tgz types+d3-interpolate+d3-interpolate-3.0.4.tgz
	https://registry.npmjs.org/@types/d3-path/-/d3-path-3.1.1.tgz types+d3-path+d3-path-3.1.1.tgz
	https://registry.npmjs.org/@types/d3-polygon/-/d3-polygon-3.0.2.tgz types+d3-polygon+d3-polygon-3.0.2.tgz
	https://registry.npmjs.org/@types/d3-quadtree/-/d3-quadtree-3.0.6.tgz types+d3-quadtree+d3-quadtree-3.0.6.tgz
	https://registry.npmjs.org/@types/d3-random/-/d3-random-3.0.3.tgz types+d3-random+d3-random-3.0.3.tgz
	https://registry.npmjs.org/@types/d3-scale-chromatic/-/d3-scale-chromatic-3.1.0.tgz types+d3-scale-chromatic+d3-scale-chromatic-3.1.0.tgz
	https://registry.npmjs.org/@types/d3-scale/-/d3-scale-4.0.9.tgz types+d3-scale+d3-scale-4.0.9.tgz
	https://registry.npmjs.org/@types/d3-selection/-/d3-selection-3.0.11.tgz types+d3-selection+d3-selection-3.0.11.tgz
	https://registry.npmjs.org/@types/d3-shape/-/d3-shape-3.1.8.tgz types+d3-shape+d3-shape-3.1.8.tgz
	https://registry.npmjs.org/@types/d3-time-format/-/d3-time-format-4.0.3.tgz types+d3-time-format+d3-time-format-4.0.3.tgz
	https://registry.npmjs.org/@types/d3-time/-/d3-time-3.0.4.tgz types+d3-time+d3-time-3.0.4.tgz
	https://registry.npmjs.org/@types/d3-timer/-/d3-timer-3.0.2.tgz types+d3-timer+d3-timer-3.0.2.tgz
	https://registry.npmjs.org/@types/d3-transition/-/d3-transition-3.0.9.tgz types+d3-transition+d3-transition-3.0.9.tgz
	https://registry.npmjs.org/@types/d3-zoom/-/d3-zoom-3.0.8.tgz types+d3-zoom+d3-zoom-3.0.8.tgz
	https://registry.npmjs.org/@types/d3/-/d3-7.4.3.tgz types+d3+d3-7.4.3.tgz
	https://registry.npmjs.org/@types/debug/-/debug-4.1.13.tgz types+debug+debug-4.1.13.tgz
	https://registry.npmjs.org/@types/deep-eql/-/deep-eql-4.0.2.tgz types+deep-eql+deep-eql-4.0.2.tgz
	https://registry.npmjs.org/@types/doctrine/-/doctrine-0.0.9.tgz types+doctrine+doctrine-0.0.9.tgz
	https://registry.npmjs.org/@types/dompurify/-/dompurify-3.0.5.tgz types+dompurify+dompurify-3.0.5.tgz
	https://registry.npmjs.org/@types/estree-jsx/-/estree-jsx-1.0.5.tgz types+estree-jsx+estree-jsx-1.0.5.tgz
	https://registry.npmjs.org/@types/estree/-/estree-1.0.9.tgz types+estree+estree-1.0.9.tgz
	https://registry.npmjs.org/@types/geojson/-/geojson-7946.0.16.tgz types+geojson+geojson-7946.0.16.tgz
	https://registry.npmjs.org/@types/hammerjs/-/hammerjs-2.0.46.tgz types+hammerjs+hammerjs-2.0.46.tgz
	https://registry.npmjs.org/@types/hast/-/hast-3.0.5.tgz types+hast+hast-3.0.5.tgz
	https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz types+json-schema+json-schema-7.0.15.tgz
	https://registry.npmjs.org/@types/katex/-/katex-0.16.8.tgz types+katex+katex-0.16.8.tgz
	https://registry.npmjs.org/@types/mdast/-/mdast-4.0.4.tgz types+mdast+mdast-4.0.4.tgz
	https://registry.npmjs.org/@types/ms/-/ms-2.1.0.tgz types+ms+ms-2.1.0.tgz
	https://registry.npmjs.org/@types/node/-/node-24.13.3.tgz types+node+node-24.13.3.tgz
	https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.15.tgz types+prop-types+prop-types-15.7.15.tgz
	https://registry.npmjs.org/@types/react-dom/-/react-dom-18.3.7.tgz types+react-dom+react-dom-18.3.7.tgz
	https://registry.npmjs.org/@types/react/-/react-18.3.30.tgz types+react+react-18.3.30.tgz
	https://registry.npmjs.org/@types/resolve/-/resolve-1.20.6.tgz types+resolve+resolve-1.20.6.tgz
	https://registry.npmjs.org/@types/statuses/-/statuses-2.0.6.tgz types+statuses+statuses-2.0.6.tgz
	https://registry.npmjs.org/@types/trusted-types/-/trusted-types-2.0.7.tgz types+trusted-types+trusted-types-2.0.7.tgz
	https://registry.npmjs.org/@types/unist/-/unist-2.0.11.tgz types+unist+unist-2.0.11.tgz
	https://registry.npmjs.org/@types/unist/-/unist-3.0.3.tgz types+unist+unist-3.0.3.tgz
	https://registry.npmjs.org/@types/use-sync-external-store/-/use-sync-external-store-0.0.6.tgz types+use-sync-external-store+use-sync-external-store-0.0.6.tgz
	https://registry.npmjs.org/@types/whatwg-mimetype/-/whatwg-mimetype-3.0.2.tgz types+whatwg-mimetype+whatwg-mimetype-3.0.2.tgz
	https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz types+ws+ws-8.18.1.tgz
	https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.58.0.tgz typescript-eslint+eslint-plugin+eslint-plugin-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/parser/-/parser-8.58.0.tgz typescript-eslint+parser+parser-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/project-service/-/project-service-8.58.0.tgz typescript-eslint+project-service+project-service-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.58.0.tgz typescript-eslint+scope-manager+scope-manager-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/tsconfig-utils/-/tsconfig-utils-8.58.0.tgz typescript-eslint+tsconfig-utils+tsconfig-utils-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-8.58.0.tgz typescript-eslint+type-utils+type-utils-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/types/-/types-8.58.0.tgz typescript-eslint+types+types-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.58.0.tgz typescript-eslint+typescript-estree+typescript-estree-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/utils/-/utils-8.58.0.tgz typescript-eslint+utils+utils-8.58.0.tgz
	https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.58.0.tgz typescript-eslint+visitor-keys+visitor-keys-8.58.0.tgz
	https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.3.1.tgz ungap+structured-clone+structured-clone-1.3.1.tgz
	https://registry.npmjs.org/@upsetjs/venn.js/-/venn.js-2.0.0.tgz upsetjs+venn.js+venn.js-2.0.0.tgz
	https://registry.npmjs.org/@virtuoso.dev/gurx/-/gurx-1.2.3.tgz virtuoso.dev+gurx+gurx-1.2.3.tgz
	https://registry.npmjs.org/@virtuoso.dev/masonry/-/masonry-1.4.3.tgz virtuoso.dev+masonry+masonry-1.4.3.tgz
	https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-6.0.5.tgz vitejs+plugin-react+plugin-react-6.0.5.tgz
	https://registry.npmjs.org/@vitest/coverage-v8/-/coverage-v8-4.1.11.tgz vitest+coverage-v8+coverage-v8-4.1.11.tgz
	https://registry.npmjs.org/@vitest/expect/-/expect-3.2.4.tgz vitest+expect+expect-3.2.4.tgz
	https://registry.npmjs.org/@vitest/expect/-/expect-4.1.11.tgz vitest+expect+expect-4.1.11.tgz
	https://registry.npmjs.org/@vitest/mocker/-/mocker-4.1.11.tgz vitest+mocker+mocker-4.1.11.tgz
	https://registry.npmjs.org/@vitest/pretty-format/-/pretty-format-3.2.4.tgz vitest+pretty-format+pretty-format-3.2.4.tgz
	https://registry.npmjs.org/@vitest/pretty-format/-/pretty-format-4.1.11.tgz vitest+pretty-format+pretty-format-4.1.11.tgz
	https://registry.npmjs.org/@vitest/runner/-/runner-4.1.11.tgz vitest+runner+runner-4.1.11.tgz
	https://registry.npmjs.org/@vitest/snapshot/-/snapshot-4.1.11.tgz vitest+snapshot+snapshot-4.1.11.tgz
	https://registry.npmjs.org/@vitest/spy/-/spy-3.2.4.tgz vitest+spy+spy-3.2.4.tgz
	https://registry.npmjs.org/@vitest/spy/-/spy-4.1.11.tgz vitest+spy+spy-4.1.11.tgz
	https://registry.npmjs.org/@vitest/utils/-/utils-3.2.4.tgz vitest+utils+utils-3.2.4.tgz
	https://registry.npmjs.org/@vitest/utils/-/utils-4.1.11.tgz vitest+utils+utils-4.1.11.tgz
	https://registry.npmjs.org/@webcontainer/env/-/env-1.1.1.tgz webcontainer+env+env-1.1.1.tgz
	https://registry.npmjs.org/@xterm/addon-fit/-/addon-fit-0.10.0.tgz xterm+addon-fit+addon-fit-0.10.0.tgz
	https://registry.npmjs.org/@xterm/addon-web-links/-/addon-web-links-0.11.0.tgz xterm+addon-web-links+addon-web-links-0.11.0.tgz
	https://registry.npmjs.org/@xterm/xterm/-/xterm-5.5.0.tgz xterm+xterm+xterm-5.5.0.tgz
	https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz acorn-jsx+acorn-jsx-5.3.2.tgz
	https://registry.npmjs.org/acorn/-/acorn-7.4.1.tgz acorn+acorn-7.4.1.tgz
	https://registry.npmjs.org/acorn/-/acorn-8.16.0.tgz acorn+acorn-8.16.0.tgz
	https://registry.npmjs.org/agent-base/-/agent-base-7.1.4.tgz agent-base+agent-base-7.1.4.tgz
	https://registry.npmjs.org/ajv/-/ajv-6.14.0.tgz ajv+ajv-6.14.0.tgz
	https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz ansi-regex+ansi-regex-5.0.1.tgz
	https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz ansi-styles+ansi-styles-4.3.0.tgz
	https://registry.npmjs.org/ansi-styles/-/ansi-styles-5.2.0.tgz ansi-styles+ansi-styles-5.2.0.tgz
	https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz argparse+argparse-2.0.1.tgz
	https://registry.npmjs.org/aria-hidden/-/aria-hidden-1.2.6.tgz aria-hidden+aria-hidden-1.2.6.tgz
	https://registry.npmjs.org/aria-query/-/aria-query-5.3.0.tgz aria-query+aria-query-5.3.0.tgz
	https://registry.npmjs.org/aria-query/-/aria-query-5.3.2.tgz aria-query+aria-query-5.3.2.tgz
	https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.2.tgz array-buffer-byte-length+array-buffer-byte-length-1.0.2.tgz
	https://registry.npmjs.org/array-includes/-/array-includes-3.1.9.tgz array-includes+array-includes-3.1.9.tgz
	https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.3.tgz array.prototype.flat+array.prototype.flat-1.3.3.tgz
	https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.3.tgz array.prototype.flatmap+array.prototype.flatmap-1.3.3.tgz
	https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.4.tgz arraybuffer.prototype.slice+arraybuffer.prototype.slice-1.0.4.tgz
	https://registry.npmjs.org/asap/-/asap-2.0.6.tgz asap+asap-2.0.6.tgz
	https://registry.npmjs.org/assert-never/-/assert-never-1.4.0.tgz assert-never+assert-never-1.4.0.tgz
	https://registry.npmjs.org/assertion-error/-/assertion-error-2.0.1.tgz assertion-error+assertion-error-2.0.1.tgz
	https://registry.npmjs.org/ast-types-flow/-/ast-types-flow-0.0.8.tgz ast-types-flow+ast-types-flow-0.0.8.tgz
	https://registry.npmjs.org/ast-types/-/ast-types-0.16.1.tgz ast-types+ast-types-0.16.1.tgz
	https://registry.npmjs.org/ast-v8-to-istanbul/-/ast-v8-to-istanbul-1.0.5.tgz ast-v8-to-istanbul+ast-v8-to-istanbul-1.0.5.tgz
	https://registry.npmjs.org/async-function/-/async-function-1.0.0.tgz async-function+async-function-1.0.0.tgz
	https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz at-least-node+at-least-node-1.0.0.tgz
	https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz available-typed-arrays+available-typed-arrays-1.0.7.tgz
	https://registry.npmjs.org/axe-core/-/axe-core-4.11.4.tgz axe-core+axe-core-4.11.4.tgz
	https://registry.npmjs.org/axobject-query/-/axobject-query-4.1.0.tgz axobject-query+axobject-query-4.1.0.tgz
	https://registry.npmjs.org/babel-walk/-/babel-walk-3.0.0-canary-5.tgz babel-walk+babel-walk-3.0.0-canary-5.tgz
	https://registry.npmjs.org/bail/-/bail-2.0.2.tgz bail+bail-2.0.2.tgz
	https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz balanced-match+balanced-match-1.0.2.tgz
	https://registry.npmjs.org/balanced-match/-/balanced-match-4.0.4.tgz balanced-match+balanced-match-4.0.4.tgz
	https://registry.npmjs.org/baseline-browser-mapping/-/baseline-browser-mapping-2.10.13.tgz baseline-browser-mapping+baseline-browser-mapping-2.10.13.tgz
	https://registry.npmjs.org/blamer/-/blamer-1.0.7.tgz blamer+blamer-1.0.7.tgz
	https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.18.tgz brace-expansion+brace-expansion-1.1.18.tgz
	https://registry.npmjs.org/brace-expansion/-/brace-expansion-5.0.9.tgz brace-expansion+brace-expansion-5.0.9.tgz
	https://registry.npmjs.org/braces/-/braces-3.0.3.tgz braces+braces-3.0.3.tgz
	https://registry.npmjs.org/browser-fs-access/-/browser-fs-access-0.29.1.tgz browser-fs-access+browser-fs-access-0.29.1.tgz
	https://registry.npmjs.org/browserslist/-/browserslist-4.28.8.tgz browserslist+browserslist-4.28.8.tgz
	https://registry.npmjs.org/buffer-image-size/-/buffer-image-size-0.6.4.tgz buffer-image-size+buffer-image-size-0.6.4.tgz
	https://registry.npmjs.org/bundle-name/-/bundle-name-4.1.0.tgz bundle-name+bundle-name-4.1.0.tgz
	https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz bytes+bytes-3.1.2.tgz
	https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz call-bind-apply-helpers+call-bind-apply-helpers-1.0.2.tgz
	https://registry.npmjs.org/call-bind/-/call-bind-1.0.9.tgz call-bind+call-bind-1.0.9.tgz
	https://registry.npmjs.org/call-bound/-/call-bound-1.0.4.tgz call-bound+call-bound-1.0.4.tgz
	https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz callsites+callsites-3.1.0.tgz
	https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001782.tgz caniuse-lite+caniuse-lite-1.0.30001782.tgz
	https://registry.npmjs.org/canvas-roundrect-polyfill/-/canvas-roundrect-polyfill-0.0.1.tgz canvas-roundrect-polyfill+canvas-roundrect-polyfill-0.0.1.tgz
	https://registry.npmjs.org/ccount/-/ccount-2.0.1.tgz ccount+ccount-2.0.1.tgz
	https://registry.npmjs.org/chai/-/chai-5.3.3.tgz chai+chai-5.3.3.tgz
	https://registry.npmjs.org/chai/-/chai-6.2.2.tgz chai+chai-6.2.2.tgz
	https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz chalk+chalk-4.1.2.tgz
	https://registry.npmjs.org/character-entities-html4/-/character-entities-html4-2.1.0.tgz character-entities-html4+character-entities-html4-2.1.0.tgz
	https://registry.npmjs.org/character-entities-legacy/-/character-entities-legacy-3.0.0.tgz character-entities-legacy+character-entities-legacy-3.0.0.tgz
	https://registry.npmjs.org/character-entities/-/character-entities-2.0.2.tgz character-entities+character-entities-2.0.2.tgz
	https://registry.npmjs.org/character-parser/-/character-parser-2.2.0.tgz character-parser+character-parser-2.2.0.tgz
	https://registry.npmjs.org/character-reference-invalid/-/character-reference-invalid-2.0.1.tgz character-reference-invalid+character-reference-invalid-2.0.1.tgz
	https://registry.npmjs.org/check-error/-/check-error-2.1.3.tgz check-error+check-error-2.1.3.tgz
	https://registry.npmjs.org/chokidar/-/chokidar-5.0.0.tgz chokidar+chokidar-5.0.0.tgz
	https://registry.npmjs.org/cli-table3/-/cli-table3-0.6.5.tgz cli-table3+cli-table3-0.6.5.tgz
	https://registry.npmjs.org/cli-width/-/cli-width-4.1.0.tgz cli-width+cli-width-4.1.0.tgz
	https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz cliui+cliui-8.0.1.tgz
	https://registry.npmjs.org/clsx/-/clsx-1.1.1.tgz clsx+clsx-1.1.1.tgz
	https://registry.npmjs.org/clsx/-/clsx-2.1.1.tgz clsx+clsx-2.1.1.tgz
	https://registry.npmjs.org/cn/-/cn-0.2.6.tgz cn+cn-0.2.6.tgz
	https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz color-convert+color-convert-2.0.1.tgz
	https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz color-name+color-name-1.1.4.tgz
	https://registry.npmjs.org/colors/-/colors-1.4.0.tgz colors+colors-1.4.0.tgz
	https://registry.npmjs.org/comma-separated-tokens/-/comma-separated-tokens-2.0.3.tgz comma-separated-tokens+comma-separated-tokens-2.0.3.tgz
	https://registry.npmjs.org/commander/-/commander-5.1.0.tgz commander+commander-5.1.0.tgz
	https://registry.npmjs.org/commander/-/commander-7.2.0.tgz commander+commander-7.2.0.tgz
	https://registry.npmjs.org/commander/-/commander-8.3.0.tgz commander+commander-8.3.0.tgz
	https://registry.npmjs.org/component-emitter/-/component-emitter-2.0.0.tgz component-emitter+component-emitter-2.0.0.tgz
	https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz concat-map+concat-map-0.0.1.tgz
	https://registry.npmjs.org/constantinople/-/constantinople-4.0.1.tgz constantinople+constantinople-4.0.1.tgz
	https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz convert-source-map+convert-source-map-2.0.0.tgz
	https://registry.npmjs.org/cookie/-/cookie-1.1.1.tgz cookie+cookie-1.1.1.tgz
	https://registry.npmjs.org/cose-base/-/cose-base-1.0.3.tgz cose-base+cose-base-1.0.3.tgz
	https://registry.npmjs.org/cose-base/-/cose-base-2.2.0.tgz cose-base+cose-base-2.2.0.tgz
	https://registry.npmjs.org/crc-32/-/crc-32-0.3.0.tgz crc-32+crc-32-0.3.0.tgz
	https://registry.npmjs.org/cross-env/-/cross-env-7.0.3.tgz cross-env+cross-env-7.0.3.tgz
	https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz cross-spawn+cross-spawn-7.0.6.tgz
	https://registry.npmjs.org/css.escape/-/css.escape-1.5.1.tgz css.escape+css.escape-1.5.1.tgz
	https://registry.npmjs.org/cssstyle/-/cssstyle-4.6.0.tgz cssstyle+cssstyle-4.6.0.tgz
	https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz csstype+csstype-3.2.3.tgz
	https://registry.npmjs.org/cytoscape-cose-bilkent/-/cytoscape-cose-bilkent-4.1.0.tgz cytoscape-cose-bilkent+cytoscape-cose-bilkent-4.1.0.tgz
	https://registry.npmjs.org/cytoscape-fcose/-/cytoscape-fcose-2.2.0.tgz cytoscape-fcose+cytoscape-fcose-2.2.0.tgz
	https://registry.npmjs.org/cytoscape/-/cytoscape-3.33.1.tgz cytoscape+cytoscape-3.33.1.tgz
	https://registry.npmjs.org/d3-array/-/d3-array-2.12.1.tgz d3-array+d3-array-2.12.1.tgz
	https://registry.npmjs.org/d3-array/-/d3-array-3.2.4.tgz d3-array+d3-array-3.2.4.tgz
	https://registry.npmjs.org/d3-axis/-/d3-axis-3.0.0.tgz d3-axis+d3-axis-3.0.0.tgz
	https://registry.npmjs.org/d3-brush/-/d3-brush-3.0.0.tgz d3-brush+d3-brush-3.0.0.tgz
	https://registry.npmjs.org/d3-chord/-/d3-chord-3.0.1.tgz d3-chord+d3-chord-3.0.1.tgz
	https://registry.npmjs.org/d3-color/-/d3-color-3.1.0.tgz d3-color+d3-color-3.1.0.tgz
	https://registry.npmjs.org/d3-contour/-/d3-contour-4.0.2.tgz d3-contour+d3-contour-4.0.2.tgz
	https://registry.npmjs.org/d3-delaunay/-/d3-delaunay-6.0.4.tgz d3-delaunay+d3-delaunay-6.0.4.tgz
	https://registry.npmjs.org/d3-dispatch/-/d3-dispatch-3.0.1.tgz d3-dispatch+d3-dispatch-3.0.1.tgz
	https://registry.npmjs.org/d3-drag/-/d3-drag-3.0.0.tgz d3-drag+d3-drag-3.0.0.tgz
	https://registry.npmjs.org/d3-dsv/-/d3-dsv-3.0.1.tgz d3-dsv+d3-dsv-3.0.1.tgz
	https://registry.npmjs.org/d3-ease/-/d3-ease-3.0.1.tgz d3-ease+d3-ease-3.0.1.tgz
	https://registry.npmjs.org/d3-fetch/-/d3-fetch-3.0.1.tgz d3-fetch+d3-fetch-3.0.1.tgz
	https://registry.npmjs.org/d3-force/-/d3-force-3.0.0.tgz d3-force+d3-force-3.0.0.tgz
	https://registry.npmjs.org/d3-format/-/d3-format-3.1.2.tgz d3-format+d3-format-3.1.2.tgz
	https://registry.npmjs.org/d3-geo/-/d3-geo-3.1.1.tgz d3-geo+d3-geo-3.1.1.tgz
	https://registry.npmjs.org/d3-hierarchy/-/d3-hierarchy-3.1.2.tgz d3-hierarchy+d3-hierarchy-3.1.2.tgz
	https://registry.npmjs.org/d3-interpolate/-/d3-interpolate-3.0.1.tgz d3-interpolate+d3-interpolate-3.0.1.tgz
	https://registry.npmjs.org/d3-path/-/d3-path-1.0.9.tgz d3-path+d3-path-1.0.9.tgz
	https://registry.npmjs.org/d3-path/-/d3-path-3.1.0.tgz d3-path+d3-path-3.1.0.tgz
	https://registry.npmjs.org/d3-polygon/-/d3-polygon-3.0.1.tgz d3-polygon+d3-polygon-3.0.1.tgz
	https://registry.npmjs.org/d3-quadtree/-/d3-quadtree-3.0.1.tgz d3-quadtree+d3-quadtree-3.0.1.tgz
	https://registry.npmjs.org/d3-random/-/d3-random-3.0.1.tgz d3-random+d3-random-3.0.1.tgz
	https://registry.npmjs.org/d3-sankey/-/d3-sankey-0.12.3.tgz d3-sankey+d3-sankey-0.12.3.tgz
	https://registry.npmjs.org/d3-scale-chromatic/-/d3-scale-chromatic-3.1.0.tgz d3-scale-chromatic+d3-scale-chromatic-3.1.0.tgz
	https://registry.npmjs.org/d3-scale/-/d3-scale-4.0.2.tgz d3-scale+d3-scale-4.0.2.tgz
	https://registry.npmjs.org/d3-selection/-/d3-selection-3.0.0.tgz d3-selection+d3-selection-3.0.0.tgz
	https://registry.npmjs.org/d3-shape/-/d3-shape-1.3.7.tgz d3-shape+d3-shape-1.3.7.tgz
	https://registry.npmjs.org/d3-shape/-/d3-shape-3.2.0.tgz d3-shape+d3-shape-3.2.0.tgz
	https://registry.npmjs.org/d3-time-format/-/d3-time-format-4.1.0.tgz d3-time-format+d3-time-format-4.1.0.tgz
	https://registry.npmjs.org/d3-time/-/d3-time-3.1.0.tgz d3-time+d3-time-3.1.0.tgz
	https://registry.npmjs.org/d3-timer/-/d3-timer-3.0.1.tgz d3-timer+d3-timer-3.0.1.tgz
	https://registry.npmjs.org/d3-transition/-/d3-transition-3.0.1.tgz d3-transition+d3-transition-3.0.1.tgz
	https://registry.npmjs.org/d3-zoom/-/d3-zoom-3.0.0.tgz d3-zoom+d3-zoom-3.0.0.tgz
	https://registry.npmjs.org/d3/-/d3-7.9.0.tgz d3+d3-7.9.0.tgz
	https://registry.npmjs.org/dagre-d3-es/-/dagre-d3-es-7.0.14.tgz dagre-d3-es+dagre-d3-es-7.0.14.tgz
	https://registry.npmjs.org/damerau-levenshtein/-/damerau-levenshtein-1.0.8.tgz damerau-levenshtein+damerau-levenshtein-1.0.8.tgz
	https://registry.npmjs.org/data-urls/-/data-urls-5.0.0.tgz data-urls+data-urls-5.0.0.tgz
	https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.2.tgz data-view-buffer+data-view-buffer-1.0.2.tgz
	https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.2.tgz data-view-byte-length+data-view-byte-length-1.0.2.tgz
	https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.1.tgz data-view-byte-offset+data-view-byte-offset-1.0.1.tgz
	https://registry.npmjs.org/dayjs/-/dayjs-1.11.21.tgz dayjs+dayjs-1.11.21.tgz
	https://registry.npmjs.org/debug/-/debug-4.4.3.tgz debug+debug-4.4.3.tgz
	https://registry.npmjs.org/decimal.js/-/decimal.js-10.6.0.tgz decimal.js+decimal.js-10.6.0.tgz
	https://registry.npmjs.org/decode-named-character-reference/-/decode-named-character-reference-1.3.0.tgz decode-named-character-reference+decode-named-character-reference-1.3.0.tgz
	https://registry.npmjs.org/deep-eql/-/deep-eql-5.0.2.tgz deep-eql+deep-eql-5.0.2.tgz
	https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz deep-is+deep-is-0.1.4.tgz
	https://registry.npmjs.org/default-browser-id/-/default-browser-id-5.0.1.tgz default-browser-id+default-browser-id-5.0.1.tgz
	https://registry.npmjs.org/default-browser/-/default-browser-5.5.1.tgz default-browser+default-browser-5.5.1.tgz
	https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz define-data-property+define-data-property-1.1.4.tgz
	https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-3.0.0.tgz define-lazy-prop+define-lazy-prop-3.0.0.tgz
	https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz define-properties+define-properties-1.2.1.tgz
	https://registry.npmjs.org/delaunator/-/delaunator-5.1.0.tgz delaunator+delaunator-5.1.0.tgz
	https://registry.npmjs.org/dequal/-/dequal-2.0.3.tgz dequal+dequal-2.0.3.tgz
	https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz detect-libc+detect-libc-2.1.2.tgz
	https://registry.npmjs.org/detect-node-es/-/detect-node-es-1.1.0.tgz detect-node-es+detect-node-es-1.1.0.tgz
	https://registry.npmjs.org/devlop/-/devlop-1.1.0.tgz devlop+devlop-1.1.0.tgz
	https://registry.npmjs.org/diff/-/diff-9.0.0.tgz diff+diff-9.0.0.tgz
	https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz doctrine+doctrine-3.0.0.tgz
	https://registry.npmjs.org/doctypes/-/doctypes-1.1.0.tgz doctypes+doctypes-1.1.0.tgz
	https://registry.npmjs.org/dom-accessibility-api/-/dom-accessibility-api-0.5.16.tgz dom-accessibility-api+dom-accessibility-api-0.5.16.tgz
	https://registry.npmjs.org/dom-accessibility-api/-/dom-accessibility-api-0.6.3.tgz dom-accessibility-api+dom-accessibility-api-0.6.3.tgz
	https://registry.npmjs.org/dompurify/-/dompurify-3.4.13.tgz dompurify+dompurify-3.4.13.tgz
	https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz dunder-proto+dunder-proto-1.0.1.tgz
	https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.329.tgz electron-to-chromium+electron-to-chromium-1.5.329.tgz
	https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz emoji-regex+emoji-regex-8.0.0.tgz
	https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz emoji-regex+emoji-regex-9.2.2.tgz
	https://registry.npmjs.org/empathic/-/empathic-2.0.1.tgz empathic+empathic-2.0.1.tgz
	https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.5.tgz end-of-stream+end-of-stream-1.4.5.tgz
	https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.25.0.tgz enhanced-resolve+enhanced-resolve-5.25.0.tgz
	https://registry.npmjs.org/entities/-/entities-6.0.1.tgz entities+entities-6.0.1.tgz
	https://registry.npmjs.org/entities/-/entities-7.0.1.tgz entities+entities-7.0.1.tgz
	https://registry.npmjs.org/es-abstract/-/es-abstract-1.24.2.tgz es-abstract+es-abstract-1.24.2.tgz
	https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz es-define-property+es-define-property-1.0.1.tgz
	https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz es-errors+es-errors-1.3.0.tgz
	https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-2.3.2.tgz es-module-lexer+es-module-lexer-2.3.2.tgz
	https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.2.tgz es-object-atoms+es-object-atoms-1.1.2.tgz
	https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.1.0.tgz es-set-tostringtag+es-set-tostringtag-2.1.0.tgz
	https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.1.0.tgz es-shim-unscopables+es-shim-unscopables-1.1.0.tgz
	https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.3.0.tgz es-to-primitive+es-to-primitive-1.3.0.tgz
	https://registry.npmjs.org/es-toolkit/-/es-toolkit-1.50.0.tgz es-toolkit+es-toolkit-1.50.0.tgz
	https://registry.npmjs.org/es6-promise-pool/-/es6-promise-pool-2.5.0.tgz es6-promise-pool+es6-promise-pool-2.5.0.tgz
	https://registry.npmjs.org/esbuild/-/esbuild-0.25.12.tgz esbuild+esbuild-0.25.12.tgz
	https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz escalade+escalade-3.2.0.tgz
	https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz escape-string-regexp+escape-string-regexp-4.0.0.tgz
	https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-5.0.0.tgz escape-string-regexp+escape-string-regexp-5.0.0.tgz
	https://registry.npmjs.org/eslint-plugin-i18next/-/eslint-plugin-i18next-6.1.5.tgz eslint-plugin-i18next+eslint-plugin-i18next-6.1.5.tgz
	https://registry.npmjs.org/eslint-plugin-jsx-a11y/-/eslint-plugin-jsx-a11y-6.10.2.tgz eslint-plugin-jsx-a11y+eslint-plugin-jsx-a11y-6.10.2.tgz
	https://registry.npmjs.org/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-7.0.1.tgz eslint-plugin-react-hooks+eslint-plugin-react-hooks-7.0.1.tgz
	https://registry.npmjs.org/eslint-scope/-/eslint-scope-8.4.0.tgz eslint-scope+eslint-scope-8.4.0.tgz
	https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz eslint-visitor-keys+eslint-visitor-keys-3.4.3.tgz
	https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-4.2.1.tgz eslint-visitor-keys+eslint-visitor-keys-4.2.1.tgz
	https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-5.0.1.tgz eslint-visitor-keys+eslint-visitor-keys-5.0.1.tgz
	https://registry.npmjs.org/eslint/-/eslint-9.39.4.tgz eslint+eslint-9.39.4.tgz
	https://registry.npmjs.org/espree/-/espree-10.4.0.tgz espree+espree-10.4.0.tgz
	https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz esprima+esprima-4.0.1.tgz
	https://registry.npmjs.org/esquery/-/esquery-1.7.0.tgz esquery+esquery-1.7.0.tgz
	https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz esrecurse+esrecurse-4.3.0.tgz
	https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz estraverse+estraverse-5.3.0.tgz
	https://registry.npmjs.org/estree-util-is-identifier-name/-/estree-util-is-identifier-name-3.0.0.tgz estree-util-is-identifier-name+estree-util-is-identifier-name-3.0.0.tgz
	https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz estree-walker+estree-walker-2.0.2.tgz
	https://registry.npmjs.org/estree-walker/-/estree-walker-3.0.3.tgz estree-walker+estree-walker-3.0.3.tgz
	https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz esutils+esutils-2.0.3.tgz
	https://registry.npmjs.org/eventemitter3/-/eventemitter3-5.0.4.tgz eventemitter3+eventemitter3-5.0.4.tgz
	https://registry.npmjs.org/events/-/events-3.3.0.tgz events+events-3.3.0.tgz
	https://registry.npmjs.org/execa/-/execa-4.1.0.tgz execa+execa-4.1.0.tgz
	https://registry.npmjs.org/expect-type/-/expect-type-1.4.0.tgz expect-type+expect-type-1.4.0.tgz
	https://registry.npmjs.org/extend/-/extend-3.0.2.tgz extend+extend-3.0.2.tgz
	https://registry.npmjs.org/fast-check/-/fast-check-4.6.0.tgz fast-check+fast-check-4.6.0.tgz
	https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz fast-deep-equal+fast-deep-equal-3.1.3.tgz
	https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz fast-glob+fast-glob-3.3.3.tgz
	https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz fast-json-stable-stringify+fast-json-stable-stringify-2.1.0.tgz
	https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz fast-levenshtein+fast-levenshtein-2.0.6.tgz
	https://registry.npmjs.org/fast-string-truncated-width/-/fast-string-truncated-width-3.0.3.tgz fast-string-truncated-width+fast-string-truncated-width-3.0.3.tgz
	https://registry.npmjs.org/fast-string-width/-/fast-string-width-3.0.2.tgz fast-string-width+fast-string-width-3.0.2.tgz
	https://registry.npmjs.org/fast-wrap-ansi/-/fast-wrap-ansi-0.2.2.tgz fast-wrap-ansi+fast-wrap-ansi-0.2.2.tgz
	https://registry.npmjs.org/fastq/-/fastq-1.20.1.tgz fastq+fastq-1.20.1.tgz
	https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz fdir+fdir-6.5.0.tgz
	https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-8.0.0.tgz file-entry-cache+file-entry-cache-8.0.0.tgz
	https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz fill-range+fill-range-7.1.1.tgz
	https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz find-up+find-up-5.0.0.tgz
	https://registry.npmjs.org/flat-cache/-/flat-cache-4.0.1.tgz flat-cache+flat-cache-4.0.1.tgz
	https://registry.npmjs.org/flatted/-/flatted-3.4.2.tgz flatted+flatted-3.4.2.tgz
	https://registry.npmjs.org/for-each/-/for-each-0.3.5.tgz for-each+for-each-0.3.5.tgz
	https://registry.npmjs.org/fractional-indexing/-/fractional-indexing-3.2.0.tgz fractional-indexing+fractional-indexing-3.2.0.tgz
	https://registry.npmjs.org/framer-motion/-/framer-motion-12.40.0.tgz framer-motion+framer-motion-12.40.0.tgz
	https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz fs-extra+fs-extra-9.1.0.tgz
	https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz fsevents+fsevents-2.3.2.tgz
	https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz fsevents+fsevents-2.3.3.tgz
	https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz function-bind+function-bind-1.1.2.tgz
	https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.8.tgz function.prototype.name+function.prototype.name-1.1.8.tgz
	https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz functions-have-names+functions-have-names-1.2.3.tgz
	https://registry.npmjs.org/fuzzy/-/fuzzy-0.1.3.tgz fuzzy+fuzzy-0.1.3.tgz
	https://registry.npmjs.org/generator-function/-/generator-function-2.0.1.tgz generator-function+generator-function-2.0.1.tgz
	https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz gensync+gensync-1.0.0-beta.2.tgz
	https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz get-caller-file+get-caller-file-2.0.5.tgz
	https://registry.npmjs.org/get-east-asian-width/-/get-east-asian-width-1.6.0.tgz get-east-asian-width+get-east-asian-width-1.6.0.tgz
	https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz get-intrinsic+get-intrinsic-1.3.0.tgz
	https://registry.npmjs.org/get-nonce/-/get-nonce-1.0.1.tgz get-nonce+get-nonce-1.0.1.tgz
	https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz get-proto+get-proto-1.0.1.tgz
	https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz get-stream+get-stream-5.2.0.tgz
	https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.1.0.tgz get-symbol-description+get-symbol-description-1.1.0.tgz
	https://registry.npmjs.org/gitignore-to-glob/-/gitignore-to-glob-0.3.0.tgz gitignore-to-glob+gitignore-to-glob-0.3.0.tgz
	https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz glob-parent+glob-parent-5.1.2.tgz
	https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz glob-parent+glob-parent-6.0.2.tgz
	https://registry.npmjs.org/glob/-/glob-13.0.6.tgz glob+glob-13.0.6.tgz
	https://registry.npmjs.org/globals/-/globals-14.0.0.tgz globals+globals-14.0.0.tgz
	https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz globalthis+globalthis-1.0.4.tgz
	https://registry.npmjs.org/glur/-/glur-1.1.2.tgz glur+glur-1.1.2.tgz
	https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz gopd+gopd-1.2.0.tgz
	https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz graceful-fs+graceful-fs-4.2.11.tgz
	https://registry.npmjs.org/graphology-communities-louvain/-/graphology-communities-louvain-2.0.2.tgz graphology-communities-louvain+graphology-communities-louvain-2.0.2.tgz
	https://registry.npmjs.org/graphology-indices/-/graphology-indices-0.17.0.tgz graphology-indices+graphology-indices-0.17.0.tgz
	https://registry.npmjs.org/graphology-layout-forceatlas2/-/graphology-layout-forceatlas2-0.10.1.tgz graphology-layout-forceatlas2+graphology-layout-forceatlas2-0.10.1.tgz
	https://registry.npmjs.org/graphology-types/-/graphology-types-0.24.8.tgz graphology-types+graphology-types-0.24.8.tgz
	https://registry.npmjs.org/graphology-utils/-/graphology-utils-2.5.2.tgz graphology-utils+graphology-utils-2.5.2.tgz
	https://registry.npmjs.org/graphology/-/graphology-0.26.0.tgz graphology+graphology-0.26.0.tgz
	https://registry.npmjs.org/graphql/-/graphql-16.14.1.tgz graphql+graphql-16.14.1.tgz
	https://registry.npmjs.org/hachure-fill/-/hachure-fill-0.5.2.tgz hachure-fill+hachure-fill-0.5.2.tgz
	https://registry.npmjs.org/happy-dom/-/happy-dom-20.11.6.tgz happy-dom+happy-dom-20.11.6.tgz
	https://registry.npmjs.org/has-bigints/-/has-bigints-1.1.0.tgz has-bigints+has-bigints-1.1.0.tgz
	https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz has-flag+has-flag-4.0.0.tgz
	https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz has-property-descriptors+has-property-descriptors-1.0.2.tgz
	https://registry.npmjs.org/has-proto/-/has-proto-1.2.0.tgz has-proto+has-proto-1.2.0.tgz
	https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz has-symbols+has-symbols-1.1.0.tgz
	https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz has-tostringtag+has-tostringtag-1.0.2.tgz
	https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz hasown+hasown-2.0.2.tgz
	https://registry.npmjs.org/hast-util-from-dom/-/hast-util-from-dom-5.0.1.tgz hast-util-from-dom+hast-util-from-dom-5.0.1.tgz
	https://registry.npmjs.org/hast-util-from-html-isomorphic/-/hast-util-from-html-isomorphic-2.0.0.tgz hast-util-from-html-isomorphic+hast-util-from-html-isomorphic-2.0.0.tgz
	https://registry.npmjs.org/hast-util-from-html/-/hast-util-from-html-2.0.3.tgz hast-util-from-html+hast-util-from-html-2.0.3.tgz
	https://registry.npmjs.org/hast-util-from-parse5/-/hast-util-from-parse5-8.0.3.tgz hast-util-from-parse5+hast-util-from-parse5-8.0.3.tgz
	https://registry.npmjs.org/hast-util-is-element/-/hast-util-is-element-3.0.0.tgz hast-util-is-element+hast-util-is-element-3.0.0.tgz
	https://registry.npmjs.org/hast-util-parse-selector/-/hast-util-parse-selector-4.0.0.tgz hast-util-parse-selector+hast-util-parse-selector-4.0.0.tgz
	https://registry.npmjs.org/hast-util-raw/-/hast-util-raw-9.1.0.tgz hast-util-raw+hast-util-raw-9.1.0.tgz
	https://registry.npmjs.org/hast-util-to-html/-/hast-util-to-html-9.0.5.tgz hast-util-to-html+hast-util-to-html-9.0.5.tgz
	https://registry.npmjs.org/hast-util-to-jsx-runtime/-/hast-util-to-jsx-runtime-2.3.6.tgz hast-util-to-jsx-runtime+hast-util-to-jsx-runtime-2.3.6.tgz
	https://registry.npmjs.org/hast-util-to-parse5/-/hast-util-to-parse5-8.0.1.tgz hast-util-to-parse5+hast-util-to-parse5-8.0.1.tgz
	https://registry.npmjs.org/hast-util-to-text/-/hast-util-to-text-4.0.2.tgz hast-util-to-text+hast-util-to-text-4.0.2.tgz
	https://registry.npmjs.org/hast-util-whitespace/-/hast-util-whitespace-3.0.0.tgz hast-util-whitespace+hast-util-whitespace-3.0.0.tgz
	https://registry.npmjs.org/hastscript/-/hastscript-9.0.1.tgz hastscript+hastscript-9.0.1.tgz
	https://registry.npmjs.org/headers-polyfill/-/headers-polyfill-4.0.3.tgz headers-polyfill+headers-polyfill-4.0.3.tgz
	https://registry.npmjs.org/hermes-estree/-/hermes-estree-0.25.1.tgz hermes-estree+hermes-estree-0.25.1.tgz
	https://registry.npmjs.org/hermes-parser/-/hermes-parser-0.25.1.tgz hermes-parser+hermes-parser-0.25.1.tgz
	https://registry.npmjs.org/highlight.js/-/highlight.js-11.11.1.tgz highlight.js+highlight.js-11.11.1.tgz
	https://registry.npmjs.org/html-encoding-sniffer/-/html-encoding-sniffer-4.0.0.tgz html-encoding-sniffer+html-encoding-sniffer-4.0.0.tgz
	https://registry.npmjs.org/html-escaper/-/html-escaper-2.0.2.tgz html-escaper+html-escaper-2.0.2.tgz
	https://registry.npmjs.org/html-parse-stringify/-/html-parse-stringify-4.0.1.tgz html-parse-stringify+html-parse-stringify-4.0.1.tgz
	https://registry.npmjs.org/html-to-image/-/html-to-image-1.11.13.tgz html-to-image+html-to-image-1.11.13.tgz
	https://registry.npmjs.org/html-url-attributes/-/html-url-attributes-3.0.1.tgz html-url-attributes+html-url-attributes-3.0.1.tgz
	https://registry.npmjs.org/html-void-elements/-/html-void-elements-3.0.0.tgz html-void-elements+html-void-elements-3.0.0.tgz
	https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz http-proxy-agent+http-proxy-agent-7.0.2.tgz
	https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.6.tgz https-proxy-agent+https-proxy-agent-7.0.6.tgz
	https://registry.npmjs.org/human-signals/-/human-signals-1.1.1.tgz human-signals+human-signals-1.1.1.tgz
	https://registry.npmjs.org/i18next/-/i18next-26.3.6.tgz i18next+i18next-26.3.6.tgz
	https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz iconv-lite+iconv-lite-0.6.3.tgz
	https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz ignore+ignore-5.3.2.tgz
	https://registry.npmjs.org/ignore/-/ignore-7.0.5.tgz ignore+ignore-7.0.5.tgz
	https://registry.npmjs.org/image-blob-reduce/-/image-blob-reduce-3.0.1.tgz image-blob-reduce+image-blob-reduce-3.0.1.tgz
	https://registry.npmjs.org/immer/-/immer-11.1.8.tgz immer+immer-11.1.8.tgz
	https://registry.npmjs.org/immutable/-/immutable-5.1.9.tgz immutable+immutable-5.1.9.tgz
	https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.1.tgz import-fresh+import-fresh-3.3.1.tgz
	https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-4.2.0.tgz import-meta-resolve+import-meta-resolve-4.2.0.tgz
	https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz imurmurhash+imurmurhash-0.1.4.tgz
	https://registry.npmjs.org/indent-string/-/indent-string-4.0.0.tgz indent-string+indent-string-4.0.0.tgz
	https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz inherits+inherits-2.0.4.tgz
	https://registry.npmjs.org/inline-style-parser/-/inline-style-parser-0.2.7.tgz inline-style-parser+inline-style-parser-0.2.7.tgz
	https://registry.npmjs.org/internal-slot/-/internal-slot-1.1.0.tgz internal-slot+internal-slot-1.1.0.tgz
	https://registry.npmjs.org/internmap/-/internmap-1.0.1.tgz internmap+internmap-1.0.1.tgz
	https://registry.npmjs.org/internmap/-/internmap-2.0.3.tgz internmap+internmap-2.0.3.tgz
	https://registry.npmjs.org/is-alphabetical/-/is-alphabetical-2.0.1.tgz is-alphabetical+is-alphabetical-2.0.1.tgz
	https://registry.npmjs.org/is-alphanumerical/-/is-alphanumerical-2.0.1.tgz is-alphanumerical+is-alphanumerical-2.0.1.tgz
	https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.5.tgz is-array-buffer+is-array-buffer-3.0.5.tgz
	https://registry.npmjs.org/is-async-function/-/is-async-function-2.1.1.tgz is-async-function+is-async-function-2.1.1.tgz
	https://registry.npmjs.org/is-bigint/-/is-bigint-1.1.0.tgz is-bigint+is-bigint-1.1.0.tgz
	https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.2.2.tgz is-boolean-object+is-boolean-object-1.2.2.tgz
	https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz is-callable+is-callable-1.2.7.tgz
	https://registry.npmjs.org/is-core-module/-/is-core-module-2.16.2.tgz is-core-module+is-core-module-2.16.2.tgz
	https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.2.tgz is-data-view+is-data-view-1.0.2.tgz
	https://registry.npmjs.org/is-date-object/-/is-date-object-1.1.0.tgz is-date-object+is-date-object-1.1.0.tgz
	https://registry.npmjs.org/is-decimal/-/is-decimal-2.0.1.tgz is-decimal+is-decimal-2.0.1.tgz
	https://registry.npmjs.org/is-docker/-/is-docker-3.0.0.tgz is-docker+is-docker-3.0.0.tgz
	https://registry.npmjs.org/is-expression/-/is-expression-4.0.0.tgz is-expression+is-expression-4.0.0.tgz
	https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz is-extglob+is-extglob-2.1.1.tgz
	https://registry.npmjs.org/is-finalizationregistry/-/is-finalizationregistry-1.1.1.tgz is-finalizationregistry+is-finalizationregistry-1.1.1.tgz
	https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz is-fullwidth-code-point+is-fullwidth-code-point-3.0.0.tgz
	https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.1.2.tgz is-generator-function+is-generator-function-1.1.2.tgz
	https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz is-glob+is-glob-4.0.3.tgz
	https://registry.npmjs.org/is-hexadecimal/-/is-hexadecimal-2.0.1.tgz is-hexadecimal+is-hexadecimal-2.0.1.tgz
	https://registry.npmjs.org/is-inside-container/-/is-inside-container-1.0.0.tgz is-inside-container+is-inside-container-1.0.0.tgz
	https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz is-map+is-map-2.0.3.tgz
	https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz is-negative-zero+is-negative-zero-2.0.3.tgz
	https://registry.npmjs.org/is-node-process/-/is-node-process-1.2.0.tgz is-node-process+is-node-process-1.2.0.tgz
	https://registry.npmjs.org/is-number-object/-/is-number-object-1.1.1.tgz is-number-object+is-number-object-1.1.1.tgz
	https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz is-number+is-number-7.0.0.tgz
	https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz is-plain-obj+is-plain-obj-4.1.0.tgz
	https://registry.npmjs.org/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz is-potential-custom-element-name+is-potential-custom-element-name-1.0.1.tgz
	https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz is-promise+is-promise-2.2.2.tgz
	https://registry.npmjs.org/is-regex/-/is-regex-1.2.1.tgz is-regex+is-regex-1.2.1.tgz
	https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz is-set+is-set-2.0.3.tgz
	https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.4.tgz is-shared-array-buffer+is-shared-array-buffer-1.0.4.tgz
	https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz is-stream+is-stream-2.0.1.tgz
	https://registry.npmjs.org/is-string/-/is-string-1.1.1.tgz is-string+is-string-1.1.1.tgz
	https://registry.npmjs.org/is-symbol/-/is-symbol-1.1.1.tgz is-symbol+is-symbol-1.1.1.tgz
	https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.15.tgz is-typed-array+is-typed-array-1.1.15.tgz
	https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz is-weakmap+is-weakmap-2.0.2.tgz
	https://registry.npmjs.org/is-weakref/-/is-weakref-1.1.1.tgz is-weakref+is-weakref-1.1.1.tgz
	https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.4.tgz is-weakset+is-weakset-2.0.4.tgz
	https://registry.npmjs.org/is-wsl/-/is-wsl-3.1.1.tgz is-wsl+is-wsl-3.1.1.tgz
	https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz isarray+isarray-2.0.5.tgz
	https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz isexe+isexe-2.0.0.tgz
	https://registry.npmjs.org/isomorphic.js/-/isomorphic.js-0.2.5.tgz isomorphic.js+isomorphic.js-0.2.5.tgz
	https://registry.npmjs.org/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz istanbul-lib-coverage+istanbul-lib-coverage-3.2.2.tgz
	https://registry.npmjs.org/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz istanbul-lib-report+istanbul-lib-report-3.0.1.tgz
	https://registry.npmjs.org/istanbul-reports/-/istanbul-reports-3.2.0.tgz istanbul-reports+istanbul-reports-3.2.0.tgz
	https://registry.npmjs.org/jiti/-/jiti-2.7.0.tgz jiti+jiti-2.7.0.tgz
	https://registry.npmjs.org/jotai-scope/-/jotai-scope-0.7.2.tgz jotai-scope+jotai-scope-0.7.2.tgz
	https://registry.npmjs.org/jotai/-/jotai-2.11.0.tgz jotai+jotai-2.11.0.tgz
	https://registry.npmjs.org/js-stringify/-/js-stringify-1.0.2.tgz js-stringify+js-stringify-1.0.2.tgz
	https://registry.npmjs.org/js-tokens/-/js-tokens-10.0.0.tgz js-tokens+js-tokens-10.0.0.tgz
	https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz js-tokens+js-tokens-4.0.0.tgz
	https://registry.npmjs.org/js-yaml/-/js-yaml-4.3.2.tgz js-yaml+js-yaml-4.3.2.tgz
	https://registry.npmjs.org/jscpd/-/jscpd-3.5.10.tgz jscpd+jscpd-3.5.10.tgz
	https://registry.npmjs.org/jsdom/-/jsdom-26.1.0.tgz jsdom+jsdom-26.1.0.tgz
	https://registry.npmjs.org/jsesc/-/jsesc-3.1.0.tgz jsesc+jsesc-3.1.0.tgz
	https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz json-buffer+json-buffer-3.0.1.tgz
	https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz json-schema-traverse+json-schema-traverse-0.4.1.tgz
	https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz json-stable-stringify-without-jsonify+json-stable-stringify-without-jsonify-1.0.1.tgz
	https://registry.npmjs.org/json5/-/json5-2.2.3.tgz json5+json5-2.2.3.tgz
	https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.3.1.tgz jsonc-parser+jsonc-parser-3.3.1.tgz
	https://registry.npmjs.org/jsonfile/-/jsonfile-6.2.1.tgz jsonfile+jsonfile-6.2.1.tgz
	https://registry.npmjs.org/jstransformer/-/jstransformer-1.0.0.tgz jstransformer+jstransformer-1.0.0.tgz
	https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.3.5.tgz jsx-ast-utils+jsx-ast-utils-3.3.5.tgz
	https://registry.npmjs.org/katex/-/katex-0.16.44.tgz katex+katex-0.16.44.tgz
	https://registry.npmjs.org/keycharm/-/keycharm-0.4.0.tgz keycharm+keycharm-0.4.0.tgz
	https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz keyv+keyv-4.5.4.tgz
	https://registry.npmjs.org/khroma/-/khroma-2.1.0.tgz khroma+khroma-2.1.0.tgz
	https://registry.npmjs.org/language-subtag-registry/-/language-subtag-registry-0.3.23.tgz language-subtag-registry+language-subtag-registry-0.3.23.tgz
	https://registry.npmjs.org/language-tags/-/language-tags-1.0.9.tgz language-tags+language-tags-1.0.9.tgz
	https://registry.npmjs.org/layout-base/-/layout-base-1.0.2.tgz layout-base+layout-base-1.0.2.tgz
	https://registry.npmjs.org/layout-base/-/layout-base-2.0.1.tgz layout-base+layout-base-2.0.1.tgz
	https://registry.npmjs.org/levn/-/levn-0.4.1.tgz levn+levn-0.4.1.tgz
	https://registry.npmjs.org/lexical/-/lexical-0.50.0.tgz lexical+lexical-0.50.0.tgz
	https://registry.npmjs.org/lib0/-/lib0-0.2.117.tgz lib0+lib0-0.2.117.tgz
	https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.32.0.tgz lightningcss-android-arm64+lightningcss-android-arm64-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.33.0.tgz lightningcss-android-arm64+lightningcss-android-arm64-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.32.0.tgz lightningcss-darwin-arm64+lightningcss-darwin-arm64-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.33.0.tgz lightningcss-darwin-arm64+lightningcss-darwin-arm64-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.32.0.tgz lightningcss-darwin-x64+lightningcss-darwin-x64-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.33.0.tgz lightningcss-darwin-x64+lightningcss-darwin-x64-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.32.0.tgz lightningcss-freebsd-x64+lightningcss-freebsd-x64-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.33.0.tgz lightningcss-freebsd-x64+lightningcss-freebsd-x64-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.32.0.tgz lightningcss-linux-arm-gnueabihf+lightningcss-linux-arm-gnueabihf-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.33.0.tgz lightningcss-linux-arm-gnueabihf+lightningcss-linux-arm-gnueabihf-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.32.0.tgz lightningcss-linux-arm64-gnu+lightningcss-linux-arm64-gnu-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.33.0.tgz lightningcss-linux-arm64-gnu+lightningcss-linux-arm64-gnu-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.32.0.tgz lightningcss-linux-arm64-musl+lightningcss-linux-arm64-musl-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.33.0.tgz lightningcss-linux-arm64-musl+lightningcss-linux-arm64-musl-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.32.0.tgz lightningcss-linux-x64-gnu+lightningcss-linux-x64-gnu-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.33.0.tgz lightningcss-linux-x64-gnu+lightningcss-linux-x64-gnu-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-linux-x64-musl/-/lightningcss-linux-x64-musl-1.32.0.tgz lightningcss-linux-x64-musl+lightningcss-linux-x64-musl-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-linux-x64-musl/-/lightningcss-linux-x64-musl-1.33.0.tgz lightningcss-linux-x64-musl+lightningcss-linux-x64-musl-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-win32-arm64-msvc/-/lightningcss-win32-arm64-msvc-1.32.0.tgz lightningcss-win32-arm64-msvc+lightningcss-win32-arm64-msvc-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-win32-arm64-msvc/-/lightningcss-win32-arm64-msvc-1.33.0.tgz lightningcss-win32-arm64-msvc+lightningcss-win32-arm64-msvc-1.33.0.tgz
	https://registry.npmjs.org/lightningcss-win32-x64-msvc/-/lightningcss-win32-x64-msvc-1.32.0.tgz lightningcss-win32-x64-msvc+lightningcss-win32-x64-msvc-1.32.0.tgz
	https://registry.npmjs.org/lightningcss-win32-x64-msvc/-/lightningcss-win32-x64-msvc-1.33.0.tgz lightningcss-win32-x64-msvc+lightningcss-win32-x64-msvc-1.33.0.tgz
	https://registry.npmjs.org/lightningcss/-/lightningcss-1.32.0.tgz lightningcss+lightningcss-1.32.0.tgz
	https://registry.npmjs.org/lightningcss/-/lightningcss-1.33.0.tgz lightningcss+lightningcss-1.33.0.tgz
	https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz locate-path+locate-path-6.0.0.tgz
	https://registry.npmjs.org/lodash-es/-/lodash-es-4.18.1.tgz lodash-es+lodash-es-4.18.1.tgz
	https://registry.npmjs.org/lodash.debounce/-/lodash.debounce-4.0.8.tgz lodash.debounce+lodash.debounce-4.0.8.tgz
	https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz lodash.merge+lodash.merge-4.6.2.tgz
	https://registry.npmjs.org/lodash.throttle/-/lodash.throttle-4.1.1.tgz lodash.throttle+lodash.throttle-4.1.1.tgz
	https://registry.npmjs.org/longest-streak/-/longest-streak-3.1.0.tgz longest-streak+longest-streak-3.1.0.tgz
	https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz loose-envify+loose-envify-1.4.0.tgz
	https://registry.npmjs.org/lottie-web/-/lottie-web-5.13.0.tgz lottie-web+lottie-web-5.13.0.tgz
	https://registry.npmjs.org/loupe/-/loupe-3.2.1.tgz loupe+loupe-3.2.1.tgz
	https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz lru-cache+lru-cache-10.4.3.tgz
	https://registry.npmjs.org/lru-cache/-/lru-cache-11.5.2.tgz lru-cache+lru-cache-11.5.2.tgz
	https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz lru-cache+lru-cache-5.1.1.tgz
	https://registry.npmjs.org/lru_map/-/lru_map-0.4.1.tgz lru_map+lru_map-0.4.1.tgz
	https://registry.npmjs.org/lucide-react/-/lucide-react-1.7.0.tgz lucide-react+lucide-react-1.7.0.tgz
	https://registry.npmjs.org/lz-string/-/lz-string-1.5.0.tgz lz-string+lz-string-1.5.0.tgz
	https://registry.npmjs.org/magic-string/-/magic-string-0.30.21.tgz magic-string+magic-string-0.30.21.tgz
	https://registry.npmjs.org/magicast/-/magicast-0.5.4.tgz magicast+magicast-0.5.4.tgz
	https://registry.npmjs.org/make-dir/-/make-dir-4.0.0.tgz make-dir+make-dir-4.0.0.tgz
	https://registry.npmjs.org/markdown-table/-/markdown-table-2.0.0.tgz markdown-table+markdown-table-2.0.0.tgz
	https://registry.npmjs.org/markdown-table/-/markdown-table-3.0.4.tgz markdown-table+markdown-table-3.0.4.tgz
	https://registry.npmjs.org/marked/-/marked-16.4.2.tgz marked+marked-16.4.2.tgz
	https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz math-intrinsics+math-intrinsics-1.1.0.tgz
	https://registry.npmjs.org/mdast-util-find-and-replace/-/mdast-util-find-and-replace-3.0.2.tgz mdast-util-find-and-replace+mdast-util-find-and-replace-3.0.2.tgz
	https://registry.npmjs.org/mdast-util-from-markdown/-/mdast-util-from-markdown-2.0.3.tgz mdast-util-from-markdown+mdast-util-from-markdown-2.0.3.tgz
	https://registry.npmjs.org/mdast-util-gfm-autolink-literal/-/mdast-util-gfm-autolink-literal-2.0.1.tgz mdast-util-gfm-autolink-literal+mdast-util-gfm-autolink-literal-2.0.1.tgz
	https://registry.npmjs.org/mdast-util-gfm-footnote/-/mdast-util-gfm-footnote-2.1.0.tgz mdast-util-gfm-footnote+mdast-util-gfm-footnote-2.1.0.tgz
	https://registry.npmjs.org/mdast-util-gfm-strikethrough/-/mdast-util-gfm-strikethrough-2.0.0.tgz mdast-util-gfm-strikethrough+mdast-util-gfm-strikethrough-2.0.0.tgz
	https://registry.npmjs.org/mdast-util-gfm-table/-/mdast-util-gfm-table-2.0.0.tgz mdast-util-gfm-table+mdast-util-gfm-table-2.0.0.tgz
	https://registry.npmjs.org/mdast-util-gfm-task-list-item/-/mdast-util-gfm-task-list-item-2.0.0.tgz mdast-util-gfm-task-list-item+mdast-util-gfm-task-list-item-2.0.0.tgz
	https://registry.npmjs.org/mdast-util-gfm/-/mdast-util-gfm-3.1.0.tgz mdast-util-gfm+mdast-util-gfm-3.1.0.tgz
	https://registry.npmjs.org/mdast-util-math/-/mdast-util-math-3.0.0.tgz mdast-util-math+mdast-util-math-3.0.0.tgz
	https://registry.npmjs.org/mdast-util-mdx-expression/-/mdast-util-mdx-expression-2.0.1.tgz mdast-util-mdx-expression+mdast-util-mdx-expression-2.0.1.tgz
	https://registry.npmjs.org/mdast-util-mdx-jsx/-/mdast-util-mdx-jsx-3.2.0.tgz mdast-util-mdx-jsx+mdast-util-mdx-jsx-3.2.0.tgz
	https://registry.npmjs.org/mdast-util-mdxjs-esm/-/mdast-util-mdxjs-esm-2.0.1.tgz mdast-util-mdxjs-esm+mdast-util-mdxjs-esm-2.0.1.tgz
	https://registry.npmjs.org/mdast-util-phrasing/-/mdast-util-phrasing-4.1.0.tgz mdast-util-phrasing+mdast-util-phrasing-4.1.0.tgz
	https://registry.npmjs.org/mdast-util-to-hast/-/mdast-util-to-hast-13.2.1.tgz mdast-util-to-hast+mdast-util-to-hast-13.2.1.tgz
	https://registry.npmjs.org/mdast-util-to-markdown-cjk-friendly-gfm-strikethrough/-/mdast-util-to-markdown-cjk-friendly-gfm-strikethrough-1.0.0.tgz mdast-util-to-markdown-cjk-friendly-gfm-strikethrough+mdast-util-to-markdown-cjk-friendly-gfm-strikethrough-1.0.0.tgz
	https://registry.npmjs.org/mdast-util-to-markdown-cjk-friendly/-/mdast-util-to-markdown-cjk-friendly-1.0.0.tgz mdast-util-to-markdown-cjk-friendly+mdast-util-to-markdown-cjk-friendly-1.0.0.tgz
	https://registry.npmjs.org/mdast-util-to-markdown/-/mdast-util-to-markdown-2.1.2.tgz mdast-util-to-markdown+mdast-util-to-markdown-2.1.2.tgz
	https://registry.npmjs.org/mdast-util-to-string/-/mdast-util-to-string-4.0.0.tgz mdast-util-to-string+mdast-util-to-string-4.0.0.tgz
	https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz merge-stream+merge-stream-2.0.0.tgz
	https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz merge2+merge2-1.4.1.tgz
	https://registry.npmjs.org/mermaid/-/mermaid-11.16.1.tgz mermaid+mermaid-11.16.1.tgz
	https://registry.npmjs.org/micromark-core-commonmark/-/micromark-core-commonmark-2.0.3.tgz micromark-core-commonmark+micromark-core-commonmark-2.0.3.tgz
	https://registry.npmjs.org/micromark-extension-cjk-friendly-gfm-strikethrough/-/micromark-extension-cjk-friendly-gfm-strikethrough-2.0.1.tgz micromark-extension-cjk-friendly-gfm-strikethrough+micromark-extension-cjk-friendly-gfm-strikethrough-2.0.1.tgz
	https://registry.npmjs.org/micromark-extension-cjk-friendly-util/-/micromark-extension-cjk-friendly-util-3.0.1.tgz micromark-extension-cjk-friendly-util+micromark-extension-cjk-friendly-util-3.0.1.tgz
	https://registry.npmjs.org/micromark-extension-cjk-friendly/-/micromark-extension-cjk-friendly-2.0.1.tgz micromark-extension-cjk-friendly+micromark-extension-cjk-friendly-2.0.1.tgz
	https://registry.npmjs.org/micromark-extension-gfm-autolink-literal/-/micromark-extension-gfm-autolink-literal-2.1.0.tgz micromark-extension-gfm-autolink-literal+micromark-extension-gfm-autolink-literal-2.1.0.tgz
	https://registry.npmjs.org/micromark-extension-gfm-footnote/-/micromark-extension-gfm-footnote-2.1.0.tgz micromark-extension-gfm-footnote+micromark-extension-gfm-footnote-2.1.0.tgz
	https://registry.npmjs.org/micromark-extension-gfm-strikethrough/-/micromark-extension-gfm-strikethrough-2.1.0.tgz micromark-extension-gfm-strikethrough+micromark-extension-gfm-strikethrough-2.1.0.tgz
	https://registry.npmjs.org/micromark-extension-gfm-table/-/micromark-extension-gfm-table-2.1.1.tgz micromark-extension-gfm-table+micromark-extension-gfm-table-2.1.1.tgz
	https://registry.npmjs.org/micromark-extension-gfm-tagfilter/-/micromark-extension-gfm-tagfilter-2.0.0.tgz micromark-extension-gfm-tagfilter+micromark-extension-gfm-tagfilter-2.0.0.tgz
	https://registry.npmjs.org/micromark-extension-gfm-task-list-item/-/micromark-extension-gfm-task-list-item-2.1.0.tgz micromark-extension-gfm-task-list-item+micromark-extension-gfm-task-list-item-2.1.0.tgz
	https://registry.npmjs.org/micromark-extension-gfm/-/micromark-extension-gfm-3.0.0.tgz micromark-extension-gfm+micromark-extension-gfm-3.0.0.tgz
	https://registry.npmjs.org/micromark-extension-math/-/micromark-extension-math-3.1.0.tgz micromark-extension-math+micromark-extension-math-3.1.0.tgz
	https://registry.npmjs.org/micromark-factory-destination/-/micromark-factory-destination-2.0.1.tgz micromark-factory-destination+micromark-factory-destination-2.0.1.tgz
	https://registry.npmjs.org/micromark-factory-label/-/micromark-factory-label-2.0.1.tgz micromark-factory-label+micromark-factory-label-2.0.1.tgz
	https://registry.npmjs.org/micromark-factory-space/-/micromark-factory-space-2.0.1.tgz micromark-factory-space+micromark-factory-space-2.0.1.tgz
	https://registry.npmjs.org/micromark-factory-title/-/micromark-factory-title-2.0.1.tgz micromark-factory-title+micromark-factory-title-2.0.1.tgz
	https://registry.npmjs.org/micromark-factory-whitespace/-/micromark-factory-whitespace-2.0.1.tgz micromark-factory-whitespace+micromark-factory-whitespace-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-character/-/micromark-util-character-2.1.1.tgz micromark-util-character+micromark-util-character-2.1.1.tgz
	https://registry.npmjs.org/micromark-util-chunked/-/micromark-util-chunked-2.0.1.tgz micromark-util-chunked+micromark-util-chunked-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-classify-character/-/micromark-util-classify-character-2.0.1.tgz micromark-util-classify-character+micromark-util-classify-character-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-combine-extensions/-/micromark-util-combine-extensions-2.0.1.tgz micromark-util-combine-extensions+micromark-util-combine-extensions-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-decode-numeric-character-reference/-/micromark-util-decode-numeric-character-reference-2.0.2.tgz micromark-util-decode-numeric-character-reference+micromark-util-decode-numeric-character-reference-2.0.2.tgz
	https://registry.npmjs.org/micromark-util-decode-string/-/micromark-util-decode-string-2.0.1.tgz micromark-util-decode-string+micromark-util-decode-string-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-encode/-/micromark-util-encode-2.0.1.tgz micromark-util-encode+micromark-util-encode-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-html-tag-name/-/micromark-util-html-tag-name-2.0.1.tgz micromark-util-html-tag-name+micromark-util-html-tag-name-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-normalize-identifier/-/micromark-util-normalize-identifier-2.0.1.tgz micromark-util-normalize-identifier+micromark-util-normalize-identifier-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-resolve-all/-/micromark-util-resolve-all-2.0.1.tgz micromark-util-resolve-all+micromark-util-resolve-all-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-sanitize-uri/-/micromark-util-sanitize-uri-2.0.1.tgz micromark-util-sanitize-uri+micromark-util-sanitize-uri-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-subtokenize/-/micromark-util-subtokenize-2.1.0.tgz micromark-util-subtokenize+micromark-util-subtokenize-2.1.0.tgz
	https://registry.npmjs.org/micromark-util-symbol/-/micromark-util-symbol-2.0.1.tgz micromark-util-symbol+micromark-util-symbol-2.0.1.tgz
	https://registry.npmjs.org/micromark-util-types/-/micromark-util-types-2.0.2.tgz micromark-util-types+micromark-util-types-2.0.2.tgz
	https://registry.npmjs.org/micromark/-/micromark-4.0.2.tgz micromark+micromark-4.0.2.tgz
	https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz micromatch+micromatch-4.0.8.tgz
	https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz mimic-fn+mimic-fn-2.1.0.tgz
	https://registry.npmjs.org/min-indent/-/min-indent-1.0.1.tgz min-indent+min-indent-1.0.1.tgz
	https://registry.npmjs.org/minimatch/-/minimatch-10.2.5.tgz minimatch+minimatch-10.2.5.tgz
	https://registry.npmjs.org/minimatch/-/minimatch-3.1.5.tgz minimatch+minimatch-3.1.5.tgz
	https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz minimist+minimist-1.2.8.tgz
	https://registry.npmjs.org/minipass/-/minipass-7.1.3.tgz minipass+minipass-7.1.3.tgz
	https://registry.npmjs.org/mnemonist/-/mnemonist-0.39.8.tgz mnemonist+mnemonist-0.39.8.tgz
	https://registry.npmjs.org/motion-dom/-/motion-dom-12.40.0.tgz motion-dom+motion-dom-12.40.0.tgz
	https://registry.npmjs.org/motion-utils/-/motion-utils-12.39.0.tgz motion-utils+motion-utils-12.39.0.tgz
	https://registry.npmjs.org/ms/-/ms-2.1.3.tgz ms+ms-2.1.3.tgz
	https://registry.npmjs.org/msw/-/msw-2.12.14.tgz msw+msw-2.12.14.tgz
	https://registry.npmjs.org/multimath/-/multimath-2.0.0.tgz multimath+multimath-2.0.0.tgz
	https://registry.npmjs.org/mute-stream/-/mute-stream-3.0.0.tgz mute-stream+mute-stream-3.0.0.tgz
	https://registry.npmjs.org/nanoid/-/nanoid-3.3.18.tgz nanoid+nanoid-3.3.18.tgz
	https://registry.npmjs.org/nanoid/-/nanoid-5.1.16.tgz nanoid+nanoid-5.1.16.tgz
	https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz natural-compare+natural-compare-1.4.0.tgz
	https://registry.npmjs.org/node-addon-api/-/node-addon-api-7.1.1.tgz node-addon-api+node-addon-api-7.1.1.tgz
	https://registry.npmjs.org/node-releases/-/node-releases-2.0.36.tgz node-releases+node-releases-2.0.36.tgz
	https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz npm-run-path+npm-run-path-4.0.1.tgz
	https://registry.npmjs.org/nwsapi/-/nwsapi-2.2.24.tgz nwsapi+nwsapi-2.2.24.tgz
	https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz object-assign+object-assign-4.1.1.tgz
	https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.4.tgz object-inspect+object-inspect-1.13.4.tgz
	https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz object-keys+object-keys-1.1.1.tgz
	https://registry.npmjs.org/object.assign/-/object.assign-4.1.7.tgz object.assign+object.assign-4.1.7.tgz
	https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.8.tgz object.fromentries+object.fromentries-2.0.8.tgz
	https://registry.npmjs.org/object.values/-/object.values-1.2.1.tgz object.values+object.values-1.2.1.tgz
	https://registry.npmjs.org/obliterator/-/obliterator-2.0.5.tgz obliterator+obliterator-2.0.5.tgz
	https://registry.npmjs.org/obug/-/obug-2.1.4.tgz obug+obug-2.1.4.tgz
	https://registry.npmjs.org/once/-/once-1.4.0.tgz once+once-1.4.0.tgz
	https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz onetime+onetime-5.1.2.tgz
	https://registry.npmjs.org/oniguruma-parser/-/oniguruma-parser-0.12.2.tgz oniguruma-parser+oniguruma-parser-0.12.2.tgz
	https://registry.npmjs.org/oniguruma-to-es/-/oniguruma-to-es-4.3.6.tgz oniguruma-to-es+oniguruma-to-es-4.3.6.tgz
	https://registry.npmjs.org/open-color/-/open-color-1.9.1.tgz open-color+open-color-1.9.1.tgz
	https://registry.npmjs.org/open/-/open-10.2.0.tgz open+open-10.2.0.tgz
	https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz optionator+optionator-0.9.4.tgz
	https://registry.npmjs.org/outvariant/-/outvariant-1.4.3.tgz outvariant+outvariant-1.4.3.tgz
	https://registry.npmjs.org/own-keys/-/own-keys-1.0.1.tgz own-keys+own-keys-1.0.1.tgz
	https://registry.npmjs.org/oxc-parser/-/oxc-parser-0.127.0.tgz oxc-parser+oxc-parser-0.127.0.tgz
	https://registry.npmjs.org/oxc-parser/-/oxc-parser-0.148.0.tgz oxc-parser+oxc-parser-0.148.0.tgz
	https://registry.npmjs.org/oxc-resolver/-/oxc-resolver-11.21.2.tgz oxc-resolver+oxc-resolver-11.21.2.tgz
	https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz p-limit+p-limit-3.1.0.tgz
	https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz p-locate+p-locate-5.0.0.tgz
	https://registry.npmjs.org/package-manager-detector/-/package-manager-detector-1.6.0.tgz package-manager-detector+package-manager-detector-1.6.0.tgz
	https://registry.npmjs.org/pako/-/pako-2.0.3.tgz pako+pako-2.0.3.tgz
	https://registry.npmjs.org/pandemonium/-/pandemonium-2.4.1.tgz pandemonium+pandemonium-2.4.1.tgz
	https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz parent-module+parent-module-1.0.1.tgz
	https://registry.npmjs.org/parse-entities/-/parse-entities-4.0.2.tgz parse-entities+parse-entities-4.0.2.tgz
	https://registry.npmjs.org/parse5/-/parse5-7.3.0.tgz parse5+parse5-7.3.0.tgz
	https://registry.npmjs.org/path-data-parser/-/path-data-parser-0.1.0.tgz path-data-parser+path-data-parser-0.1.0.tgz
	https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz path-exists+path-exists-4.0.0.tgz
	https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz path-key+path-key-3.1.1.tgz
	https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz path-parse+path-parse-1.0.7.tgz
	https://registry.npmjs.org/path-scurry/-/path-scurry-2.0.2.tgz path-scurry+path-scurry-2.0.2.tgz
	https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-6.3.0.tgz path-to-regexp+path-to-regexp-6.3.0.tgz
	https://registry.npmjs.org/pathe/-/pathe-2.0.3.tgz pathe+pathe-2.0.3.tgz
	https://registry.npmjs.org/pathval/-/pathval-2.0.1.tgz pathval+pathval-2.0.1.tgz
	https://registry.npmjs.org/perfect-freehand/-/perfect-freehand-1.2.0.tgz perfect-freehand+perfect-freehand-1.2.0.tgz
	https://registry.npmjs.org/pica/-/pica-7.1.1.tgz pica+pica-7.1.1.tgz
	https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz picocolors+picocolors-1.1.1.tgz
	https://registry.npmjs.org/picomatch/-/picomatch-2.3.2.tgz picomatch+picomatch-2.3.2.tgz
	https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz picomatch+picomatch-4.0.4.tgz
	https://registry.npmjs.org/picomatch/-/picomatch-4.0.5.tgz picomatch+picomatch-4.0.5.tgz
	https://registry.npmjs.org/picomatch/-/picomatch-4.0.7.tgz picomatch+picomatch-4.0.7.tgz
	https://registry.npmjs.org/playwright-core/-/playwright-core-1.58.2.tgz playwright-core+playwright-core-1.58.2.tgz
	https://registry.npmjs.org/playwright/-/playwright-1.58.2.tgz playwright+playwright-1.58.2.tgz
	https://registry.npmjs.org/png-chunk-text/-/png-chunk-text-1.0.0.tgz png-chunk-text+png-chunk-text-1.0.0.tgz
	https://registry.npmjs.org/png-chunks-encode/-/png-chunks-encode-1.0.0.tgz png-chunks-encode+png-chunks-encode-1.0.0.tgz
	https://registry.npmjs.org/png-chunks-extract/-/png-chunks-extract-1.0.0.tgz png-chunks-extract+png-chunks-extract-1.0.0.tgz
	https://registry.npmjs.org/points-on-curve/-/points-on-curve-0.2.0.tgz points-on-curve+points-on-curve-0.2.0.tgz
	https://registry.npmjs.org/points-on-curve/-/points-on-curve-1.0.1.tgz points-on-curve+points-on-curve-1.0.1.tgz
	https://registry.npmjs.org/points-on-path/-/points-on-path-0.2.1.tgz points-on-path+points-on-path-0.2.1.tgz
	https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.1.0.tgz possible-typed-array-names+possible-typed-array-names-1.1.0.tgz
	https://registry.npmjs.org/postcss/-/postcss-8.5.25.tgz postcss+postcss-8.5.25.tgz
	https://registry.npmjs.org/preact-render-to-string/-/preact-render-to-string-6.6.5.tgz preact-render-to-string+preact-render-to-string-6.6.5.tgz
	https://registry.npmjs.org/preact/-/preact-11.0.0-beta.0.tgz preact+preact-11.0.0-beta.0.tgz
	https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz prelude-ls+prelude-ls-1.2.1.tgz
	https://registry.npmjs.org/pretty-format/-/pretty-format-27.5.1.tgz pretty-format+pretty-format-27.5.1.tgz
	https://registry.npmjs.org/promise/-/promise-7.3.1.tgz promise+promise-7.3.1.tgz
	https://registry.npmjs.org/property-information/-/property-information-7.2.0.tgz property-information+property-information-7.2.0.tgz
	https://registry.npmjs.org/pug-attrs/-/pug-attrs-3.0.0.tgz pug-attrs+pug-attrs-3.0.0.tgz
	https://registry.npmjs.org/pug-code-gen/-/pug-code-gen-3.0.4.tgz pug-code-gen+pug-code-gen-3.0.4.tgz
	https://registry.npmjs.org/pug-error/-/pug-error-2.1.0.tgz pug-error+pug-error-2.1.0.tgz
	https://registry.npmjs.org/pug-filters/-/pug-filters-4.0.0.tgz pug-filters+pug-filters-4.0.0.tgz
	https://registry.npmjs.org/pug-lexer/-/pug-lexer-5.0.1.tgz pug-lexer+pug-lexer-5.0.1.tgz
	https://registry.npmjs.org/pug-linker/-/pug-linker-4.0.0.tgz pug-linker+pug-linker-4.0.0.tgz
	https://registry.npmjs.org/pug-load/-/pug-load-3.0.0.tgz pug-load+pug-load-3.0.0.tgz
	https://registry.npmjs.org/pug-parser/-/pug-parser-6.0.0.tgz pug-parser+pug-parser-6.0.0.tgz
	https://registry.npmjs.org/pug-runtime/-/pug-runtime-3.0.1.tgz pug-runtime+pug-runtime-3.0.1.tgz
	https://registry.npmjs.org/pug-strip-comments/-/pug-strip-comments-2.0.0.tgz pug-strip-comments+pug-strip-comments-2.0.0.tgz
	https://registry.npmjs.org/pug-walk/-/pug-walk-2.0.0.tgz pug-walk+pug-walk-2.0.0.tgz
	https://registry.npmjs.org/pug/-/pug-3.0.4.tgz pug+pug-3.0.4.tgz
	https://registry.npmjs.org/pump/-/pump-3.0.4.tgz pump+pump-3.0.4.tgz
	https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz punycode+punycode-2.3.1.tgz
	https://registry.npmjs.org/pure-rand/-/pure-rand-8.4.0.tgz pure-rand+pure-rand-8.4.0.tgz
	https://registry.npmjs.org/pwacompat/-/pwacompat-2.0.17.tgz pwacompat+pwacompat-2.0.17.tgz
	https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz queue-microtask+queue-microtask-1.2.3.tgz
	https://registry.npmjs.org/react-docgen-typescript/-/react-docgen-typescript-2.4.0.tgz react-docgen-typescript+react-docgen-typescript-2.4.0.tgz
	https://registry.npmjs.org/react-docgen/-/react-docgen-8.0.3.tgz react-docgen+react-docgen-8.0.3.tgz
	https://registry.npmjs.org/react-dom/-/react-dom-18.3.1.tgz react-dom+react-dom-18.3.1.tgz
	https://registry.npmjs.org/react-i18next/-/react-i18next-17.0.11.tgz react-i18next+react-i18next-17.0.11.tgz
	https://registry.npmjs.org/react-is/-/react-is-17.0.2.tgz react-is+react-is-17.0.2.tgz
	https://registry.npmjs.org/react-markdown/-/react-markdown-10.1.0.tgz react-markdown+react-markdown-10.1.0.tgz
	https://registry.npmjs.org/react-redux/-/react-redux-9.3.0.tgz react-redux+react-redux-9.3.0.tgz
	https://registry.npmjs.org/react-remove-scroll-bar/-/react-remove-scroll-bar-2.3.8.tgz react-remove-scroll-bar+react-remove-scroll-bar-2.3.8.tgz
	https://registry.npmjs.org/react-remove-scroll/-/react-remove-scroll-2.7.2.tgz react-remove-scroll+react-remove-scroll-2.7.2.tgz
	https://registry.npmjs.org/react-router-dom/-/react-router-dom-7.18.2.tgz react-router-dom+react-router-dom-7.18.2.tgz
	https://registry.npmjs.org/react-router/-/react-router-7.18.2.tgz react-router+react-router-7.18.2.tgz
	https://registry.npmjs.org/react-style-singleton/-/react-style-singleton-2.2.3.tgz react-style-singleton+react-style-singleton-2.2.3.tgz
	https://registry.npmjs.org/react-virtuoso/-/react-virtuoso-4.18.3.tgz react-virtuoso+react-virtuoso-4.18.3.tgz
	https://registry.npmjs.org/react/-/react-18.3.1.tgz react+react-18.3.1.tgz
	https://registry.npmjs.org/readdirp/-/readdirp-5.1.1.tgz readdirp+readdirp-5.1.1.tgz
	https://registry.npmjs.org/recast/-/recast-0.23.21.tgz recast+recast-0.23.21.tgz
	https://registry.npmjs.org/redent/-/redent-3.0.0.tgz redent+redent-3.0.0.tgz
	https://registry.npmjs.org/redux-thunk/-/redux-thunk-3.1.0.tgz redux-thunk+redux-thunk-3.1.0.tgz
	https://registry.npmjs.org/redux/-/redux-5.0.1.tgz redux+redux-5.0.1.tgz
	https://registry.npmjs.org/reflect.getprototypeof/-/reflect.getprototypeof-1.0.10.tgz reflect.getprototypeof+reflect.getprototypeof-1.0.10.tgz
	https://registry.npmjs.org/regex-recursion/-/regex-recursion-6.0.2.tgz regex-recursion+regex-recursion-6.0.2.tgz
	https://registry.npmjs.org/regex-utilities/-/regex-utilities-2.3.0.tgz regex-utilities+regex-utilities-2.3.0.tgz
	https://registry.npmjs.org/regex/-/regex-6.1.0.tgz regex+regex-6.1.0.tgz
	https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.4.tgz regexp.prototype.flags+regexp.prototype.flags-1.5.4.tgz
	https://registry.npmjs.org/rehype-katex/-/rehype-katex-7.0.1.tgz rehype-katex+rehype-katex-7.0.1.tgz
	https://registry.npmjs.org/rehype-raw/-/rehype-raw-7.0.0.tgz rehype-raw+rehype-raw-7.0.0.tgz
	https://registry.npmjs.org/remark-cjk-friendly-gfm-strikethrough/-/remark-cjk-friendly-gfm-strikethrough-2.3.1.tgz remark-cjk-friendly-gfm-strikethrough+remark-cjk-friendly-gfm-strikethrough-2.3.1.tgz
	https://registry.npmjs.org/remark-cjk-friendly/-/remark-cjk-friendly-2.3.1.tgz remark-cjk-friendly+remark-cjk-friendly-2.3.1.tgz
	https://registry.npmjs.org/remark-gfm/-/remark-gfm-4.0.1.tgz remark-gfm+remark-gfm-4.0.1.tgz
	https://registry.npmjs.org/remark-math/-/remark-math-6.0.0.tgz remark-math+remark-math-6.0.0.tgz
	https://registry.npmjs.org/remark-parse/-/remark-parse-11.0.0.tgz remark-parse+remark-parse-11.0.0.tgz
	https://registry.npmjs.org/remark-rehype/-/remark-rehype-11.1.2.tgz remark-rehype+remark-rehype-11.1.2.tgz
	https://registry.npmjs.org/remark-stringify/-/remark-stringify-11.0.0.tgz remark-stringify+remark-stringify-11.0.0.tgz
	https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz repeat-string+repeat-string-1.6.1.tgz
	https://registry.npmjs.org/reprism/-/reprism-0.0.11.tgz reprism+reprism-0.0.11.tgz
	https://registry.npmjs.org/requestidlecallback/-/requestidlecallback-0.3.0.tgz requestidlecallback+requestidlecallback-0.3.0.tgz
	https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz require-directory+require-directory-2.1.1.tgz
	https://registry.npmjs.org/requireindex/-/requireindex-1.1.0.tgz requireindex+requireindex-1.1.0.tgz
	https://registry.npmjs.org/reselect/-/reselect-5.2.0.tgz reselect+reselect-5.2.0.tgz
	https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz resolve-from+resolve-from-4.0.0.tgz
	https://registry.npmjs.org/resolve/-/resolve-1.22.11.tgz resolve+resolve-1.22.11.tgz
	https://registry.npmjs.org/rettime/-/rettime-0.11.7.tgz rettime+rettime-0.11.7.tgz
	https://registry.npmjs.org/reusify/-/reusify-1.1.0.tgz reusify+reusify-1.1.0.tgz
	https://registry.npmjs.org/robust-predicates/-/robust-predicates-3.0.3.tgz robust-predicates+robust-predicates-3.0.3.tgz
	https://registry.npmjs.org/rolldown/-/rolldown-1.2.3.tgz rolldown+rolldown-1.2.3.tgz
	https://registry.npmjs.org/roughjs/-/roughjs-4.6.4.tgz roughjs+roughjs-4.6.4.tgz
	https://registry.npmjs.org/roughjs/-/roughjs-4.6.6.tgz roughjs+roughjs-4.6.6.tgz
	https://registry.npmjs.org/rrweb-cssom/-/rrweb-cssom-0.8.0.tgz rrweb-cssom+rrweb-cssom-0.8.0.tgz
	https://registry.npmjs.org/run-applescript/-/run-applescript-7.1.0.tgz run-applescript+run-applescript-7.1.0.tgz
	https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz run-parallel+run-parallel-1.2.0.tgz
	https://registry.npmjs.org/rw/-/rw-1.3.3.tgz rw+rw-1.3.3.tgz
	https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.4.tgz safe-array-concat+safe-array-concat-1.1.4.tgz
	https://registry.npmjs.org/safe-push-apply/-/safe-push-apply-1.0.0.tgz safe-push-apply+safe-push-apply-1.0.0.tgz
	https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.1.0.tgz safe-regex-test+safe-regex-test-1.1.0.tgz
	https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz safer-buffer+safer-buffer-2.1.2.tgz
	https://registry.npmjs.org/sass/-/sass-1.105.0.tgz sass+sass-1.105.0.tgz
	https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz saxes+saxes-6.0.0.tgz
	https://registry.npmjs.org/scheduler/-/scheduler-0.23.2.tgz scheduler+scheduler-0.23.2.tgz
	https://registry.npmjs.org/semver/-/semver-6.3.1.tgz semver+semver-6.3.1.tgz
	https://registry.npmjs.org/semver/-/semver-7.8.1.tgz semver+semver-7.8.1.tgz
	https://registry.npmjs.org/set-cookie-parser/-/set-cookie-parser-2.7.2.tgz set-cookie-parser+set-cookie-parser-2.7.2.tgz
	https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz set-function-length+set-function-length-1.2.2.tgz
	https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz set-function-name+set-function-name-2.0.2.tgz
	https://registry.npmjs.org/set-proto/-/set-proto-1.0.0.tgz set-proto+set-proto-1.0.0.tgz
	https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz shebang-command+shebang-command-2.0.0.tgz
	https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz shebang-regex+shebang-regex-3.0.0.tgz
	https://registry.npmjs.org/shiki/-/shiki-4.4.2.tgz shiki+shiki-4.4.2.tgz
	https://registry.npmjs.org/side-channel-list/-/side-channel-list-1.0.1.tgz side-channel-list+side-channel-list-1.0.1.tgz
	https://registry.npmjs.org/side-channel-map/-/side-channel-map-1.0.1.tgz side-channel-map+side-channel-map-1.0.1.tgz
	https://registry.npmjs.org/side-channel-weakmap/-/side-channel-weakmap-1.0.2.tgz side-channel-weakmap+side-channel-weakmap-1.0.2.tgz
	https://registry.npmjs.org/side-channel/-/side-channel-1.1.0.tgz side-channel+side-channel-1.1.0.tgz
	https://registry.npmjs.org/siginfo/-/siginfo-2.0.0.tgz siginfo+siginfo-2.0.0.tgz
	https://registry.npmjs.org/sigma/-/sigma-3.0.2.tgz sigma+sigma-3.0.2.tgz
	https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz signal-exit+signal-exit-3.0.7.tgz
	https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz signal-exit+signal-exit-4.1.0.tgz
	https://registry.npmjs.org/sliced/-/sliced-1.0.1.tgz sliced+sliced-1.0.1.tgz
	https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.2.tgz source-map-js+source-map-js-1.2.2.tgz
	https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz source-map+source-map-0.6.1.tgz
	https://registry.npmjs.org/space-separated-tokens/-/space-separated-tokens-2.0.2.tgz space-separated-tokens+space-separated-tokens-2.0.2.tgz
	https://registry.npmjs.org/spark-md5/-/spark-md5-3.0.2.tgz spark-md5+spark-md5-3.0.2.tgz
	https://registry.npmjs.org/stackback/-/stackback-0.0.2.tgz stackback+stackback-0.0.2.tgz
	https://registry.npmjs.org/statuses/-/statuses-2.0.2.tgz statuses+statuses-2.0.2.tgz
	https://registry.npmjs.org/std-env/-/std-env-4.2.0.tgz std-env+std-env-4.2.0.tgz
	https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.1.0.tgz stop-iteration-iterator+stop-iteration-iterator-1.1.0.tgz
	https://registry.npmjs.org/storybook/-/storybook-10.5.10.tgz storybook+storybook-10.5.10.tgz
	https://registry.npmjs.org/strict-event-emitter/-/strict-event-emitter-0.5.1.tgz strict-event-emitter+strict-event-emitter-0.5.1.tgz
	https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz string-width+string-width-4.2.3.tgz
	https://registry.npmjs.org/string.prototype.includes/-/string.prototype.includes-2.0.1.tgz string.prototype.includes+string.prototype.includes-2.0.1.tgz
	https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.10.tgz string.prototype.trim+string.prototype.trim-1.2.10.tgz
	https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.9.tgz string.prototype.trimend+string.prototype.trimend-1.0.9.tgz
	https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz string.prototype.trimstart+string.prototype.trimstart-1.0.8.tgz
	https://registry.npmjs.org/stringify-entities/-/stringify-entities-4.0.4.tgz stringify-entities+stringify-entities-4.0.4.tgz
	https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz strip-ansi+strip-ansi-6.0.1.tgz
	https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz strip-bom+strip-bom-3.0.0.tgz
	https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz strip-final-newline+strip-final-newline-2.0.0.tgz
	https://registry.npmjs.org/strip-indent/-/strip-indent-3.0.0.tgz strip-indent+strip-indent-3.0.0.tgz
	https://registry.npmjs.org/strip-indent/-/strip-indent-4.1.1.tgz strip-indent+strip-indent-4.1.1.tgz
	https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz strip-json-comments+strip-json-comments-3.1.1.tgz
	https://registry.npmjs.org/style-to-js/-/style-to-js-1.1.21.tgz style-to-js+style-to-js-1.1.21.tgz
	https://registry.npmjs.org/style-to-object/-/style-to-object-1.0.14.tgz style-to-object+style-to-object-1.0.14.tgz
	https://registry.npmjs.org/stylis/-/stylis-4.3.6.tgz stylis+stylis-4.3.6.tgz
	https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz supports-color+supports-color-7.2.0.tgz
	https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz supports-preserve-symlinks-flag+supports-preserve-symlinks-flag-1.0.0.tgz
	https://registry.npmjs.org/symbol-tree/-/symbol-tree-3.2.4.tgz symbol-tree+symbol-tree-3.2.4.tgz
	https://registry.npmjs.org/tabbable/-/tabbable-6.5.0.tgz tabbable+tabbable-6.5.0.tgz
	https://registry.npmjs.org/tagged-tag/-/tagged-tag-1.0.0.tgz tagged-tag+tagged-tag-1.0.0.tgz
	https://registry.npmjs.org/tailwind-merge/-/tailwind-merge-3.6.0.tgz tailwind-merge+tailwind-merge-3.6.0.tgz
	https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.3.3.tgz tailwindcss+tailwindcss-4.3.3.tgz
	https://registry.npmjs.org/tapable/-/tapable-2.3.3.tgz tapable+tapable-2.3.3.tgz
	https://registry.npmjs.org/tiny-invariant/-/tiny-invariant-1.3.3.tgz tiny-invariant+tiny-invariant-1.3.3.tgz
	https://registry.npmjs.org/tinybench/-/tinybench-2.9.0.tgz tinybench+tinybench-2.9.0.tgz
	https://registry.npmjs.org/tinyexec/-/tinyexec-1.0.4.tgz tinyexec+tinyexec-1.0.4.tgz
	https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.15.tgz tinyglobby+tinyglobby-0.2.15.tgz
	https://registry.npmjs.org/tinyrainbow/-/tinyrainbow-2.0.0.tgz tinyrainbow+tinyrainbow-2.0.0.tgz
	https://registry.npmjs.org/tinyrainbow/-/tinyrainbow-3.1.1.tgz tinyrainbow+tinyrainbow-3.1.1.tgz
	https://registry.npmjs.org/tinyspy/-/tinyspy-4.0.4.tgz tinyspy+tinyspy-4.0.4.tgz
	https://registry.npmjs.org/tldts-core/-/tldts-core-7.0.27.tgz tldts-core+tldts-core-7.0.27.tgz
	https://registry.npmjs.org/tldts/-/tldts-7.0.27.tgz tldts+tldts-7.0.27.tgz
	https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz to-regex-range+to-regex-range-5.0.1.tgz
	https://registry.npmjs.org/token-stream/-/token-stream-1.0.0.tgz token-stream+token-stream-1.0.0.tgz
	https://registry.npmjs.org/tough-cookie/-/tough-cookie-5.1.2.tgz tough-cookie+tough-cookie-5.1.2.tgz
	https://registry.npmjs.org/tough-cookie/-/tough-cookie-6.0.1.tgz tough-cookie+tough-cookie-6.0.1.tgz
	https://registry.npmjs.org/tr46/-/tr46-5.1.1.tgz tr46+tr46-5.1.1.tgz
	https://registry.npmjs.org/trim-lines/-/trim-lines-3.0.1.tgz trim-lines+trim-lines-3.0.1.tgz
	https://registry.npmjs.org/trough/-/trough-2.2.0.tgz trough+trough-2.2.0.tgz
	https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-2.5.0.tgz ts-api-utils+ts-api-utils-2.5.0.tgz
	https://registry.npmjs.org/ts-dedent/-/ts-dedent-2.2.0.tgz ts-dedent+ts-dedent-2.2.0.tgz
	https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-4.2.0.tgz tsconfig-paths+tsconfig-paths-4.2.0.tgz
	https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz tslib+tslib-2.8.1.tgz
	https://registry.npmjs.org/tunnel-rat/-/tunnel-rat-0.1.2.tgz tunnel-rat+tunnel-rat-0.1.2.tgz
	https://registry.npmjs.org/tw-animate-css/-/tw-animate-css-1.4.0.tgz tw-animate-css+tw-animate-css-1.4.0.tgz
	https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz type-check+type-check-0.4.0.tgz
	https://registry.npmjs.org/type-fest/-/type-fest-5.5.0.tgz type-fest+type-fest-5.5.0.tgz
	https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.3.tgz typed-array-buffer+typed-array-buffer-1.0.3.tgz
	https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.3.tgz typed-array-byte-length+typed-array-byte-length-1.0.3.tgz
	https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.4.tgz typed-array-byte-offset+typed-array-byte-offset-1.0.4.tgz
	https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.8.tgz typed-array-length+typed-array-length-1.0.8.tgz
	https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz typescript+typescript-5.9.3.tgz
	https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.1.0.tgz unbox-primitive+unbox-primitive-1.1.0.tgz
	https://registry.npmjs.org/undici-types/-/undici-types-7.18.2.tgz undici-types+undici-types-7.18.2.tgz
	https://registry.npmjs.org/unified/-/unified-11.0.5.tgz unified+unified-11.0.5.tgz
	https://registry.npmjs.org/unist-util-find-after/-/unist-util-find-after-5.0.0.tgz unist-util-find-after+unist-util-find-after-5.0.0.tgz
	https://registry.npmjs.org/unist-util-is/-/unist-util-is-6.0.1.tgz unist-util-is+unist-util-is-6.0.1.tgz
	https://registry.npmjs.org/unist-util-position/-/unist-util-position-5.0.0.tgz unist-util-position+unist-util-position-5.0.0.tgz
	https://registry.npmjs.org/unist-util-remove-position/-/unist-util-remove-position-5.0.0.tgz unist-util-remove-position+unist-util-remove-position-5.0.0.tgz
	https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-4.0.0.tgz unist-util-stringify-position+unist-util-stringify-position-4.0.0.tgz
	https://registry.npmjs.org/unist-util-visit-parents/-/unist-util-visit-parents-6.0.2.tgz unist-util-visit-parents+unist-util-visit-parents-6.0.2.tgz
	https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-5.1.0.tgz unist-util-visit+unist-util-visit-5.1.0.tgz
	https://registry.npmjs.org/universalify/-/universalify-2.0.1.tgz universalify+universalify-2.0.1.tgz
	https://registry.npmjs.org/unplugin/-/unplugin-2.3.11.tgz unplugin+unplugin-2.3.11.tgz
	https://registry.npmjs.org/until-async/-/until-async-3.0.2.tgz until-async+until-async-3.0.2.tgz
	https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.3.2.tgz update-browserslist-db+update-browserslist-db-1.3.2.tgz
	https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz uri-js+uri-js-4.4.1.tgz
	https://registry.npmjs.org/use-callback-ref/-/use-callback-ref-1.3.3.tgz use-callback-ref+use-callback-ref-1.3.3.tgz
	https://registry.npmjs.org/use-sidecar/-/use-sidecar-1.1.3.tgz use-sidecar+use-sidecar-1.1.3.tgz
	https://registry.npmjs.org/use-sync-external-store/-/use-sync-external-store-1.6.0.tgz use-sync-external-store+use-sync-external-store-1.6.0.tgz
	https://registry.npmjs.org/uuid/-/uuid-14.0.0.tgz uuid+uuid-14.0.0.tgz
	https://registry.npmjs.org/vfile-location/-/vfile-location-5.0.3.tgz vfile-location+vfile-location-5.0.3.tgz
	https://registry.npmjs.org/vfile-message/-/vfile-message-4.0.3.tgz vfile-message+vfile-message-4.0.3.tgz
	https://registry.npmjs.org/vfile/-/vfile-6.0.3.tgz vfile+vfile-6.0.3.tgz
	https://registry.npmjs.org/vis-data/-/vis-data-8.0.4.tgz vis-data+vis-data-8.0.4.tgz
	https://registry.npmjs.org/vis-network/-/vis-network-10.1.0.tgz vis-network+vis-network-10.1.0.tgz
	https://registry.npmjs.org/vis-util/-/vis-util-6.0.0.tgz vis-util+vis-util-6.0.0.tgz
	https://registry.npmjs.org/vite/-/vite-8.2.0.tgz vite+vite-8.2.0.tgz
	https://registry.npmjs.org/vitest/-/vitest-4.1.11.tgz vitest+vitest-4.1.11.tgz
	https://registry.npmjs.org/void-elements/-/void-elements-3.1.0.tgz void-elements+void-elements-3.1.0.tgz
	https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.2.0.tgz vscode-jsonrpc+vscode-jsonrpc-8.2.0.tgz
	https://registry.npmjs.org/w3c-xmlserializer/-/w3c-xmlserializer-5.0.0.tgz w3c-xmlserializer+w3c-xmlserializer-5.0.0.tgz
	https://registry.npmjs.org/web-namespaces/-/web-namespaces-2.0.1.tgz web-namespaces+web-namespaces-2.0.1.tgz
	https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-7.0.0.tgz webidl-conversions+webidl-conversions-7.0.0.tgz
	https://registry.npmjs.org/webpack-virtual-modules/-/webpack-virtual-modules-0.6.2.tgz webpack-virtual-modules+webpack-virtual-modules-0.6.2.tgz
	https://registry.npmjs.org/webworkify/-/webworkify-1.5.0.tgz webworkify+webworkify-1.5.0.tgz
	https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz whatwg-encoding+whatwg-encoding-3.1.1.tgz
	https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz whatwg-mimetype+whatwg-mimetype-3.0.0.tgz
	https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz whatwg-mimetype+whatwg-mimetype-4.0.0.tgz
	https://registry.npmjs.org/whatwg-url/-/whatwg-url-14.2.0.tgz whatwg-url+whatwg-url-14.2.0.tgz
	https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.1.1.tgz which-boxed-primitive+which-boxed-primitive-1.1.1.tgz
	https://registry.npmjs.org/which-builtin-type/-/which-builtin-type-1.2.1.tgz which-builtin-type+which-builtin-type-1.2.1.tgz
	https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz which-collection+which-collection-1.0.2.tgz
	https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.21.tgz which-typed-array+which-typed-array-1.1.21.tgz
	https://registry.npmjs.org/which/-/which-2.0.2.tgz which+which-2.0.2.tgz
	https://registry.npmjs.org/why-is-node-running/-/why-is-node-running-2.3.0.tgz why-is-node-running+why-is-node-running-2.3.0.tgz
	https://registry.npmjs.org/with/-/with-7.0.2.tgz with+with-7.0.2.tgz
	https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz word-wrap+word-wrap-1.2.5.tgz
	https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz wrap-ansi+wrap-ansi-7.0.0.tgz
	https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz wrappy+wrappy-1.0.2.tgz
	https://registry.npmjs.org/ws/-/ws-8.21.2.tgz ws+ws-8.21.2.tgz
	https://registry.npmjs.org/wsl-utils/-/wsl-utils-0.1.0.tgz wsl-utils+wsl-utils-0.1.0.tgz
	https://registry.npmjs.org/xml-name-validator/-/xml-name-validator-5.0.0.tgz xml-name-validator+xml-name-validator-5.0.0.tgz
	https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz xmlchars+xmlchars-2.2.0.tgz
	https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz y18n+y18n-5.0.8.tgz
	https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz yallist+yallist-3.1.1.tgz
	https://registry.npmjs.org/yaml/-/yaml-2.9.0.tgz yaml+yaml-2.9.0.tgz
	https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz yargs-parser+yargs-parser-21.1.1.tgz
	https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz yargs+yargs-17.7.2.tgz
	https://registry.npmjs.org/yjs/-/yjs-13.6.32.tgz yjs+yjs-13.6.32.tgz
	https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz yocto-queue+yocto-queue-0.1.0.tgz
	https://registry.npmjs.org/zod-validation-error/-/zod-validation-error-4.0.2.tgz zod-validation-error+zod-validation-error-4.0.2.tgz
	https://registry.npmjs.org/zod/-/zod-4.4.3.tgz zod+zod-4.4.3.tgz
	https://registry.npmjs.org/zustand/-/zustand-4.5.7.tgz zustand+zustand-4.5.7.tgz
	https://registry.npmjs.org/zwitch/-/zwitch-2.0.4.tgz zwitch+zwitch-2.0.4.tgz
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
KEYWORDS="amd64 arm64"

# Optional messaging channels / integrations mirror upstream's
# [options.extras_require]. Core install stays lean; each flag pulls the
# distributions that extra documents. See metadata.xml.
IUSE="otlp perf teams whatsapp feishu voice"

# net-libs/nodejs is pulled in by npm.eclass via NPM_NODE_MIN.

# Runtime dependencies, from setup.cfg install_requires. The platform-gated
# entries (truststore/darwin, tzdata/tzlocal/pywinpty/Windows,
# pysqlite3-binary/linux-x86_64) are omitted: they are no-ops or source-provided
# on a Linux Gentoo system. Every dependency below is provided either by
# ::gentoo (including dev-python/uv) or by this overlay (see dev-python/*).
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
	>=dev-python/uv-0.6.7
	dev-util/kiro-cli-bin
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

		# "Stage" the built dashboard into the Python package tree. Upstream's
		# `kiro_crew.frontend stage` is just a copy of website/dist ->
		# src/kiro_crew/static/dist (plus a best-effort git-rev fingerprint).
		# We do the copy directly rather than run `python -m kiro_crew.frontend`,
		# which would require importing the not-yet-installed kiro_crew package
		# (and all its runtime deps) during the compile phase.
		[[ -f website/dist/index.html ]] \
			|| die "dashboard build produced no website/dist/index.html"
		local static_dist="src/kiro_crew/static/dist"
		rm -rf "${static_dist}" || die
		mkdir -p "$(dirname "${static_dist}")" || die
		cp -r website/dist "${static_dist}" || die "staging dashboard failed"
	fi

	distutils-r1_src_compile
}

pkg_postinst() {
	elog "Start the gateway (dashboard + channels + task runner) with:"
	elog "  kirocrew gateway"
	elog
	elog "First-run setup and configuration live under ~/.kiro/ by default."
	elog "See https://github.com/kirodotdev/KiroCrew/blob/main/docs/guides/install.md"
	elog
	elog
	elog "KiroCrew drives the agent runtime 'kiro-cli' (pulled in via"
	elog "dev-util/kiro-cli-bin). Sign in once with 'kiro-cli' before first use;"
	elog "until it is authenticated, chat sessions fail to spawn."
}
