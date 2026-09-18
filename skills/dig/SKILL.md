---
name: dig
description: Interview the user when they request in-depth requirements clarification or decision stress-testing, using chat or an HTML questionnaire.
user-invocable: true
disable-model-invocation: true
---

# Dig

Clarify the decisions needed for the user's next step. Explore relevant scope, behavior, data, edge cases, and constraints in dependency order; stop when remaining unknowns can be explicitly deferred without changing that step.

- Dig into what is expensive to change later: specifications, behavior, policies, and technical direction — data models, boundaries, dependencies, trade-offs
- Do not dig into what is cheap to adjust later: coding style preferences, naming details, wording, fine-grained UI. Decide these yourself and move on — they are easier to tune once something exists to look at. A detail that carries a requirement (accessibility, localization, compliance, externally visible behavior) is a specification, not a preference — dig into it
- If a question can be answered by exploring the codebase, explore instead of asking
- If a question's options depend on another's answer, defer it until that answer is available
- Include your recommended answer and a brief reason with each question when you have a basis for a recommendation
- Follow up on vague answers when they affect the next decision. If the user defers a decision or delegates it to you, record that choice and its implications instead of repeatedly asking
- Interviewing alone does not authorize implementation. If the user has already asked you to implement after clarification, proceed once the necessary decisions are settled without requiring a separate confirmation. Creating the questionnaire is part of the interview
- When done, summarize decisions with rationale, any assumptions, and deferred or unresolved points. Distinguish a recommendation from the user's choice; unanswered questions and elapsed time are not approval

## Choose the question format

Count the questions currently ready to ask. As a default, use chat for up to five questions and an HTML questionnaire for six or more. Follow the user's preferred format when specified.

### A few questions: chat

- Ask one small round at a time, with at most 2–3 independent questions. Use a structured question tool when available; otherwise ask in plain text
- Prefix each question with progress such as `(1/5)`. The denominator is the currently planned question count, not a promise that no follow-up questions will arise; update it and briefly explain when new questions are added

### Many questions: HTML questionnaire

- Create and link a self-contained HTML file the user can open locally, with selection controls and free-text fields for their answers. Group questions by topic and show answered/total progress
- Allow custom answers and additional context alongside choices. Mark recommendations without treating them as submitted answers
- Include a button to copy all questions and answers as one text block for the user to paste back into the conversation. Preserve question numbers, question text, selected option labels, free-text answers, and explicit unanswered markers
- Provide a selectable text fallback if clipboard access fails
- Verify selection, text entry, progress, and answer export before delivering the file
- Wait for the pasted answers, then continue with unresolved points using the same format rules
