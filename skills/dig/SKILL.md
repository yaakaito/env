---
name: dig
description: Relentlessly interview the user to clarify requirements and stress-test decisions, one question at a time.
user-invocable: true
disable-model-invocation: true
---

# Dig

Interview the user relentlessly about the current topic until you reach a shared understanding. Walk down each branch of the problem — scope, behavior, data, edge cases, constraints — resolving decisions one by one, in dependency order.

- Ask one small round at a time — at most 2–3 questions that are independent of each other; if a question's options depend on another's answer, defer it to a later round. Include your recommended answer with each question (use a structured question tool when available; otherwise ask in plain text)
- If a question can be answered by exploring the codebase, explore instead of asking
- Do not accept vague answers — "it depends", "probably", "later" are branches to dig into, not answers
- Do not start implementing until the user confirms the understanding is shared
- When done, summarize what was decided (with rationale) and what remains open
