# Evidence

The contract every claim in a findings doc must satisfy. Load this in `record.md` and again in `close.md`, where it is enforced rather than recommended.

## Three Labels

Every claim carries exactly one.

**`Observed`** — you saw it, and you can point at where. Requires a locator (below). This is the strongest claim available and it is still not a claim about runtime behavior unless you watched it run.

**`Inferred`** — you concluded it from something you observed. Requires the reasoning in one line, and **a competing explanation where one exists**. An inference with no alternative considered is usually the first story that occurred to you.

**`Unknown`** — you could not establish it. Requires what you would need in order to resolve it: a tool you lack, a decompiler that failed, a path you could not reach, a runtime you could not observe. An `Unknown` with a stated blocker is useful to the next person; a silently missing answer is not.

Nothing is unlabelled. A sentence in a findings doc with no label is a defect, and `close.md` rejects the document for it.

## Locators

A locator is specific enough that someone else lands exactly where you did.

| Target | Locator form |
|--------|--------------|
| File in an extracted tree | `path/to/file:line` or `path:byte-offset` |
| Native code | the address plus **how the name was obtained** — `0x1000a2f4 (sym: _validate_token)`, or `0x1000a2f4 (unnamed)` |
| A string | the string itself, quoted, plus the file it lives in |
| Symbol table | the symbol, and which table — export, import, dynamic |
| Manifest or metadata | the file and the key path — `Info.plist: CFBundleURLTypes[0]` |
| Archive member | the archive and the member path |
| Capture | `capture.pcap: frame 418, tls.handshake.extensions_server_name` |
| HTTP surface | method, path, and where you saw it — a capture, a bundle string, a response |
| Runtime observation | what you ran, what you watched, and what appeared |

**Never cite a name you generated.** If you or a tool invented a label for an unnamed function, the locator is the address and the name is an inference. A symbol you named three functions ago is the most dangerous input in the loop, because it reads exactly like a fact.

## Absence

The rule both source projects converged on, and the one that matters most:

**Never turn absence from incomplete evidence into behavioral absence or equivalence.**

Three specific forms this takes:

- **"It does not do X"** — unless you enumerated the complete surface where X would appear, this is `Unknown`. Searches skip hidden and ignored files; bundlers hide code in exactly those directories; wrappers rename the thing you grepped for.
- **"The two versions are the same"** — equal inventories mean equal inventories. Say precisely what you compared: *exports identical, module list identical, code not compared*.
- **"The feature was removed"** — you found it absent from the places you looked. Name those places.

Coverage is what makes a negative statement meaningful. Without a record of what you examined, there is no way to tell a clean subsystem from an unread one.

## Static Is Not Runtime

A third tier, implicit in the labels and worth stating on its own because it is the most common overreach in reverse engineering.

Reading a code path that *can* send a token is not an observation that it *does*. Say which you have:

- **"A path exists from X to Y"** — static, `Observed` in the code, with the path's locators.
- **"X is sent to Y"** — requires having watched it happen, with what you ran and what you saw.

Where only the static reading exists, phrase the claim as the static reading. `trace.md` says how to escalate to an actual observation when the target can be run.

## Confidence on Inference

`Inferred` claims carry `high` / `medium` / `low`, and the word is an argument, not a feeling:

- **high** — one explanation fits the evidence and alternatives are ruled out by something you cite.
- **medium** — one explanation fits best, others remain open.
- **low** — consistent with the evidence, and you are saying so because it is a useful lead rather than because you believe it.

Probabilistic sources cap confidence. A function whose purpose rests on a decompiler's guessed signature, a name a model produced, or a string that merely sits nearby is `medium` at best.

## Calibration

Not this:

> The app appears to validate the licence key server-side, probably by calling the endpoint found in the strings. It seems to use some kind of hashing.

Every claim unlabelled, three hedges, and the "some kind of hashing" is doing no work at all.

This:

> **Observed.** The binary imports `CCHmac` and `SecKeyVerifySignature` — import table, `otool -L`/`nm -u` output.
> **Observed.** The string `https://api.example.com/v2/license/verify` appears at `MacOS/App:0x1f8a20`.
> **Inferred (medium).** Licence verification happens server-side against that endpoint. The string sits in the same function that calls `CCHmac` (`0x10004a10`, unnamed), so the HMAC is most likely a request signature. Competing explanation: the HMAC covers a locally cached licence blob and the endpoint is unrelated telemetry.
> **Unknown.** Whether verification is enforced when the request fails. The offline path is in a function the decompiler returned empty, and the app was not run.

The second one is shorter, says more, and a reader can act on every line of it.
