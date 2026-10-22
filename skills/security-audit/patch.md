# Patch

Opt-in, and it ends with files on disk. **Nothing is ever applied.** The person who owns the code decides what lands in it, and a security fix applied by the thing that found the bug is a change nobody reviewed.

## What a Patch Must Do

**Fix the root cause at the sink, not the symptom at one caller.** A validation added to the one route the finding named leaves the other three routes to the same sink open — and worse, it closes the finding while leaving the vulnerability. If the real fix is at the sink, write that, even where it is larger.

**Change as little as possible otherwise.** A security patch that also reformats, renames, or refactors will not get reviewed as a security patch. Keep it to the weakness.

**Preserve behaviour for legitimate input.** A patch that breaks the feature will be reverted, and the vulnerability comes back with it. Name, in the patch notes, what legitimate inputs were considered.

## Form

One patch file per finding, under `patches/`, named for the finding id. A unified diff, plus notes stating what changed, why that is the root cause, what legitimate behaviour was preserved, and how to verify it.

**Never apply, never commit, never stage.** Do not run the user's formatter or linter across the tree to make the patch fit.

## Secrets Need Two Patches

A hardcoded credential cannot be fixed in one diff without the diff itself publishing the secret.

1. **The code patch** — replace the literal with a read from the environment or the secret manager, referencing the value by name only.
2. **The rotation note** — a separate file saying which credential at which `file:line` must be rotated, in what system, and that **removing it from source does not rotate it**. It remains in git history and must be treated as compromised from the moment it was committed.

The value itself appears in neither file. Check `git check-ignore` before writing anything into the repository, and never write a secret into a file that is tracked.

## Verification Instructions, Not Verification Claims

Nothing here runs the code unless `prove.md` was invoked. So the patch notes say **how to verify**, in the imperative, and do not claim a result:

```md
## Verify

1. `go test ./api/handlers/...` — existing tests must still pass.
2. `curl -s "localhost:8080/tasks?name=%27%20OR%20%271%27%3D%271"` should return 400,
   where it previously returned the full table.
3. `curl -s "localhost:8080/tasks?name=alice"` must still return alice's tasks.
```

Where `prove.md` did run, the three-arm result belongs here too — baseline demonstrated the bug, the patched tree does not, and reverting restores the demonstration. That last arm is what shows the patch is what fixed it rather than something incidental about the run.

## Exit

A patch file per finding, nothing applied, and a list of the findings deliberately left unpatched with the reason — a fix that needs a product decision, a schema migration, or a dependency the repository does not have. **That list is never empty by omission:** a finding with no patch and no reason reads as a finding somebody forgot.
