---
description: Print the current environment: shell, OS, git, and available tools.
---

Here is the current environment:

!`uname -srmo; echo; echo "SHELL: $SHELL"; echo; if git rev-parse --show-toplevel 2>/dev/null; then echo "BRANCH: $(git branch --show-current)"; echo "STATUS:"; git status --short | head -20; else echo "not a git repo"; fi; echo; for t in node npm bun python3 go rustc cargo docker kubectl gh; do if command -v "$t" >/dev/null 2>&1; then printf "%-8s %s\n" "$t" "$($t --version 2>/dev/null | head -1)"; fi; done`

Present this concisely: OS/shell, git state (repo, branch, dirty files), and installed
tools with versions. Flag anything notable — missing tools, uncommitted changes, or
unexpected OS/shell. Skip tools that weren't listed.
