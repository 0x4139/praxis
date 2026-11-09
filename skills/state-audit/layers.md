# Layers

Where implicit machines hide, and what to look for in each. Sweep the layers the repo actually has; a repo with no queue has no queue machines. Expect the distribution to be lopsided — UI produces the most candidates and the shallowest, persisted and queued state produces the fewest and the worst.

Signatures are starting points, not an inventory. Every one of them needs reading afterwards, and `rg` arguments vary by repo — adjust the globs.

## 1. Component and view state

The richest vein and the least consequential. Look for clusters of boolean state in one scope, and for a component with five or more independent state hooks.

```
rg -n 'useState<?boolean|useState\((true|false)\)' --glob '*.{ts,tsx,js,jsx}'
rg -n 'is[A-Z]\w*|has[A-Z]\w*|should[A-Z]\w*' --glob '*.{tsx,vue,svelte}' -o | sort | uniq -c | sort -rn | head -40
```

The second command is the one that matters: it ranks flag names by frequency across the codebase, and the top of that list is usually three or four machines wearing different names in different files.

## 2. Forms and wizards

Multi-step flows are machines by definition and almost never written as one. Steps tracked as an index with validation gates scattered per step, plus a dirty/submitting/submitted cluster.

```
rg -n 'step|currentStep|activeStep|stepIndex|wizard' --glob '*.{ts,tsx}'
rg -n 'isDirty|isSubmitting|isSubmitted|isValid|touched' --glob '*.{ts,tsx}'
```

Ask: can the user go back from the last step? What happens on refresh at step 3? Is there any edge out of a failed submit other than a full reset?

## 3. Async requests and data fetching

The canonical case. A boolean pair that cannot express the states it is used for.

```
rg -n 'isLoading|isFetching|isPending|isError|setError|loading, *error' --glob '*.{ts,tsx,js}'
rg -n 'useEffect\(' -A6 --glob '*.{ts,tsx}' | rg -n 'setLoading|setData|setError'
```

Query libraries already own this machine. A hand-rolled loading/error pair *beside* a query hook is a duplicate machine, which is a `delete` candidate rather than a `model` one. Check for abort handling: a request with no `AbortController` whose component can unmount has an unmodelled event.

## 4. Auth and session

Consequential. Partial-auth states are where real machines hide: authenticated but unverified, token valid but refresh in flight, logged out locally but not server-side, MFA pending.

```
rg -n 'isAuthenticated|isLoggedIn|isVerified|session|refreshToken|onboard' --glob '*.{ts,tsx,go}'
rg -n 'func.*[Mm]iddleware|RequireAuth|WithAuth' --glob '*.go'
```

Ask what holds during a token refresh, and whether two concurrent refreshes can race.

## 5. Routing and navigation

Guards and redirects are transitions, and when they live in several places they conflict. Look for redirect logic in more than one layer — middleware, layout, and component all deciding.

```
rg -n 'redirect\(|router\.(push|replace)|navigate\(|http\.Redirect' --glob '*.{ts,tsx,go}'
```

## 6. Persisted status columns

The worst machines in any app, because the invalid states outlive the process. A status column with no rules about legal transitions is an implicit machine with a database behind it.

```
rg -n 'status|state|phase|stage' --glob '*.sql' --glob '*/migrations/*'
rg -n 'enum|CHECK *\(|DEFAULT .(pending|draft|new)' --glob '*.sql'
rg -n 'UPDATE \w+ SET status' -i
```

Two checks pay for themselves immediately. First, whether any `UPDATE ... SET status` carries a `WHERE status = <expected>` — without it, concurrent transitions silently overwrite each other. Second, the invariant query: `select status, count(*) from t group by 1` plus a predicate for each invariant. States nobody designed show up as rows.

Booleans *beside* a status column are the compound form: `status` plus `is_archived` plus `is_locked` is `status_count × 2^2` implicit states.

## 7. Background jobs, queues, and workers

A job has a lifecycle that spans processes and survives restarts, which means every state is persisted whether you meant it or not.

```
rg -n 'retry|retries|attempt|backoff|maxAttempts|dead.?letter' -i
rg -n 'enqueue|publish|Consume|Subscribe|cron|schedule' -i
rg -n 'heartbeat|lease|visibility.?timeout|claimed_at|locked_at' -i
```

Ask the three questions that find every real job bug: what state is a job in when the worker dies mid-run, can the same job run twice concurrently, and is there any edge out of the terminal failure other than a human. A retry counter in a variable rather than in the persisted row is a machine that resets on deploy.

## 8. Caches and invalidation

Fresh, stale, revalidating, and evicted are states, and the transitions are usually implicit in TTL arithmetic spread across call sites.

```
rg -n 'cache|invalidate|revalidate|stale|ttl|maxAge' -i --glob '*.{ts,go}'
```

Multiple writers to one cache key is the `D` smell in its purest form.

## 9. External integrations and webhooks

The authoritative state lives on someone else's server, which is the `R` smell by construction. Payment intents, subscription lifecycles, and OAuth grants all have a documented remote machine your code shadows with a local one.

```
rg -n 'webhook|signature|idempot|stripe|paypal|oauth|callback' -i
rg -n 'case "[a-z_.]+":' --glob '*webhook*'
```

Ask whether webhooks can arrive out of order — they can — and whether the handler guards against moving the local state backwards. Shadowing a remote machine is legitimate; shadowing it without a reconciliation step is not.

## 10. Feature flags and rollout

Flags read in several places with no single resolution point produce a machine whose state depends on evaluation order.

```
rg -n 'featureFlag|isEnabled|flags\.|variant|experiment|rollout' -i
```

## 11. Build, deploy, and migrations

Deploy state, migration state, and rollout state are machines that run once and break loudly. A migration with no recorded in-progress state cannot be resumed after a failure halfway.

```
rg -n 'migrate|version|dirty|schema_migrations|goose|atlas' -i --glob '*.{go,sql,yaml,yml}'
```

## 12. Agent and LLM loops

Newer and rarely charted. A tool-calling loop has states — idle, planning, awaiting tool result, retrying, context-exhausted, aborted — and most implementations track them with flags and a turn counter.

```
rg -n 'tool_call|toolUse|maxTurns|turn|conversation|abort|stop_reason' -i
```

Ask what happens when a tool call never returns, whether a cancelled run can leave a half-applied side effect, and whether the loop can distinguish "the model finished" from "the model hit the turn cap".
