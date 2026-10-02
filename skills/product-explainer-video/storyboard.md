# Storyboard

Turn the timed script into a shot grid. One idea per scene — a scene holding two ideas gets split. Every VO line maps to exactly one visual intent, and all timings copy from the script's column: the storyboard refines the master timing array, it never forks it.

## Lock the Style System First

Before detailing scene 2, fix the grammar the whole film reuses (seed from the brief's brand values, else these defaults):

```
TYPE      : Display = Inter 700 / 56px · Caption = Inter 500 / 28px
COLOR     : bg #0B0F14 · primary #0A84FF · success #30D158 · warn #FF9F0A · text #F5F7FA
            (color = meaning; never reassigned mid-video)
EASING    : enter cubic-bezier(.22,1,.36,1) · exit cubic-bezier(.4,0,1,1)
TIMING    : enter 0.4s · hold ≥1.0s · transition 0.25–0.4s
TRANSITION: default hard cut on the stressed word; match-cut between related scenes
SAFE AREA : text inside the 90% center (survives platform crops)
```

## Shot Grid

Write `media/<slug>/storyboard.md`, one block per scene:

```
SCENE 01  | t=00:00.0–00:04.8 (4.8s) | beat: Hook
VO        : "Shipping software still means a dozen manual steps."
VISUAL    : Cluttered checklist UI, items stacking up
KEY MOTION: items fall in (stagger 0.1s)
TRANSITION: hard cut on "steps"
CAPTION   : "Shipping software still means a dozen manual steps."
ASSET     : checklist.svg
NOTES     : muted palette — pain reads gray
```

Rules:

- Pacing tracks tension: brisk cuts through Problem/Stakes, one clear hold on Solution, slowest on How (each step must land), let the Payoff breathe.
- Transitions land on a named word.
- The analogy from the brief drives the visual grammar in every scene — no scene-local metaphors.
- Track assets per scene: the produce stage gets a shopping list, not surprises.

## Captions

Captions are mandatory — assume muted autoplay. Author cues from the same timing array: ≤2 lines, ≤42 chars/line, on-screen ≥1.0s, cleared before the next cue, lines broken at clauses.

## Exit

Walk the user through the grid scene by scene (or as one table), confirm — then offer production (`produce.md`).
