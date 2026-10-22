# Prove

Opt-in, and the only stage permitted to execute anything. Everything before it is reading; this is where a claim becomes an observation.

Run it on request, on specific findings — normally the CRITICAL and HIGH ones. Never run it unasked, and never let the *absence* of a proof lower a finding that was statically confirmed. A read-only confirmation is a complete answer; proof is a stronger one.

## The Failure Mode This Stage Exists To Avoid

An agent asked to prove a vulnerability, and able to edit files, will edit the source until its exploit works and then report the bug it just created. This is the documented failure of every harness that has tried execution, and it is not rare.

So the rule is absolute: **the proof runs against an untouched tree.** Hash the working copy before the attempt and after it. If the hash changed, the proof is void and the finding returns to `statically-confirmed` — the diff is not evidence of a bug, it is evidence that the prover wrote one.

A PoC may add files *outside* the source tree — a test, a script, a payload. It may not modify a single line of the code under audit.

## Before Running Anything

Three preconditions, all required.

1. **The user has asked for proof on named findings.** Not implied by asking for an audit.
2. **There is somewhere safe to run.** Work in a disposable copy, never the user's checkout. No network egress, no real credentials, no shared database, nothing pointed at a deployed environment. An ordinary session has no isolation layer — opening it in this repository was the trust decision, and there is no sandbox beyond what is arranged here. Say that plainly rather than implying a containment that does not exist.
3. **A separate agent.** Not the hunter that raised the finding, not a voter that judged it. Proof is a third opinion or it is a hunter grading its own homework with better tools.

If a precondition fails, say which one and stop. A finding without proof is in good standing.

## The Three Arms

A proof is only a proof if it could have failed.

**Arm 1 — the demonstration.** The PoC runs against the untouched tree and the claimed effect is observed. Record the exact command, the exact input, and the **factual** result — what was returned, written, or executed. Not an interpretation of it.

**Arm 2 — the negative control.** The same PoC with benign input, which must *not* produce the effect. This is what separates a real demonstration from a tautology. "The `exec` call executed something, therefore remote code execution" proves nothing: the negative control is what shows the attacker's input was the cause.

**Arm 3 — the integrity check.** The tree hash matches its pre-run value, and the PoC touched no file under audit.

All three arms pass, or the result is `failed-to-reproduce`.

## What Counts, and What Does Not

- **An observed result, recorded verbatim.** Never describe output that was not seen. A fabricated result is worse than no proof, because it is indistinguishable from a real one until someone else tries.
- **Do not strengthen what was observed.** A crash is a crash, not code execution. A slow response is not a denial of service. An action by a principal who was already entitled to take it is not a privilege escalation. The severity reflects what the arms showed, not what it suggests.
- **A failed proof downgrades or withdraws — never silently nothing.** Mark `failed-to-reproduce`, record what was attempted and where it stopped, and reconsider the finding: often the proof fails because a guard exists that the panel also missed, in which case the finding was a false positive that got one stage further than it should have.
- **A proof that could not be attempted** is `not-attempted` with the reason. Budget, no safe environment, needs a credential that does not exist here. That is an honest state and it is reported as one.

## Recording

Append to the finding file rather than rewriting it, so the static reasoning and the observation stay distinguishable.

```md
## Proof

**Evidence tier.** reproduced
**Command.** `python poc/f3_sqli.py --target http://127.0.0.1:8080`
**Input.** `name=' OR '1'='1`
**Observed.** HTTP 200 with 1,412 user rows including `password_hash`, where the benign
control `name=alice` returned 1 row.
**Negative control.** Passed — benign input returned a single row.
**Tree integrity.** Pre-run and post-run hashes match; PoC added `poc/f3_sqli.py` only.
**Environment.** Disposable copy, loopback only, seeded fixture data, no network egress.
```

## Exit

Each named finding carries an evidence tier and, where proof ran, its three arms. Tell the
user which findings were proved, which failed to reproduce — **and that a failure to reproduce
is a reason to re-examine the finding, not to re-run the proof harder.** Then hand back to
`report.md`, which reads the evidence tier off each finding.
