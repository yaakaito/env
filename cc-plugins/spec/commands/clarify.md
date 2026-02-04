Clarify ambiguous points in the current context through structured questioning.

## Core Behavior

1. **Analyze** - Read existing context (conversation, `.dev-plans/`, codebase)
2. **Identify gaps** - Find ambiguous or incomplete points
3. **Ask questions** - Use AskUserQuestion tool to clarify each item
4. **Iterate** - Continue until specification is complete
5. **Document** - Update specification summary after each answer

## Phase 1: Initial Analysis (Silent)

- Review conversation history and existing specs (search: `specs/`, `.specs/`, `docs/specs/`, `.dev-plans/`)
- Analyze relevant codebase sections
- Create a scope list of items needing clarification
- Categorize gaps across 8 areas:
  - Scope, Behavior, Data, Users, Integration, Constraints, Priority, Edge cases

## Phase 2: Iterative Questioning

**MUST use AskUserQuestion tool** (conversational questions are not allowed)

- 2-4 questions per round
- Each question has 2-4 options with pros/cons in descriptions
- Skip questions answerable from codebase analysis
- Do NOT guess or assume - always ask when unclear

## Phase 3: Specification Summary

After each round, update and display:

```
## Specification Summary

### Confirmed
- [Item]: [Decision] - [Rationale]

### Pending
- [Item]: [Why it needs clarification]
```

## Phase 4: Completeness Check

- Review all 8 categories for remaining gaps
- If gaps remain → Return to Phase 2
- If complete → Proceed to output

## Output

### Decisions Made

| Category | Decision | Rationale |
| -------- | -------- | --------- |
| ...      | ...      | ...       |

### Requirements

**Functional:**

- Requirement + acceptance criteria

**Non-Functional:**

- Requirement + metrics

### Open Questions

- Items that still need resolution (if any)

### Next Steps

- `/spec:create-md` - Create specification document
- Plan mode - Break down into implementation tasks

## Important

- **Do NOT guess** - Always ask when something is unclear
- **Be thorough** - Cover all relevant categories
- **Stay focused** - Only ask about the current context
- **Track progress** - Update specification summary after each round
