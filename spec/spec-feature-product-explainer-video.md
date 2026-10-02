---
title: product-explainer-video skill
date_created: 2026-10-02
status: draft
---

## Problem Statement

Turning "my product solves X" into a watchable explainer video requires three crafts that rarely live in one place: positioning (what's the argument?), scriptwriting (how is it told?), and motion production (how is it rendered?). Users either get a script with no path to pixels, or motion tooling with no argument behind it.

## Solution

A praxis skill, `/praxis:product-explainer-video`, that conducts a staged pipeline from product + problem to a rendered explainer: **position → script → storyboard → produce → variants**. The position stage interrogates via distill-style frontier rounds; production is vendored (Remotion/HTML deliver-and-verify loop) so the skill works standalone, while external iart-ai style packs are routed to when installed.

## User Stories

1. As a founder, I want a 30–90s explainer for my product's launch, so that visitors grasp the problem and solution before they scroll away.
2. As a marketer, I want the script grounded in real positioning (problem, audience, proof), so that the video argues rather than decorates.
3. As a solo dev with no video tools, I want an HTML-rendered scene I can screen-record or embed, so that I ship something without installing a toolchain.
4. As a user who needs an MP4, I want the skill to scaffold and render a Remotion project with synced captions, so that the deliverable is a real video file.
5. As a user with brand materials, I want the voice derived from my existing copy, so that the narration text sounds like us.
6. As a social publisher, I want 15s teaser / 6s bumper / 9:16 and 1:1 variants planned from the start, so that each cut has its own hook instead of being a crop.
7. As a user with a style preference, I want whiteboard/isometric/diagram styles used when those packs are installed, so that the craft of installed subskills is leveraged, not reinvented.
8. As a user who wants music, I want my background track wired into the composition with fades, so that the video doesn't ship silent.

## Implementation Decisions

- **Name/invocation**: skill `product-explainer-video`, user-invocable; new README category **Media & Motion**, with `slides` moved into it.
- **Architecture**: conductor SKILL.md + stage files (distill pattern): `position.md`, `script.md`, `storyboard.md`, `produce.md`, `variants.md`.
- **Position stage**: distill-elicit frontier rounds (references `../distill/elicit.md` method) covering problem, audience, differentiator, proof points, target channels/formats, style preference, background audio. Accepts a complete brief without re-interviewing. Reuses `product-positioning` thinking for the differentiator.
- **Script stage**: five-beat framework — Hook → Problem/Insight → Solution Story → Proof → CTA (adapted from gtmagents/gtm-agents, Apache-2.0, credited). Script table columns: VO/on-screen text, visuals, motion notes, duration. Voice derived via `article-writing` when brand examples exist; short tone checklist otherwise. Write-for-ear rules (short sentences, contractions).
- **Storyboard stage**: shot grid — frame, description, on-screen text, motion/easing notes, duration, cumulative timecode; one timing array shared by scenes and captions.
- **Produce stage** (vendored from iart-ai/explainer-video-skills, MIT, credited): two tiers — **HTML tier default** (standalone HTML scene, zero toolchain, screenshot-verified); **Remotion tier when MP4 requested** (scaffold project, captions driven from the shared timing array, headless render). Deliver-and-verify loop with vendored `scripts/`: contact-sheet, probe-mp4, seek-shot. Style routing: if `whiteboard-animation` / `isometric-animation` / `diagram-animation` skills are installed, route scene building to them; else default motion style.
- **Audio**: no narration/TTS generation. VO text with timings delivered for the user to record. Background music: user-supplied track wired into the composition (loop/trim, fade in/out, duck under on-screen-text beats); no audio generation.
- **Variants stage**: planned during position (formats captured as decisions), produced last: 15s teaser, 6s bumper, 9:16 and 1:1 — each variant re-hooked, not cropped; derived from the master timing array.
- **Outputs**: `media/<slug>/` — `brief.md` (position decisions), `script.md`, `storyboard.md`, `project/` (HTML or Remotion), `renders/`.

## Testing Decisions

- `make validate` passes (frontmatter, no origin field).
- Skill-review subagent pass on routing clarity, stage handoffs, cross-skill references (same bar as distill).
- Dry-run application test: fresh agent given a product one-liner produces a position round, then (answers assumed) a five-beat script with timing table — no rendering executed in the test.
- Vendored scripts are syntax-checked (`bash -n`).

## Out of Scope

- Narration audio generation (TTS) — v1 delivers VO text + timings only.
- Audio/music generation — background track must be user-supplied.
- Vendoring the 16 non-explainer iart-ai packs — style packs are routed to, never bundled.
- After Effects or non-Remotion/non-HTML render paths.
- Publishing/uploading the rendered video anywhere.

## Further Notes

Credits on commit: gtmagents/gtm-agents (Apache-2.0) for the five-beat framework and tone checklist; iart-ai/explainer-video-skills (MIT) for the production workflow and verify scripts. README Credits section updated accordingly.
