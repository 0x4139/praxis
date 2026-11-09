# Targets

What it is, and the fastest way in. Every entry carries its own detection signature, so this doubles as the classifier. Commands are in fenced blocks rather than table cells so they paste without mangling.

**Linux and macOS both.** Where they differ the alternative is given. A missing tool is not a blocker — use the fallback in the same entry.

## Identify First

Never choose a tool before knowing the format.

```sh
file -b TARGET; stat -f%z TARGET 2>/dev/null || stat -c%s TARGET; xxd -l 16 TARGET
```

Signatures worth recognising on sight:

| Bytes / marker | It is |
|---|---|
| `cf fa ed fe` / `ca fe ba be` | Mach-O (little-endian 64 / universal "fat") |
| `7f 45 4c 46` | ELF |
| `4d 5a` | PE (DOS header; PE offset at `0x3c`) |
| `50 4b 03 04` | Zip family — APK, AAB, IPA, MSIX, JAR, asar-adjacent |
| `c6 1f bc 03` | Hermes bytecode (React Native) |
| `f5 f5 dc dc` | Dart/Flutter snapshot — 32 hex chars at `+20` are the snapshot hash |
| `00 61 73 6d` | WASM |
| `53 51 4c 69 74 65` | SQLite |
| `__go_buildinfo` / `.go.buildinfo` | Go binary |
| `.dep-v0` / `__DATA,.dep-v0` | Rust built with cargo-auditable |
| `7f 45 4c 46` inside a larger blob | firmware image — go to Firmware |

No signature match, or a headerless blob, means the format must be asserted deliberately rather than guessed. Say so as an `Unknown` and ask.

## Workspace

Work on a copy, in a reusable directory, and reuse an extraction that already exists.

```sh
D="${TMPDIR:-/tmp}/re/$(basename TARGET)"; mkdir -p "$D"; cp -c TARGET "$D/" 2>/dev/null || cp TARGET "$D/"
```

`cp -c` is an instant copy-on-write clone on APFS and fails harmlessly elsewhere.

## Native — Mach-O

Thin a universal binary first or every tool reads the wrong slice.

```sh
lipo -info T; lipo -thin arm64 T -output T.arm64
otool -L T; otool -l T | rg -A3 'LC_(RPATH|BUILD_VERSION)'
nm -gU T; nm -u T; dyld_info -exports -imports T
codesign -d --entitlements :- T 2>&1 | head -40
otool -ov T | head -60
```

`nm -u` is the **capability map** — what a binary links against bounds what it can do, and reading it costs nothing. Swift names demangle with `swift-demangle --compact`; ObjC class and method layout comes from `otool -ov`.

## Native — ELF and PE

```sh
readelf -hlSW T; readelf -dW T | rg NEEDED
nm -D --defined-only T; nm -Du T
objdump -d -M intel --no-show-raw-insn T > "$D/dis.txt"
```

PE:

```sh
objdump -x T | head -60
python3 -I -c 'import pefile,sys; p=pefile.PE(sys.argv[1]); print(p.dump_info())' T | head -80
```

`pwn checksec T` summarises hardening on both. On Linux, `eu-readelf` and `llvm-objdump` are drop-in alternatives.

## Native — Reading The Code

Dump once, grep the dump. Never re-run the disassembler.

```sh
otool -tV T > "$D/dis.txt"        # macOS
llvm-objdump -d --no-show-raw-insn -C T > "$D/dis.txt"
```

One function body out of a large dump, by label-to-next-label windowing:

```sh
awk '/^_target_function:$/{p=1;next} p&&/^[_a-zA-Z].*:$/{exit} p' "$D/dis.txt" > "$D/fn.txt"
```

Read the **call sequence, not the instructions**. A name in a branch target often states the protocol outright — `getpeereid` names a peer-authentication mechanism, `CCHmac` names a signature scheme — and that is a faster read than following arithmetic.

To find who uses a string: get its address from the literal-pool comments in the dump, then scan upward for the enclosing label.

```sh
rg -n 'literal pool for: "NEEDLE' "$D/dis.txt"
```

Real pseudocode, only when the above is genuinely not enough:

```sh
r2 -qc 'aaa; pdc @ sym.target' T
```

Ghidra headless also works and costs minutes, not seconds — it is the last resort, not the first move. Write your own post-script; do not assume one ships.

## JavaScript — Electron and asar

```sh
npx -y @electron/asar extract app.asar "$D/app"
jq -r .main "$D/app/package.json"
npx -y @electron/fuses read --app /path/to/App.app
```

Three traps, all of which have cost people real time:

- Search extracted trees with `rg -uu`. Plain `rg` skips hidden and ignored files, and bundlers hide code in `.webpack/` and `.vite/` — exactly there.
- The `.unpacked/` sibling directory holds native `.node` addons. Missing it means missing the native surface entirely.
- App-specific IPC wrappers hide channel names from an obvious grep. Sweep for channel-shaped literals as a second pass:

```sh
rg -uu -o '"[a-z]+:[a-z0-9:_-]+"' "$D/app" | sort -u | head -50
```

Traverse **boundary-inward**: native call → its caller class → the `ipcMain` registration → the renderer or preload. The architecture is fixed, so the path is known rather than explored.

## JavaScript — Bundles, Hermes, WASM

A minified bundle: look for `sourceMappingURL` and recover real source from `sourcesContent` before reading a single line of minified output. Failing that, pretty-print once to a file and read by line range.

Hermes (`index.android.bundle`, magic `c6 1f bc 03`): `hermes-dec` or an equivalent decompiler. **`.jsc` bytenode cannot be decompiled** — go to strings and runtime hooks instead and record the limitation.

WASM: `wasm-objdump -x`, `wasm2wat`, `wasm-decompile` from WABT.

## Managed Runtimes

- **.NET** — `ilspycmd -p -o "$D/src" T.dll`, then `rg DllImport` for the native boundary. **NativeAOT and IL2CPP are native despite the lineage** — use the native sections.
- **Android** — `jadx -d "$D/src" --show-bad-code T.apk`; manifest only via `apktool d --no-src`. Check `lib/*/` first: `libflutter.so` means Flutter, `libhermes.so` means React Native, and either changes the whole approach.
- **Java** — `unzip -l`, then `cfr` or `procyon` on the classes that matter.
- **Python** — `.pyc` decompiles with `decompyle3` or `pycdc` depending on version; PyInstaller unpacks with `pyinstxtractor`.

## Language Metadata — Nearly Free Answers

```sh
go version -m T
cargo audit bin T
```

`go version -m` alone often answers the entire question — module path, dependency versions, build flags. **Go symbols survive stripping**: `go tool nm T | rg main.`. Rust without cargo-auditable still leaks crate versions through path strings, and the compiler version through a `/rustc/<40 hex>` path.

## Data Files

- **SQLite** — copy the database **and its `-wal` file**; the WAL holds uncommitted state and reading the db alone gives you stale data. Then `sqlite3 'file:copy?mode=ro' '.schema'`.
- **plist / Info.plist** — `plutil -p` for bundle id, URL schemes, privacy strings, entitlement hints.
- **Model weights** — GGUF and safetensors carry readable metadata headers; read those before anything else.

## Captures and Protocols

```sh
tshark -r C.pcap -q -z conv,tcp
tshark -r C.pcap -T fields -e dns.qry.name -e tls.handshake.extensions_server_name | sort -u
```

HAR and qlog are JSON — `jq` over them. For a live surface, a proxy capture beats guessing: record a session, then grow a description of the API from the captures rather than asserting one. Where the format is a binary protocol, a declarative struct definition (Kaitai and similar) is worth writing because it is **executable and falsifiable** — it either parses the capture or it does not.

A protocol claim has the same epistemic rules as everything else: fields you watched vary are `Observed`, fields you reasoned about are `Inferred`, and a field you never saw populated is `Unknown`, not optional.

## Firmware

```sh
binwalk -e F || unblob -e F
```

Then **route every extracted artifact through this file again**. Firmware is a container of the things above, and the recursion is the method.

## Live Targets

Only with the user's explicit agreement, and only against something they own.

- **macOS** — `lldb -p PID`, `fs_usage`, `log stream --predicate`, and `dtrace` where it is permitted.
- **Linux** — `strace -f -e trace=network`, `ltrace`, `/proc/PID/maps`, `bpftrace`.
- **Electron** — `--inspect` works only if the `RunAsNode` and inspect fuses allow it; check the fuses before concluding the port is closed.
- **Android** — `adb logcat`, and Frida where instrumentation is appropriate.
- **Browser / web** — a request listener via a driver, or Chrome with a remote debugging port.

A runtime observation is the only thing that upgrades a static reading to an actual behavioral claim. Record what you ran alongside what you saw.

## Comparing Two Versions

**Diff the inventories before diffing any code.** Exports, imports, module lists, build metadata, manifests. The inventory diff is cheap, it is often the whole answer, and it tells you where a code diff would be worth the cost.

Equal inventories are not equal behavior. Say exactly what you compared.
