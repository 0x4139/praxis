---
name: ideation
description: Parallel divergent ideation for open-ended decisions — spawn isolated subagent branches under different cognitive frames, then score, cluster, flag traps, and commit to a shortlist. Use for open-ended design, architecture, naming, API surface, positioning, or strategy questions where the obvious answer being wrong is costly, or for hypothesis generation on bugs with unknown root cause. Skip for lookups, syntax, bugs with a known cause, or closed phrasing like "quick", "just give me", or "standard".
---

# Ideation

The first three answers to any open question are the ones every senior engineer gives in thirty seconds — correct and forgettable. The interesting options live past number three. This skill walks there deliberately: generate wide under multiple isolated frames, then converge with a real opinion.

## When to Activate

- Architecture or system-design decisions with several viable shapes
- Public API or SDK surface design
- Naming a product, feature, or category
- Positioning and strategy questions with no canonical answer
- Fuzzy debugging where the root cause is unknown and hypotheses are needed

**Do not activate** for syntax questions, lookups, bugs with a known root cause, or closed phrasing — "quick", "just", "standard", "canonical" mean the user wants the direct answer.

## Pre-Flight Gate

This is expensive: 8–9 subagent calls, 5–10x the cost of a direct answer. Run this gate first.

1. **Explicit invocation?** User invoked the skill by name or asked for wide exploration → skip the gate, go to Phase 1.
2. **Open-ended?** Would a senior engineer give multiple viable answers? One canonical answer → abort.
3. **High-stakes?** Is the obvious answer being wrong actually costly (architecture, public API, real product name, schema)? No → abort.
4. **Closed phrasing?** Any "quick", "just tell me", "just give me", "one-liner", "standard" in the request → abort.

On abort: answer directly, optionally with one line — "For a wider exploration under parallel frames, invoke `ideation` explicitly."

## The Process

Two strict phases. Never mix them: a critic running during generation strangles the generator, and every idea collapses toward the safe default.

### Phase 1: Diverge (critic off)

1. Pick 5 frames from the table below — 4 matched to the problem domain, 1 wild for range.
2. Spawn 5 **parallel, isolated** subagents, one per frame — one message, five subagent calls. Each gets only: the problem, the user's context, its frame prompt (the Vantage text from the table, verbatim — paraphrasing dilutes the frames toward each other), and this instruction:

   > You are a generator, not a critic. Produce up to 6 short, distinct ideas under this frame — one sentence each, with a one-line rationale. Stop early if new ideas repeat the shape of existing ones. Do not evaluate, rank, or hedge. The first three obvious answers are banned; push past them.

3. **Isolation invariant:** the invariant is context isolation, not simultaneity — sequential isolated subagents are acceptable when parallel dispatch isn't available. What breaks the method: simulating branches inline in your own context, or feeding one branch's ideas to another. Shared context anchors every branch to the first idea — one wide thought, not five independent ones.

### Phase 2: Converge (critic on)

1. **Score** every idea 0–10 on three axes: novelty (distance from the default), viability (could it ship), fit (does it answer the actual question). Rank by weighted score: viability 0.40 + novelty 0.35 + fit 0.25.
2. **Flag traps.** An idea that scores well but hides a cost — won't scale, false economy, premature abstraction — gets flagged with a one-line reason, not silently dropped.
3. **Cluster** by underlying angle, not surface keywords: "remove-the-server plays", "batching plays", "rename-the-category plays". 3–6 clusters.
4. **Deepen the shortlist** (2–4 picks by weighted score, traps excluded). For each pick, one subagent — given the idea, its cluster, the problem, and the user's context — produces: a 4–8 sentence sketch of how it works, the load-bearing risk, the first concrete step, and 2–3 child variations.

## Frames

| Frame | Vantage | Best for |
|-------|---------|----------|
| Inversion | If the goal is X, how would you guarantee NOT X? Negate each answer back. | any |
| Hostile competitor | How would an attacker or rival exploit or break the obvious solution? Invert into ideas. | code, design |
| $0 and one hour | Crudest version that still does the load-bearing thing. | code, product |
| Infinite budget, ten years | The maximalist version with no constraints. | design, strategy |
| Remove the fixed assumption | Name what everyone treats as immovable (framework, database, request-response). It's gone — now what? | code, design |
| 3am on-call | What design means never getting paged for this? | code, infra |
| Borrowed mechanism | Force-fit a mechanism from another field — logistics (queues, batching, hub-and-spoke), biology (immune systems, signaling), markets (auctions, clearing). | wild |
| Beginner's eyes | Someone who has never seen the conventions describes naive approaches. Ignore how it's usually done. | wild |

Re-running the same problem in a session? Pick frames not yet used, so each run maps different territory.

## Output Format

Structure is half the value — never collapse this into prose:

1. **Brief** — one or two lines restating the problem and any reframe
2. **Wide set** — all ideas grouped by cluster, one phrase each, score chips with the weighted total like `[N7 V8 F9 · 7.9]`
3. **Shortlist** — 2–4 picks with one-line reasons; mark the non-obvious-but-viable pick ★; list traps separately with reasons
4. **Deep dives** — one per shortlist pick: sketch, load-bearing risk, first concrete step, child ideas
5. **Provocation** — one wildcard question that opens a new direction to push into

## Anti-Patterns

- **Decorated convergence** — ten variations sharing one underlying assumption is not divergence
- **Weird for weird's sake** — 30 unsorted absurdities without convergence is as useless as one safe answer
- **Refusing to commit** — "here are 20 ideas, you decide" is a cop-out; converge with a real opinion
- **Broken isolation** — simulating branches inline in one context is one wide thought wearing five hats; only subagents keep branches independent
- **Padding to a number** — stop diverging when new ideas repeat the shape of existing ones

## Attribution

Adapted from [adhd](https://github.com/UditAkhourii/adhd) by UditAkhourii, MIT licensed. Kept the generator/critic split, isolation invariant, pre-flight gate, and trap flagging; slimmed the frame set and output ceremony.

## Related Skills

- `blueprint` — Turn the winning idea into a multi-session construction plan
- `product-positioning` — When the open question is differentiation specifically
- `market-research` — Ground strategy-flavored shortlists in market evidence
- `go-to-market` — Carry a positioning or channel idea into a full GTM plan
