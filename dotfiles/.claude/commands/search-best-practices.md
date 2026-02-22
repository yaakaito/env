Research a topic using WebSearch based on the current context.

## Arguments

- `$ARGUMENTS`: Topic to research (default: "best practices")

Examples:

- `/user:search-best-practices` → Research best practices
- `/user:search-best-practices security considerations` → Research security considerations
- `/user:search-best-practices performance optimization` → Research performance optimization
- `/user:search-best-practices similar implementations` → Research similar implementations

## Phase 1: Context Analysis (Silent)

- Analyze tech stack
- Review existing architectural decisions in `docs/adr/`
- Identify the research topic from `$ARGUMENTS` (default: best practices)

## Phase 2: Web Research (Silent)

Use **WebSearch** to research the topic (minimum 3 sources):

- Topic-specific information and recommendations
- Similar implementation examples
- Official documentation
- Common pitfalls and anti-patterns

## Phase 3: Output

### Technical Context

- Detected tech stack
- Related architectural decisions

### Research: ${topic}

| Category | Finding | Rationale | Source |
| -------- | ------- | --------- | ------ |
| ...      | ...     | ...       | ...    |

### Applicability

**Recommended:**

- Findings that align well with current codebase

**Consider:**

- Findings that need evaluation

**Not Recommended:**

- Findings that don't fit current context

### Trade-offs

Explain trade-offs for key findings.

### References

- [Title](URL) - Brief description
