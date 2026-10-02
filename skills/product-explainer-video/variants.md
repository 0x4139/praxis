# Variants

Cut the master into the formats the brief ordered. A variant is **re-hooked, never cropped**: each one opens with its own first line engineered for its context, then borrows scenes from the master's timing array.

## The Cuts

| Variant | Length | Frame | Structure |
|---------|--------|-------|-----------|
| **Teaser** | 15s | master's | New hook (≤3s) → the single strongest How step → CTA. Skip Problem/Stakes — a teaser sells curiosity, not the argument. |
| **Bumper** | 6s | master's | One claim + product name + CTA card. Essentially the Solution beat alone; no mechanism. |
| **Vertical** | 15–30s | 9:16 | Re-composed, not letterboxed: text re-laid for the tall safe area, one visual per beat, captions larger (mobile, muted). |
| **Square** | 15–30s | 1:1 | Same re-composition discipline for feed placement. |

## Rules

- Each variant gets its own hook line — write it fresh against the variant's context (a bumper interrupts; a teaser precedes; a vertical competes with thumbs).
- Scenes are reused from the master project by reference to the timing array; motion grammar and style system stay identical.
- Captions re-authored per variant from its own cue list (lengths changed, so timings changed).
- Tier 2 variants: one composition per variant in the same Remotion project, each verified with the same stills → contact sheet → encode → `probe-mp4.sh` loop (assert the variant's resolution: 1080x1920 for 9:16, 1080x1080 for 1:1).
- Renders land in `media/<slug>/renders/` named `<slug>-teaser-15.mp4`, `<slug>-bumper-6.mp4`, `<slug>-916.mp4`, `<slug>-11.mp4`.

## Exit

All ordered variants rendered and confirmed. Offer `social-content` for the copy that posts them.
