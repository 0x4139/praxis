# Pre-Submission Adversarial Review

Read the paper as a skeptical reviewer hunting for reasons to reject. Answer every question below with explicit evidence from the paper; mark each `pass`, `needs revision`, or `needs new experiment`; revise and repeat until no major risk remains.

## The Hard Rule

Every major claim — especially in the Abstract and Introduction — must be technically correct **and** explicitly supported by experimental evidence in the paper. Not supported → add evidence, weaken the claim, or delete it. No third option.

Maintain the claim-evidence map while revising:

```
Claim: ... | Evidence: Table 2, rows 3–5 | Status: supported
Claim: ... | Evidence: none              | Status: needs evidence
```

## The Five Rejection Dimensions

| Dimension | Typical failure signals |
|-----------|------------------------|
| Insufficient contribution | Targeted failure case is too common/trivial; the technique is well-explored and the gain predictable |
| Unclear writing | Missing technical detail — not reproducible; a module with no clear motivation |
| Weak empirical effect | Marginal improvement; absolute performance not competitive for the venue |
| Incomplete evaluation | Missing ablations, baselines, or metrics; datasets too easy to prove anything |
| Unsound method design | Unrealistic setting; technical flaws; needs per-scenario hyperparameter tuning; complexity outweighs benefit |

What gets papers accepted: a real contribution (novel task, pipeline, module, finding, or insight), better results than prior methods under fair comparison, and sufficient comparisons plus ablations. The checklist below probes exactly these.

## Reviewer Checklist

### Contribution
1. What new knowledge does the paper give readers?
2. Is the failure case we target meaningful, not trivial?
3. Is the idea non-obvious beyond well-explored practice?
4. Is the gain surprising or insightful rather than predictable?
5. Is there at least one clear novelty type (task / pipeline / module / finding / insight)?

### Writing clarity
1. Could a knowledgeable reader reproduce the method from the paper alone?
2. Does every key module have enough technical detail?
3. Is every module's motivation explicit and tied to a challenge?
4. Are terms and notation consistent across all sections?
5. Does each paragraph carry one message with smooth transitions?

### Experimental strength
1. Are improvements over strong baselines meaningful, not marginal?
2. Is absolute performance competitive for the target venue?
3. Are gains consistent across datasets, settings, and metrics?
4. Are failure cases reported honestly?

### Evaluation completeness
1. Is every key design choice ablated?
2. Are all strong and recent baselines included under fair settings?
3. Are the metrics standard and sufficient for the task?
4. Are the datasets hard enough to prove the method works?
5. Are comparison and ablation protocols documented?

### Method soundness
1. Is the experimental setting realistic for practical use?
2. Any hidden defects or unreasonable assumptions?
3. Robust without per-case hyperparameter retuning?
4. Do the benefits outweigh the added complexity and new limitations?
5. Could a reviewer reasonably argue the net value is negative?

## Review Loop

1. Run the checklist against the full draft; answer from the paper, not from memory of the work.
2. Mark every item `pass` / `needs revision` / `needs new experiment`.
3. Fix `needs revision` items by editing claims, structure, or prose; `needs new experiment` items by running it or weakening the claim.
4. Re-run until every high-risk item passes. Perfectionism is the correct calibration — assume the reviewer probes every weak point.
