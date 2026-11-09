# Route

Identify before choosing a tool. Picking an instrument for a format you guessed is how a run spends twenty minutes disassembling a file that had a readable manifest.

## 1. Identify by Signature

Run the identity probe from `targets.md` — `file`, size, and the first sixteen bytes. Match against the signature table there.

What matters is that identification is **itself a finding**, and a fallible one. A container can hold something other than what its extension claims; a `.so` inside an APK can be a Flutter snapshot; firmware is a box of other formats. Record what you concluded and on what basis:

> **Observed.** `file` reports Mach-O arm64; magic `cf fa ed fe`; `app.asar` present under `Contents/Resources`.
> **Inferred (high).** An Electron application. The asar plus an Electron Framework in `Frameworks/` is conclusive.

No signature match means the format is asserted rather than detected. Say so as an `Unknown` and ask the user rather than picking a parser and hoping.

## 2. Thin, Unwrap, Recurse

Some targets need a step before any analysis is meaningful:

- A universal Mach-O must be thinned to one architecture or every subsequent tool reads the wrong slice.
- An archive, bundle or package must be extracted before its contents can be routed.
- **Firmware recurses.** Carve it, then route every extracted artifact through `targets.md` again. The recursion is the method, not an edge case.

Each unwrap can change the answer to "what is this", so re-identify after unwrapping rather than assuming the container's identity applies to its contents.

## 3. Prepare the Workspace

Copy, extract into the deterministic directory from `targets.md`, and **reuse an extraction that already exists**. The same artifact gets analyzed repeatedly across turns and sessions, and extraction is among the slowest steps here.

Everything written during the run goes in that directory: the disassembly dump, the extracted tree, intermediate greps. Nothing is written into the user's own tree.

## 4. Check Your Instruments

Before planning depth, find out what is actually available — decompilers, extractors, the optional MCP from `instruments.md`. A plan that assumes a decompiler you do not have wastes the stage that depends on it.

Where an instrument is missing, note the fallback you will use instead. That note becomes the blocker on any `Unknown` it causes.

## Exit

Format identified with its evidence, workspace prepared and reusable, instruments known, and the path from `targets.md` selected. Hand to `inventory.md` — and expect it to answer more of the fact list than feels plausible.
