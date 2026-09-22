# Section Guides

Load this file when writing a specific section. Each guide assumes the four story questions in `SKILL.md` are already answered.

## The Hourglass

The paper's shape: the introduction opens at its widest (why anyone should care), narrows to a tight thesis, the body stays narrow and focused, and the conclusion broadens back out to the larger context. "Tell them what you'll tell them, tell them, tell them what you told them" — the repetition is a feature: readers can decide early whether to keep reading, and can navigate by structure.

---

## Abstract

Think the logic through, pick one template, revise many times.

**Template A — Challenge → Contribution:**
1. Task
2. Technical challenge for previous methods
3. One–two sentences naming the contribution that solves it
4. Benefits of the contribution
5. Experiment summary

**Template B — Challenge → Insight → Contribution:** as A, but insert one clear sentence stating the *insight* before the contribution that implements it.

**Template C — Multiple contributions:** task, optional one-sentence contrast with prior methods, then each contribution paired with its advantage in a single sentence, then experiments.

**Rules:**
- Discuss prior work only around the challenge you actually solve
- Name the contribution by its technical term; don't explain implementation steps
- The term must read without a jump — if the reader stumbles, rename or gloss it
- One pass should surface task, challenge, insight/contribution, and results

## Introduction

**Skeleton:** task and application → technical challenge of previous methods → our pipeline → experiments → contribution list.

**Reason backward first:** answer the four story questions, then decide how prior methods lead the reader to exactly the challenge you solve. Then write forward.

**Opening (pick one):**
- *Task-first* — define the task in one sentence (`[task] targets recovering [output] from [input]`), then 2–3 application scenarios. For niche tasks.
- *Application-first* — skip the definition, open with why it matters. For familiar tasks.
- *General-to-specific* — open with the general task's applications, then narrow: `This paper focuses on the specific setting of...`. For new settings.
- *Challenge-in-first-paragraph* — state task, how previous methods work, and where they fail, all in the opening paragraph. Strong when conditions allow.

**Hooks** (first sentence, any opening): a startling fact or statistic, a provocative question, a key-term definition, a debate overview, a paradox, or a sharp anecdote. Follow the hook with the explicit "so what" — why this matters — before narrowing to the thesis.

**The challenge passage (the most important paragraphs):**
- Build the chain: general challenge → traditional methods and their limit → recent methods and their limit *with the technical reason* → the remaining limitation, which must be exactly what your method solves
- A challenge = observable limitation + technical reason. Both, always.
- For novel tasks with no direct prior work: `This problem is challenging for three reasons. First... Second... Finally...`
- **Never** present a naive solution and then your improvement over it — it erases curiosity and reads as a patch, regardless of the work's actual novelty

**The pipeline passage:**
- One contribution: name the framework, point to the teaser figure, state the key novelty in one sentence, then `Specifically, ...` for concrete steps, then advantages (`In contrast to previous methods, ...`)
- Two contributions: contribution 1 + advantage, then the *remaining* challenge, then contribution 2 as its answer
- New module on an existing pipeline: prior setup → the module as innovation → the observation motivating it → mechanism → why better than generic alternatives
- Observation-driven: innovation first, then the intuitive observation, then implementation, then gains
- Explain the concrete mechanism — abstract insight language with undefined terms is the novelty illusion reviewers punish

**Roadmap (optional, venue-dependent):** after the thesis, a short narrative table of contents for the paper.

## Related Work

- Group by technical topic (2–4 topics), never by year: mainstream task methods, methods closest to your idea, techniques you build on
- Per topic: scope sentence → compact summary of representative methods → limitation tied to *your* challenge → transition to your method
- Compare mechanisms, assumptions, and failure modes — technical terms, not marketing
- Include the strongest and most recent competitors; hiding them never works

## Method

**Before writing:** list every module; for each, answer — how does it run, why is it needed, why does it work.

**Order of writing:** draw the pipeline figure sketch → map subsections from it → per subsection plan motivation / design / advantages → write the design first (the concrete backbone) → add motivation and advantages after.

**The module triad** (every subsection):
1. **Motivation** — problem-driven: `A remaining challenge is ...` — because problem X exists, module Y
2. **Design** — define structures (`We represent ... with ...`), then the forward pass in strict order (`Given [input], we first ... then ... finally ...`), then what the output feeds
3. **Advantage** — why this beats the alternatives, tied to measurable behavior

**Overview subsection:** setting in 1–2 sentences, core contribution in 1–2, pointer to the pipeline figure, and a map of what each subsection covers.

**Clarity check, three levels:** (1) summarize the section's logic after writing — is it smooth? (2) does each paragraph's first sentence state its message? (3) is every sentence's motivation clear — why is this sentence here — and is terminology stable?

Implementation details (hyperparameters, normalizations) go at the end of Method or their own subsection — not interleaved with ideas.

## Experiments

**Setup first:** open the section with the experimental setup — datasets (and why they're chosen), metrics (with direction), baselines, and the comparison/ablation protocol. Reviewers check reproducibility here; implementation details too long for this passage go to Method's implementation subsection.

Then, three questions the section must answer, in order:
1. **Better than strong baselines?** Recent/SOTA baselines, standard metrics, fair protocol (same splits, preprocessing, settings)
2. **Which design choices produce the gain?** Ablate every key module and parameter: remove/replace/disable, report the delta to the full model
3. **Does it generalize when pushed?** Harder or out-of-distribution settings, stress tests — report failures as well as gains

**Planning:** every claimed contribution gets a validation experiment; every module and key parameter in the pipeline figure gets an ablation.

**Tables and figures** (communication quality, not decoration):
- Caption above tables; booktabs rules (`\toprule/\midrule/\bottomrule`), no vertical lines, few horizontal ones
- Metric direction in headers (`PSNR ↑`, `LPIPS ↓`), units, consistent decimals
- One table, one message; subtle highlight for best results only
- Captions state setting/protocol/notation — discussion belongs in prose

## Conclusion

The final pitch, not a summary:
1. Restate the solved problem and core idea (fresh words, not copied sentences)
2. The strongest evidence, briefly
3. The insight or practical impact — return to the introduction's hook and broaden the lens back out
4. Limitation paragraph
5. One concrete future direction

**Limitations:** state *scope* limitations (data regime, assumptions, deployment setting) — boundaries of the task setting where the method is still competitive. A technical defect that loses to baselines on key metrics is a different animal; don't dress one as the other. No new claims or concepts here — synthesize what was argued.
