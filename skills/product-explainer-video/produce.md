# Produce

Build and verify the film from the storyboard. Two tiers — pick by deliverable, not ambition. Everything renders from the master timing array; nothing is eyeballed.

**Paths**: run all commands from `media/<slug>/`. The verify scripts live in *this skill's* directory, not the media folder — resolve the skill's absolute path once and call them as `"$SKILL_DIR/scripts/…"` (the `scripts/...` spellings below are shorthand for that).

**Style routing first**: if the brief names a style and that pack is installed (`whiteboard-animation`, `isometric-animation`, `diagram-animation` in available skills), invoke it for scene construction and apply this file's verify loop to its output. Not installed → default motion style below; tell the user the pack exists (`npx skills add iart-ai/explainer-video-skills` et al.) rather than imitating a craft we don't carry.

## Tier 1 — Standalone HTML (default)

One self-contained HTML file in `media/<slug>/project/` — zero toolchain, embeddable, screen-recordable. Scenes driven by one GSAP timeline built from the timing array; include a **seek harness** so stills are deterministic: on load, read `?t=N` and `tl.pause(); tl.seek(t)`.

Scene techniques (reuse, don't improvise):

Eases shown are placeholders — replace with the storyboard's locked easing system. Every animation hangs off the one timeline `tl`, or the seek harness can't freeze it.

```js
// Progressive diagram reveal: nodes → edges → labels
// SVG edges need pathLength="1" on each path, or the dash trick draws nothing.
gsap.set(".edge", { strokeDasharray: 1, strokeDashoffset: 1 });
tl.from(".node",  { opacity: 0, scale: .85, transformOrigin: "center",
                    duration: .45, stagger: .3, ease: "back.out(1.5)" })
  .to(".edge",   { strokeDashoffset: 0, duration: .5, stagger: .3 }, "-=0.6")
  .from(".label", { opacity: 0, y: 6, duration: .3, stagger: .12 }, "-=0.4");

// Kinetic keyword stagger
tl.from(".headline .word", { yPercent: 120, opacity: 0, duration: .4, stagger: .05, ease: "power3.out" });

// Count-up stat — timeline-driven so ?t=N freezes it deterministically (never requestAnimationFrame)
const stat = { val: 0 };
tl.to(stat, { val: 12000, duration: 1.2, ease: "power3.out",
  onUpdate: () => el.textContent = Math.round(stat.val).toLocaleString() });
```

**Audio in Tier 1**: the HTML master is silent — a background track from the brief applies at the MP4 tier (or when the user screen-records); say so rather than wiring fragile autoplay audio.

**Verify**: `scripts/seek-shot.sh project/explainer.html 0 <mid> <end>` → `scripts/contact-sheet.sh sheet.png frame-*.png` → inspect the sheet: hook reads, text inside safe area, nothing clipped, each sampled frame matches its storyboard scene.

## Tier 2 — Remotion (when the deliverable is an MP4)

Scaffold a Remotion project in `media/<slug>/project/` (requires node; confirm with the user before scaffolding).

Contract:

- One `<Composition>` with zod `schema` + `defaultProps`; all motion frame-driven — no timers, `Date.now()`, or `Math.random()`.
- Scene cuts **and** captions driven from the same timing array baked into props:

```jsx
const cues = [ { from: 0.3, to: 2.6, text: "…" }, /* from the storyboard */ ];
export const Captions = () => {
  const t = useCurrentFrame() / useVideoConfig().fps;
  const cue = cues.find(c => t >= c.from && t <= c.to);
  return cue ? <div className="cap">{cue.text}</div> : null;
};
```

- **Background music** (brief's `Audio` field): `<Audio src={staticFile("track.mp3")} />` trimmed/looped to duration, fade in/out ~0.5s, volume ducked under beats with dense on-screen text. No track → silent master; never source audio yourself.
- Duration data-dependent → `calculateMetadata`, not arithmetic by hand.

**Verify loop — stills before encode** (render with the shipped props, not just defaults):

```bash
npx remotion still Explainer out/f-start.png --frame=0 --props='…'
npx remotion still Explainer out/f-mid.png   --frame=N --props='…'   # one frame inside EACH scene's hold
npx remotion still Explainer out/f-end.png   --frame=L --props='…'   # L = durationInFrames - 1
scripts/contact-sheet.sh sheet.png out/f-*.png                        # inspect: sync, overflow, safe areas
npx remotion render Explainer renders/explainer.mp4 --props='…'      # only after stills pass
scripts/probe-mp4.sh renders/explainer.mp4 1920x1080 30              # assert the encoded contract
```

## Done When

- Every sampled frame matches its storyboard scene; caption and visual agree at that instant
- Captions ≤2 lines, inside safe area, no clipping
- Tier 2: MP4 probe passes (resolution/fps/codec), plays end to end, music fades clean
- The user has seen the contact sheet (and MP4) and confirmed

## Exit

Master confirmed → offer **variants** (`variants.md`) if the brief ordered any.
