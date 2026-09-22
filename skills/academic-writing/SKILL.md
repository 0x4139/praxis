---
name: academic-writing
description: Write and revise academic papers — abstracts, introductions, related work, method, experiments, conclusions — with reviewer-facing structure, paragraph flow, and claim-evidence alignment. Use when drafting or rewriting a research paper or thesis section, checking whether a paper's section or paragraph flows, preparing a pre-submission self-review, or planning a paper's story. Core structure applies to any academic paper; section templates target empirical CS/ML papers.
---

# Academic Writing

Write papers a reviewer can follow and can't easily reject. Structure carries the argument: the paper is an hourglass — broad opening, narrowing to the thesis, a focused body, a conclusion that broadens back out — and every claim inside it must be backed by evidence the paper actually contains.

## When to Activate

- Drafting or rewriting any paper section: Abstract, Introduction, Related Work, Method, Experiments, Conclusion
- The user asks whether a paragraph or section "flows" or is clear
- Pre-submission self-review from a reviewer's mindset
- Planning the story of a paper before writing prose

## Workflow

1. **Story first.** Before sentence-level work, answer the four story questions (below). Every section reuses these answers.
2. **Section templates.** Load `sections.md` for the section being written — only that section's guide, not all of them.
3. **Draft paragraph by paragraph.** One paragraph carries one message; its first sentence states it.
4. **Reverse-outline** each finished section (below).
5. **Map claims to evidence.** Every major claim in Abstract/Introduction gets a row: `Claim | Evidence | Status: supported / needs evidence`. Unsupported claims get evidence, get weakened, or get cut.
6. **Adversarial review.** Before submission, run `review.md` — the five rejection dimensions and the reviewer checklist.

For a flow check alone, jump to Reverse Outlining below; for a review-only request, go straight to `review.md` — the story questions still apply when claims fail.

## The Four Story Questions

Answer once; the Abstract, Introduction, and Method all draw on them:

1. What technical problem do we solve, and why is there no well-established solution?
2. What is our contribution (new task, pipeline, module, finding, or insight)?
3. Why does our approach work, in essence?
4. What advantage or new insight does the reader take away?

If these have no crisp answers, the problem is the research story, not the writing — fix that first.

## Paragraph Craft

Every body paragraph has four parts (topic sentence, evidence, analysis, transition):

- **Topic sentence** — first sentence states the paragraph's one message and ties to the thesis
- **Evidence** — data, results, or citations that support it
- **Analysis** — never present evidence without interpretation; say what the number or quote means for the claim
- **Transition** — the handoff: the last sentence sets up the next paragraph's topic

Within a paragraph, each sentence relates to the previous one by cause, contrast, consequence, refinement, or example.

**Reverse outlining** (the flow test): write down the thesis, then each paragraph's topic sentence, then the evidence under each. Any paragraph that doesn't map cleanly to the thesis gets revised or removed. If the reverse outline is hard to write, the section is disorganized — that's the diagnosis, not a formality.

## Global Rules

1. Keep terminology stable — never rename a concept mid-paper
2. Define every term before reusing it; nouns must be self-contained
3. Visual quality is content: clean teaser and pipeline figures, minimal-ink tables, captions that carry information
4. Build a mini-outline before drafting prose in any section
5. State the "so what" early — why the reader should care, in the introduction, explicitly

## Anti-Patterns

- **Naive-baseline patching** — presenting a simple baseline and then your improvement over it makes any work read as an incremental patch; lead with the challenge instead, even for incremental work
- **Novelty illusion** — hiding a simple method behind abstract insight language and undefined new terms; reviewers read this as shallow, so explain the concrete mechanism
- **Evidence without analysis** — a statistic or quote never speaks for itself
- **Citation-dump related work** — grouping by year instead of by technical topic, hiding the strongest baselines
- **Claims outrunning results** — an Abstract promising what no table shows is the fastest route to rejection
- **New ideas in the conclusion** — the conclusion is the final pitch for what was argued, never a place for new claims

## Files

- `sections.md` — per-section guides: hourglass structure, hooks, templates for all six sections, sentence skeletons for Abstract, Introduction, and Method
- `review.md` — rejection dimensions and the pre-submission reviewer checklist

## Attribution

Methodology adapted from Prof. Peng Sida's open research-writing notes (github.com/pengsida/learning_research) as packaged by Master-cai/Research-Paper-Writing-Skills (MIT), and from "The Structure of an Academic Paper" (Simone A. Fried, Harvard GSE Communications Lab, 2021) for the hourglass model, hook catalog, and paragraph anatomy.

## Related Skills

- `article-writing` — Non-academic long-form: blog posts, guides, newsletters
- `slides` — Turning the paper into a talk
- `market-research` — Source-attributed research for non-academic contexts
