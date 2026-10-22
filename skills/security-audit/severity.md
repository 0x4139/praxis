# Severity

Severity answers two questions, both read off the code: **how hard is this to exploit**, and **how bad is it if someone does**. It does not encode how sure anyone is — that is `confidence`, and keeping the two apart is what makes either one readable.

## The Two Axes

**Exploitability.** Who can trigger this, from where, and what stands in the way: network reach or local only, a defense to defeat, a non-default configuration, privileges already required, a victim who must act. Rate the access path this code actually binds. Never adjust for a deployment that cannot be seen.

**Impact.** The reasonable worst case for confidentiality, integrity, and availability on the system running this code — and beyond its trust boundary only where the code demonstrably carries it there, as with SSRF into internal services or a credential that opens other systems.

**Attacker position is determined by barrier, not by transport.** Trace back to the first untrusted principal and rate from there. Whether the call arrived over HTTP, gRPC, a queue, or an in-process boundary tells you nothing on its own — a local IPC endpoint reachable by any unprivileged process is remote-equivalent, and an HTTP route behind mutual TLS and an allowlist is not.

## Tiers

| Tier | Standard |
|------|----------|
| **CRITICAL** | Severe impact with nothing in the way: remote, unauthenticated, no precondition, no victim participation. Unauthenticated remote code execution, full authentication bypass, wholesale data exposure. |
| **HIGH** | Severe impact on at least one property by a realistic path, with exactly one real hurdle — privileges, victim interaction, a deployment precondition, or a defense to defeat. |
| **MEDIUM** | A real vulnerability with bounded impact, or severe impact behind several restrictive conditions. Information disclosure and user enumeration live here. |
| **LOW** | Limited impact and demanding exploitation — local or physical access, high privileges already held, or one property partly affected. |

**Between two tiers, take the lower.** A false CRITICAL costs a reader more than a conservative rating costs the finding.

## Caps

Hard ceilings. They apply after the tier is chosen and they only ever lower it.

- **Severity may not exceed impact.** A finding whose worst case is minor cannot be HIGH because it is trivially triggered. Easy to exploit and harmless is a LOW.
- **Blast radius of a single user caps at MEDIUM.** A user harming only their own account or data is bounded by construction.
- **"This code is fragile" is impact 1.** A finding whose whole content is missing defense-in-depth is a LOW, or a hardening note and not a finding at all.
- **Required privileges, deliberate victim participation, or a non-default condition each rule out CRITICAL.**
- **Impact limited on every property rules out HIGH.**
- **Test, example, and debug paths rarely have the reach claimed.** Re-examine before rating one above MEDIUM.
- **Probabilistic exploitation caps at HIGH.** Anything depending on a model being successfully manipulated defaults to MEDIUM or LOW; the cap lifts only where retries are unlimited and free.
- **CRITICAL is for zero-click, unprivileged code execution or its equal.** If a human has to be convinced of something first, it is not CRITICAL.

Where a cap fires, say so in the finding's rationale. A capped severity with its reason stated is informative; a quietly downgraded one looks like indecision.

## Confidence

`HIGH`, `MEDIUM`, `LOW` — and it is the panel that sets the ceiling, not the author. Only a unanimous panel earns HIGH; a split panel that still confirms yields MEDIUM at best. A finding the panel keeps on a bare majority, with a dissent on reachability, is exactly what MEDIUM confidence is for.

Deduplication keeps the maximum severity across reporters, so there is nothing to gain by inflating to be heard.

## Evidence Tier

Every finding carries how it is known. This is not severity and does not modify it; it tells the reader what kind of claim they are being handed.

| Tier | Meaning |
|------|---------|
| `statically-confirmed` | The full path was read in the code. The default, and a complete answer. |
| `reproduced` | A PoC ran against the untouched tree and the observed result is recorded. Only `prove.md` may assign this. |
| `failed-to-reproduce` | A PoC was attempted and did not demonstrate the claim. The finding is withdrawn or downgraded, never quietly kept. |
| `not-attempted` | Proof was possible but not run, usually by budget. Say so rather than implying it was unnecessary. |

Nothing in a read-only audit executes the repository's code. No test was run, no exploit fired, no PoC validated. Say that plainly in the report rather than letting a confident tone imply a demonstration.
