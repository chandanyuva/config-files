---
description: Stage the working changes and commit them with a well-formed message matching the repo's commit style.
agent: build
---

Create a commit from the current working tree changes.

1. Run `git status --short` and `git diff` (also `git diff --staged` if anything is staged). Determine what changed and what the intent of the changes is.
2. Look at `git log --oneline -15` to learn the repo's commit message style (conventional commits like `feat:`/`fix:` vs. plain messages, sentence case, imperative mood).
3. If $ARGUMENTS was provided, use it as the primary intent; otherwise infer the intent from the diff.
4. Stage the relevant files with `git add`. If the user's arguments suggest only part of the changes should be committed, stage only those.
5. Write the commit message in the repo's established style: a concise summary line (imperative, ≤ ~72 chars), plus a body explaining the why when it isn't obvious.
6. Run the commit, then show `git log --oneline -1` and `git status --short` so the result is visible.

Do not commit secrets, build artifacts, or unrelated files. Do not push unless asked.
