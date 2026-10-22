# Attack Classes

The catalog a hunter is dispatched against. One hunter per class keeps a single lens in a single context, which is why lensed hunting finds things a generalist sweep does not: a generalist stops at the first interesting thing, a lens keeps asking its one question.

Each class names what it covers, the moves that find it, and the rules that refute it. A hunter is handed its class's section in full — never the class name alone, which produces a hunter that improvises a checklist.

## 1. Injection and Input Handling

**Covers.** SQL, command, and code injection. XSS, including a `javascript:` URL where attacker-controlled data starts a value reaching `location`, `href`, `window.open`, an `iframe` src, or a form action with nothing holding it to `http(s)` or a same-site path. XXE, deserialization, template injection, path traversal, header and CRLF injection, SSTI, argument injection into a subprocess.

**Moves.** Start at the sink, not the source — enumerate every call that executes, queries, renders, deserializes, or opens, then walk backwards. String concatenation and format interpolation reaching any of those is the shape to find. Check the *encoding* boundary: a value escaped for HTML and then placed in a URL attribute, or escaped once and decoded twice, is escaped for the wrong grammar.

**Refuted by.** A parameterized query, a prepared statement, a typed builder that cannot emit the attacker's grammar, an allowlist the value must match first, or framework escaping that genuinely covers the context — read it, do not assume it.

## 2. Authentication and Authorization

**Covers.** Auth bypass, missing or incorrect authorization checks, IDOR, privilege escalation, CSRF, SSRF with host or protocol control, open redirect, session fixation and lifetime, token validation, tenant isolation, and races in access decisions.

**Moves.** Enumerate every route, handler, job, and subscriber, then ask of each one what proves the caller may do this. The sink for a missing check is **the route or handler line that lacks it**, not the operation it exposes — a flaw inside that operation is a separate finding on its own line. Compare siblings: a resource with six endpoints where five check ownership and one does not is the strongest shape in this class. For multi-tenant code, find where the tenant id comes from and whether the caller can choose it.

**Refuted by.** Middleware that cannot be bypassed on any route reaching the sink, a check one frame up, a type that cannot carry an unauthorized subject, or a framework default that denies by configuration. Check every route to the sink, not only the one the reporter walked.

## 3. Cryptography and Secrets

**Covers.** Weak or misused primitives, ECB, static or reused IVs and nonces, key reuse across purposes, weak randomness where unpredictability matters, missing or skipped signature and certificate verification, timing-sensitive comparison of secrets, password hashing, hardcoded credentials, and credential exposure through logs, errors, or responses.

**Moves.** Grep the primitives and the randomness sources, then read each call site for what the output guards. Separate "weak algorithm" from "weak use" — HMAC-SHA256 with a key read from a repo file is a secrets finding, not a crypto one. For every comparison of a secret, check whether it short-circuits.

**Refuted by.** A CSPRNG where unpredictability is required, a constant-time comparison, a verified chain, or a value that turns out to be a test fixture, a public key, or a placeholder. Report secrets by file and line; never put the value in the finding.

## 4. Memory and Unsafe Operations

**Covers.** Buffer overflows, out-of-bounds reads and writes, use-after-free, double free, integer overflow and truncation feeding an allocation or an index, type confusion, unchecked `unsafe` blocks, and FFI boundaries where lifetime or ownership is asserted rather than enforced.

**Prune this class** when the component's language is memory-managed, and **say in Coverage that it was pruned and why**. A pruned lens disclosed is accurate scope; a pruned lens unmentioned turns "no findings" into a false claim.

**Moves.** Follow every length, size, index, and offset that crosses a boundary and ask what bounds it. At an FFI edge, read both sides. Arithmetic on a size before an allocation is the shape to find.

**Refuted by.** A bound checked on the path taken, a type that carries its length, or a safe wrapper whose implementation was read.

## 5. Logic and State

**Covers.** Business-logic flaws, feature abuse, broken state machines, missing idempotency where it is load-bearing, replay, TOCTOU on shared state, balance and quota checks without a lock, negative or overflowing quantities, workflow steps reachable out of order, and discount, refund, or retry paths that compose into something unintended.

The class other audits miss, because it has no grep signature. It is found by understanding what the system is *for* and then asking what a dishonest user would do with it.

**Moves.** Take each invariant the model stage recorded and ask which code enforces it and on which paths. Check every mutation of shared state for the lock or transaction that makes it atomic. Ask of each multi-step flow whether a step can be skipped, repeated, or run twice concurrently.

**Refuted by.** A database constraint, a transaction with the right isolation, a row lock on the path taken, or a state check that cannot be stepped around. An invariant enforced in the UI and not the server is not enforced.

## 6. Agentic and AI Systems

**Covers.** The class most codebases now have and most audits do not look at. Prompt injection crossing a privilege boundary, tool misuse, excessive agency, insecure agent-to-agent trust, memory and context poisoning, model-output handling, and the MCP transport surface.

**Moves — the specific checks worth running.**

- **Tool definitions.** Does each tool's description match its implementation? A description narrower than the code is a finding in itself: the model, the reviewer, and the approval dialog all believe the description. Check every parameter for server-side validation rather than trust in the schema.
- **Dynamic dispatch.** Is any function, method, tool, or module name taken from model output and dispatched on? That is code execution with the model as the attacker's proxy.
- **Prompt construction.** Find every template expansion and ask what can reach it — `{{...}}` and `${...}` interpolations pulling in secrets, system instructions, or other users' data are greppable bugs.
- **Approval binding.** Where a human approves an action, does the approval carry the exact parameters that will execute, and does it expire? An approval for a described action that executes a later-mutated one is approve-one-thing-execute-another.
- **MCP transports.** On HTTP, are `Origin` and `Host` validated? An unvalidated local MCP endpoint is reachable from any page the user visits by DNS rebinding. Check authentication, bound interface, and whether a local-only assumption is enforced or merely intended.
- **Memory and retrieval as sinks.** Treat a *write* to agent memory, a vector store, a config file, or a policy file as a dangerous operation. Content written by one user and read into another's context is a cross-user injection path.
- **Secrets in context.** What enters the window — environment, files, tool results — and can any of it be exfiltrated by an injected instruction through a tool that makes a network request?
- **Egress.** Can the agent reach `169.254.169.254` or other link-local metadata, internal services, or arbitrary hosts? Where is the allowlist?
- **Sandboxing and the loop.** What bounds iteration, spend, and tool-call depth? Is a failure state recoverable, or does it retry forever with escalating privileges?
- **Inter-agent trust.** Is another agent's output treated as data or as instructions? A subagent report parsed as commands is the same bug as parsing user input as commands.

**Refuted by.** A boundary where model output is treated strictly as data, an allowlist of tools and hosts enforced server-side, parameter validation that does not consult the model, or an approval bound to a hash of the exact call. Remember the probabilistic cap in `severity.md`.

## 7. Chained and Trust-Boundary

**Covers.** The finding no single-lens hunter reports, because neither half is a vulnerability alone: an information leak that supplies the identifier for an IDOR, a low-privilege write that lands in a path a higher-privilege process reads, a sanitizer applied before a transformation that re-introduces the grammar.

**Moves.** Take the trust boundaries the model stage recorded and walk data *across* each one, asking what revalidates on the far side. Look for parallel paths to the same effect where only one is guarded. Look for an assumption marked `nothing found` in the model stage and ask who could violate it.

**Refuted by.** Revalidation at the boundary, or a link in the chain that turns out not to compose — state each link with its file and line, since a chain is only as real as its weakest cited step.

## 8. Wildcard

Reserved, deliberately. One hunter dispatched with no class and one instruction: find what the catalog would not have asked about. Harnesses that keep a wildcard slot report that it pays for itself; a catalog is a map of known territory and the catalog's own edges are where the interesting things live.

## 9. The Obvious Things

Also deliberate. A sophisticated audit reliably walks past a debug endpoint left routed, a credential in a committed `.env`, an admin check commented out with a TODO, an auth middleware registered after the route it was meant to guard, a `verify=False`, a wide-open CORS reflection. One cheap pass whose whole job is the unsubtle.

## Universal Moves

Apply in every class.

- **Distrust names and comments.** `validateInput` may not validate; "sanitized upstream" is a claim about a caller that may have changed. Read the body.
- **Read every path, not the happy one.** Early returns, error branches, retries, and the fourth path are where the guard is missing.
- **Verify structurally before reporting.** Every path, symbol, and line cited must exist and must say what the finding claims. A finding pointing at the wrong line costs more than a missed one, because the reader loses trust in everything around it.
- **Grep is the floor.** It tells you where to start reading and never what is there. A finding whose entire evidence is a grep hit is not a finding.
- **A bug found does not end the area.** Keep going until the class's questions are answered, not until something turns up.
