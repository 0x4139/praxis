# Position

Settle the argument before a single line of script. Run this as **frontier rounds**, borrowing exactly two things from the distill skill's `../distill/elicit.md`: the Round Format (❓ numbered question + ➡️ recommended answer, `---` between) and the question discipline (3–6 per round — more open decisions means more rounds, not a wall). Everything else in that file is distill-specific and does **not** apply here: no idea-separation playback, no filing parked ideas as issues, and this stage's exit is `script.md`, never distill's specify.

Rules of the interrogation:

- **Pre-supplied decisions are locked, not re-asked.** Echo them in the round's preamble ("60s master and 15s teaser — locked") and ask only the genuine gaps.
- **Facts are yours; decisions are the user's.** Read the product's repo, README, site, and existing copy directly for claims and voice; bring real material into your recommended answers.
- **Dependencies**: decision 5 (analogy) waits for 2 (audience); the rest are independent and can share a round.
- A complete brief supplied up front — all seven decisions answered — skips the interrogation entirely.

## The Seven Decisions

1. **Core idea** — one sentence the viewer should repeat afterward. Can't state it in one line → cut scope until you can. This is the `product-positioning` question: what makes this *different*, not just good.
2. **Audience & their words** — who watches, and how *they* phrase the pain (the script opens in their words, not the product's).
3. **Problem & stakes** — the pain and what it costs (time, money, risk). Stakes are what make the viewer stay for the mechanism.
4. **Proof** — the one credibility beat: a metric, a customer quote, a before/after. Must come from the user's real materials; no proof offered → the script gets a demo beat instead, never an invented number.
5. **Analogy** — one metaphor from the viewer's world (a queue, a thermostat, an assembly line) that carries both visuals and wording. One per video; if the analogy needs its own explanation, wrong analogy.
6. **Formats & runtime** — master length (30/60/90s) and which variant cuts are wanted (15s teaser, 6s bumper, 9:16, 1:1). A named platform implies the frame: X/YouTube → 16:9, Shorts/Reels/TikTok → 9:16, feed placements → 1:1. Decided here, produced last.
7. **Style, voice & audio** — visual style (default motion style, or a style pack — check which are actually installed before recommending one), brand type/colors if any, voice examples (paths/links to brand copy the script derives its voice from, or none), CTA (one action), and background music: none, or a user-supplied track file.

## Output

Write `media/<slug>/brief.md` — slug is the kebab-cased product name, confirmed with the brief:

```md
# Brief: <product> — <core idea, one line>

- **Audience**: …
- **Problem / stakes**: …
- **Proof**: … (source: …)
- **Analogy**: …
- **Runtime**: 60s · **Variants**: 15s teaser, 9:16
- **Style**: … · **CTA**: …
- **Audio**: none | <path/to/track>
- **Voice examples**: <paths/links to brand copy, or "none">
```

## Exit

Confirm the brief with the user, then offer the next stage: script (`script.md`).
