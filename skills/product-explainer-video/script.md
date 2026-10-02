# Script

Write the voice-over as the spine of the film — spoken language, timed to the second, every line traceable to the brief. **Synthesis from the brief**: a missing decision means one targeted round back to the user (`../distill/elicit.md` § Targeted Round), not an invention.

## The Five Beats

| Beat | Job | Viewer's thought | Runtime share |
|------|-----|------------------|---------------|
| **Hook** | Stop the scroll in ≤5s — question, stat, or the problem mid-tension. Never logo-first. | "Wait—" | ~8% |
| **Problem / Stakes** | Name the pain in the audience's words; show its cost | "That's me. I need this fixed." | ~17% |
| **Solution** | The product as the fix, one plain sentence | "Oh — that solves it." | ~15% |
| **How / Proof** | The mechanism in 1–3 concrete steps riding the analogy, then the proof beat | "I get it. And it's real." | ~40% |
| **Payoff + CTA** | The after-state, then one next action | "I want that. I'll do X." | ~20% |

## VO Rules

- Write for the ear: contractions, short sentences, one idea per line. Read it aloud.
- Pace **2.3 words/sec** (≈140 wpm); technical lines slow to ~2.0. Budgets: 30s ≈ 69 words · 60s ≈ 138 · 90s ≈ 207.
- `line_seconds = words / pace + 0.4` breathing room; visual-only beats ≥1.0s.
- Over budget → cut words, never widen the runtime silently.
- **Voice**: brand examples in the brief → derive voice with the `article-writing` skill's method. None → plain-spoken default: confident, concrete, zero jargon the audience wouldn't use.

## Format

Write `media/<slug>/script.md` — the timing column here becomes the master timing array:

```md
# Script: <product> (<runtime>s, <word count>w)

| # | Beat | VO line | Visual intent | Motion note | t (s) |
|---|------|---------|---------------|-------------|-------|
| 1 | Hook | Shipping software still means a dozen manual steps. | Checklist stacking up | items fall in, stagger | 0.0–4.8 |
| 2 | Problem | Someone forgets one, and the release breaks at 2am. | One item turns red | red shake, hard cut on "breaks" | 4.8–9.4 |
| … | | | | | |
```

Columns: VO line (or on-screen text for silent beats) · visual intent (what illustrates *this* line) · motion note (one phrase) · cumulative timecode.

## Exit

Read the full VO aloud once more against the runtime, show the user the table with total duration and word count, confirm — then offer the storyboard (`storyboard.md`).
