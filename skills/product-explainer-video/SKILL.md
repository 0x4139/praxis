---
name: product-explainer-video
description: Guided pipeline that turns a product and the problem it solves into a 30–90s explainer video through five stages — position, script, storyboard, produce, variants. Use when the user wants an explainer, product, launch, how-it-works, or onboarding video; a video script or storyboard; a rendered animated scene (HTML or MP4); or social cuts of an existing explainer. Triggers on "explainer video", "product video", "launch video", "video script", "storyboard this", "turn this into a video".
---

# Product Explainer Video

An explainer is an argument, not a feature tour: one core idea the viewer can repeat afterward, carried by the voice-over, illustrated — never led — by the visuals. The pipeline runs **position → script → storyboard → produce → variants**; each stage ends in a durable artifact under `media/<slug>/` and the user's confirmation before the next begins.

## The Pipeline

| Stage | Input | Output | File |
|-------|-------|--------|------|
| **Position** | Product + problem (or a raw wish) | `brief.md` — all seven decisions settled (idea, audience, problem/stakes, proof, analogy, formats, style/voice/audio) | `position.md` |
| **Script** | The brief | `script.md` — five-beat VO with per-line timings | `script.md` |
| **Storyboard** | The script | `storyboard.md` — shot grid + the master timing array | `storyboard.md` |
| **Produce** | The storyboard | `project/` + `renders/` — standalone HTML scene or Remotion MP4, verified | `produce.md` |
| **Variants** | The master render | Re-hooked cuts: 15s teaser, 6s bumper, 9:16, 1:1 | `variants.md` |

## Conducting

1. **Locate the user.** A raw product idea → position. A complete brief (all seven position decisions answered) → script. An approved script → storyboard. A storyboard → produce. An existing master → variants. Invoked bare, show the map; invoked with content, name the stage and start.
2. **One stage at a time.** Read only that stage's file (plus the files it explicitly references). Each stage ends with its artifact confirmed by the user.
3. **The timing array is the spine.** Script timings → storyboard timecodes → scene cuts → captions all derive from one array. A change anywhere re-flows from the script, never patched downstream.
4. **Hand off explicitly.** Close each stage by naming the artifact and offering the next: "Script timed at 61s. Next: storyboard it?"

## Shared Rules

- **Script-first.** Words are written and timed before anything is drawn; cutting a sentence is cheap, cutting a built scene is not.
- **Position decisions are the user's** — gathered in frontier rounds (`position.md`); facts (product claims, metrics for proof) come from their materials, never invented.
- **Artifacts over chat**: everything lands in `media/<slug>/` (`brief.md`, `script.md`, `storyboard.md`, `project/`, `renders/`).
- **No narration or music generation.** VO ships as timed text for the user to record; background music is a user-supplied file wired in with fades and ducking.

## Related Skills

- `product-positioning` — the differentiation thinking the position stage leans on for the argument.
- `article-writing` — voice derivation from brand examples, used by the script stage.
- `social-content` — platform thinking behind the variants stage.
- Installed iart-ai style packs (`whiteboard-animation`, `isometric-animation`, `diagram-animation`) — routed to by produce when present; never required.
