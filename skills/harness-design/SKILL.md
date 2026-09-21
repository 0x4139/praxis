---
name: harness-design
description: Design agent harnesses for recurring workflows — the loop of roles, context boundaries, tools, observation handling, validation gates, and failure recovery around a model. Produces a harness spec document. Use when automating a recurring manual workflow into an agentic one (CI triage, PR review, research runs, support pipelines), when designing a multi-agent loop, or when an existing agent loop burns tokens or fails unpredictably. Skip for one-off tasks, single prompts, or single agent definitions — a harness is only for recurring work.
---

# Harness Design

A model is not a system. The harness — what the model sees, what it can do, when its context gets cut, how its output is verified — decides whether a workflow ships reliable results or burns tokens failing. This skill designs that harness deliberately, before any prompt gets written.

## When to Activate

- Turning a recurring manual workflow into an agentic one: CI failure triage, nightly PR review, weekly competitor research, support ticket handling
- Designing a multi-agent loop: coordinator/worker swarms, review pipelines, parallel research
- An existing agent loop is unreliable, expensive, or degrades on long runs
- Deciding what belongs in the harness (deterministic, enforced) vs the prompt (advisory)

**Do not activate** for one-off tasks, single prompts, or workflows a single short session handles fine — a harness earns its complexity only when the workflow recurs.

## Core Premise

Two lessons drive the process, both from measured harness research (SoL-Pi, arXiv:2609.20519):

- **Capability first, efficiency second.** Fix what the harness must not break — and the tolerance for it — before optimizing anything. An optimizer (human or AI) with access to its own acceptance criteria will game them.
- **Validation must not leak.** The checks that decide "this harness works" can never feed back into tuning it, or the harness overfits its own test and fails on the next real run.

## The Process

Work through the steps in order. Each produces a section of the final harness spec.

### Step 1: Characterize the Workflow

**Deliverable:** a one-page workflow contract:

| Field | Answer |
|-------|--------|
| Trigger | What starts a run? (schedule, event, human) |
| Inputs | What the harness receives, and its size/shape |
| Output | The artifact a run must produce |
| Verifier | How success is checked *mechanically* — test suite, schema, diff applied cleanly, human sign-off |
| Human touchpoints | Where a person must approve, and where they may interrupt |
| Volume | Runs per day/week — decides how much harness complexity is justified |

**Rule:** no verifier, no harness. A harness that can't tell success from failure automates nothing — it just produces output faster.

### Step 2: Fix Capability Metrics and Tolerances

Before designing anything else, write down:

- The 1–3 metrics that define "the workflow still works" (tasks resolved, review findings confirmed, tests passing)
- The tolerance on each (e.g., "resolution rate may drop at most 5% from the manual baseline"). No baseline yet? The first N runs establish it; freeze tolerances after.
- The efficiency metric to optimize *afterward*: cost or tokens **per verified outcome**, never per run — and the cost target: what a verified outcome should cost once the harness is tuned

These are frozen. Every later design choice — compaction, output truncation, cheaper models for sub-tasks — must stay within tolerance, and the tolerances themselves are not up for negotiation during optimization.

### Step 3: Roles and Context Boundaries

Decide the agent topology and what each role is allowed to see.

| Topology | Use when |
|----------|----------|
| Single agent | One coherent task, one context window suffices |
| Pipeline | Stages with different skills (gather → analyze → write) |
| Coordinator + workers | Parallelizable subtasks; workers isolated, coordinator merges |
| Generator + verifier | Output quality is checkable by a second, independent context |

**Rules:**
- A context boundary is a design decision, not an accident. For each role: what it receives, what it returns, what it must never see.
- Parallel workers meant to produce independent results must not see each other's output — shared context anchors them (see `ideation` for the same principle in idea generation). In pipelines, forwarding a stage's output is the design — declare exactly what crosses each boundary.
- The verifier sees the generator's artifact, never its transcript or reasoning.

### Step 4: Action Design

Define the tool surface per role.

- **Minimum toolset per role** — a research worker doesn't need write access; a verifier doesn't need network
- **Fuse actions that always co-occur** — edit + run tests as one step saves a model round-trip per edit; a mutation and the check of that mutation belong together
- **Gate destructive actions** — deletes, pushes, deploys, schema changes route through confirmation or a dry-run diff
- **Idempotency** — a re-run after a crash must not double-apply effects
- **Enforced vs advisory** — for each behavior, decide: enforced (a gate, script, or hook — must always happen) or advisory (a prompt or skill — guides judgment). Anything safety- or correctness-critical is enforced; the mapping table below translates this column to concrete constructs

### Step 5: Observation Handling

Unmanaged tool output is the largest token leak in long loops.

- **Large-output policy:** outputs over a threshold (~10 KB) enter context in full until the step that consumes them completes, then get replaced by a reference — a path or handle plus a short excerpt — retrievable on demand
- **Log reduction:** build/test logs compress to the evidence that decisions need (failing test, exit status, exact error lines) with the full log archived; on any doubt, fall back to the raw log
- **Never reduce silently:** a reduced observation says it was reduced and how to get the original

### Step 6: Compaction Policy

Decide *when* context gets summarized and *what must survive* — before the harness runs, not when the window fills.

- Compact at natural boundaries (a subtask completes), not mid-reasoning
- Compact only when projected savings beat the cost of doing it — frequent small compactions can cost more than they save on cached-prompt setups
- List the invariants that survive every compaction: the goal, the verifier, current state, open failures

### Step 7: Validation That Never Leaks

Two levels, keep them labeled apart:

- **For each run:** split checks into **development checks** (the loop may see these and iterate against them) and **held-out checks** (run only on frozen output; results never feed back into the loop). A failed held-out check rejects the run's output — it does not trigger another pass against that check.
- **For changes to the harness itself:** tune on one set of workflow instances, accept on instances the tuning never touched. At low volume, hold out by time — tune on past instances, accept on the next fresh ones.

### Step 8: Failure Modes and Recovery

- **Retry budget** per step, with backoff — and a distinction between "retry the same way" (transient) and "retry differently" (the approach failed)
- **Spiral detection:** three consecutive failed attempts at the same step means stop, name the assumption that might be wrong, and escalate — not a fourth attempt
- **Escalation path:** what a human receives when the harness gives up — current state, what was tried, the specific question
- **Partial results:** a run that fails at step 6 of 8 delivers steps 1–5, labeled

## Deliverable Format

One harness spec containing, in order:

1. **Workflow contract** (Step 1)
2. **Capability metrics and tolerances** (Step 2)
3. **Topology and context boundaries** (Step 3) — a role table: receives / returns / never sees
4. **Tool surface per role** (Step 4)
5. **Observation and compaction policy** (Steps 5–6)
6. **Validation plan** (Step 7) — development vs held-out checks
7. **Failure playbook** (Step 8)
8. **Cost target** — expected cost per verified outcome

### Claude Code Mapping

When the harness will run on Claude Code, close the spec with a mapping table:

| Spec element | Claude Code construct |
|--------------|----------------------|
| Roles | Subagents (`agents/*.md`) or Agent tool dispatches |
| Pipelines / swarms | Workflow scripts or parallel Agent calls |
| Action gates | Permission settings and PreToolUse hooks |
| Triggers | Hooks, slash commands, scheduled cloud agents, or cron + headless runs (`claude -p`) |
| Advisory behavior | Skills (`skills/*/SKILL.md`) |
| Verifier | Test commands, `make` targets, CI |

The dividing line: anything that must *always* happen belongs in hooks, permissions, or scripts (enforced); anything that guides judgment belongs in skills and agent prompts (advisory).

## Anti-Patterns

- **Efficiency before tolerances** — optimizing token cost with no frozen definition of "still works" optimizes toward garbage
- **Eval leaking into tuning** — iterating the harness against its own acceptance checks until they pass proves only that it memorized the test
- **One giant shared context** — every role seeing everything is the expensive way to make agents anchor each other
- **Unbounded observations** — dumping full logs and file trees into context on every step is the default failure, not an edge case
- **No verifier** — "the output looks right" is not a verifier; a harness without a mechanical check automates the production of unchecked output
- **Harness for a one-off** — a workflow that runs once needs a session, not a system

## Attribution

The capability-tolerance and validation-isolation principles, the observation handling and compaction mechanics, and the action-fusion pattern follow the findings of SoL-Pi (Liu et al., NVIDIA/NTU/MIT, arXiv:2609.20519), which discovered and measured them through automated harness research.

## Related Skills

- `blueprint` — Multi-session construction plan once the harness spec exists
- `ideation` — Diverge on harness approaches when the topology choice is genuinely open
- `docker-patterns` — Containerizing harness environments
- `conventional-commits` — Commit conventions for harness-produced changes
