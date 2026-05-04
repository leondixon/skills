---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test _imagined_ behavior, not _actual_ behavior
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

This skill orchestrates four delegated agents. The main thread owns the conversation with the user (interface design, prioritisation, sign-off); the agents own the work.

| Phase | Agent | Model |
|---|---|---|
| Plan | `planner` | opus |
| RED | `test-writer` | sonnet |
| GREEN | `implementer` | sonnet |
| Refactor | `refactorer` | sonnet |
| Review (pre-commit) | `reviewer` | opus |

### 1. Planning

When exploring the codebase, use the project's domain glossary so that test names and interface vocabulary match the project's language, and respect ADRs in the area you're touching.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](interface-design.md)
- [ ] Get user approval on the goal

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

Once the goal is agreed, **delegate decomposition to the `planner` agent** (Agent tool, `subagent_type=planner`). Pass the goal, the relevant interfaces, and any ADR constraints. It returns a numbered list of vertical slices with the next slice flagged. Show the plan to the user; revise if needed.

### 2. Tracer Bullet

The first slice is the tracer bullet — the smallest end-to-end behaviour that proves the path works.

```
RED:   delegate to test-writer  → one failing test
GREEN: delegate to implementer  → minimum code to pass
```

### 3. Incremental Loop

For each remaining slice:

```
RED:   delegate to test-writer  → one failing test
GREEN: delegate to implementer  → minimum code to pass
```

Rules:

- One test at a time (the test-writer enforces this).
- Only enough code to pass current test (the implementer enforces this).
- Don't anticipate future tests.
- Keep tests focused on observable behavior.

### 4. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code

Delegate the actual change to the `refactorer` agent — it runs the test suite between every step and reverts on red. Hand it one named refactor at a time ("extract X", "deepen Y"), not "make it nicer".

**Never refactor while RED.** Get to GREEN first.

### 5. Review (before commit)

Once the slice is green and any refactors have landed, **delegate to the `reviewer` agent** before committing. It reads the diff plus the touched files and returns Ship / Revise / Block. Address must-fixes, reconsider should-fixes, then commit.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
