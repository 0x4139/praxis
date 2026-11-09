# Survey

Sweep wide and cheap. The output is a **candidate list**, not a set of charts — one line per candidate, scored, ordered. Resist charting anything here; the whole point of a separate stage is that charting costs ~20x what listing costs and most candidates do not deserve it.

## Set the boundary first

Ask once, in one line: the whole app, or a surface? A named surface — checkout, auth, the upload pipeline, one screen — is the better default, and if the user came with a symptom ("the spinner sometimes never stops") the surface is wherever that symptom lives.

Then establish what the app *is* in four questions, because a mode is only a mode relative to a purpose: what does it do, who uses it, what does it talk to, and what must never happen to a user mid-flow.

## Sweep by layer, not by file

Walk `layers.md`. For each layer present in the repo, run its signatures and read what comes back. Batch the greps — one call with `echo '--- layer'` markers beats twelve round trips.

Do not read whole files. A candidate is identifiable from the declaration site plus every write site, which is what the signatures give you.

Expect the layer distribution to be lopsided and uneven. Frontend components produce the most candidates and the shallowest ones; job queues and persisted status columns produce the fewest and the worst.

## Score each candidate, don't just list it

One line per candidate, in this shape:

```
<name> — <file:line of the declaration> — <N> writers — smells: <codes> — <one clause on what the modes seem to be>
```

Score is the count of distinct tells from `smells.md`, not a number you feel. Two tells is a candidate; four is almost always a real machine. The tells are cheap to check and you are checking them, not guessing them: `writers` is literally how many sites assign to it.

## Order by consequence, not by score

A high-smell candidate in a settings panel ranks below a low-smell candidate in payment capture. Order by what it costs when the machine enters a state nobody planned:

1. **Money, data loss, or auth** — a mode that can double-charge, drop a write, or leave a session half-authenticated.
2. **Dead ends** — a flow where a user can arrive somewhere with no edge out. Check for the four edges every async machine needs: timeout, retry, cancel, recovery.
3. **Known symptoms** — any candidate whose modes could produce a bug the user has already described.
4. **Churn** — machines whose files show heavy recent `git log` activity. Each new flag added to fight the existing ones is a vote.
5. **Everything else.**

## Close the stage

Present the ordered list with counts by layer, and name the cut explicitly:

> 31 candidates across 6 layers. Top 5 by consequence are the upload pipeline, the subscription status column, the auth session, the checkout wizard, and the retry wrapper. Chart those five? The other 26 go into the register as surveyed-not-charted.

Never chart more than the user picks, and push back on more than about eight in one pass. A surveyed-not-charted candidate is a useful artifact — it is a named suspicion with a location, and it stops the next audit from starting over.

**Do not announce invalid states here.** You have not charted anything, so you do not yet know what the valid states are. The flag arithmetic is not a result.

Next: `chart.md`.
