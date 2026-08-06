---
description: Write or update tests for the current changes and run them until they pass.
agent: build
---

Ensure the current changes are covered by tests, and that those tests pass.

1. Identify the test setup: check package.json scripts, pytest.ini/pyproject.toml, Cargo.toml, go.mod, Makefile, or CI config to find the test framework and how tests are run.
2. Review `git diff` to understand what behavior changed or was added.
3. Find existing tests for the affected area and follow their style, structure, and location. Add new tests or update broken ones covering:
   - the happy path of the new/changed behavior,
   - key edge cases (empty input, errors, boundaries),
   - any regression the change fixes.
4. Run the tests. If something fails, fix the tests or report the failure honestly — never delete or weaken a test just to make it pass.
5. Report what you added/changed and the final test run result.

If the change is a bug fix, prefer adding a regression test that fails without the fix.
