---
name: pr-review
description: "Reviews a pull request or local diff for bugs, security issues, missing tests and maintainability, and reports findings ranked by severity with file and line references. Use when the user asks to review a PR, branch, diff or their changes before merging."
---
# Pull request review

## Step 1: Get the diff
- Local branch: `git fetch origin` then `git diff origin/main...HEAD` (use the repo's real default branch: `git symbolic-ref refs/remotes/origin/HEAD`).
- GitHub PR with the gh CLI: `gh pr view <number>` and `gh pr diff <number>`.
- Uncommitted work: `git diff HEAD`.
List changed files with `--stat` first. Read the full file around each hunk when the hunk alone isn't enough.

## Step 2: Check, in this order
1. Correctness: logic errors, off-by-one, null/undefined paths, wrong conditions, unhandled promise rejections or exceptions, race conditions, timezone and money (float) handling.
2. Security: authorization on every new route/action, input validation, SQL built with string concatenation, unescaped output (`{!! !!}` in Blade, `dangerouslySetInnerHTML` in React), secrets in code, mass assignment.
3. Data: migrations reversible and safe on existing rows; N+1 queries; missing indexes for new filters.
4. Tests: does a test cover the new behaviour and the main failure case? Would it fail if the change were reverted?
5. API/contract changes: breaking response shape, renamed env vars, changed config keys.
6. Readability: names, dead code, duplicated logic. Mention style only if no formatter covers it.

## Step 3: Run what you can
Run the project's tests and linters on the branch (for example `php artisan test`, `vendor/bin/pint --test`, `npm test`, `npm run lint`, `npx tsc --noEmit`). Say which ones you ran.

## Step 4: Report
```
Verdict: approve / approve with nits / request changes

Blocking
1. path/file.php:42 What is wrong, why it matters, suggested fix.

Should fix
...

Nits
...

Checked: tests run (result), linters run (result). Not checked: ...
```
Be specific and short. Don't pad the list; if the change is good, say so. Don't post comments to GitHub unless the user asks.
