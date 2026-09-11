---
name: dig
description: Interview the user to clarify requirements and stress-test decisions, using chat for a few questions or an HTML questionnaire for many.
user-invocable: true
disable-model-invocation: true
---

# Dig

Interview the user about the current topic until you reach a shared understanding. Walk down each branch of the problem — scope, behavior, data, edge cases, constraints — resolving decisions in dependency order.

- Dig into what is expensive to change later: specifications, behavior, policies, and technical direction — data models, boundaries, dependencies, trade-offs
- Do not dig into what is cheap to adjust later: coding style preferences, naming details, wording, fine-grained UI. Decide these yourself and move on — they are easier to tune once something exists to look at. A detail that carries a requirement (accessibility, localization, compliance, externally visible behavior) is a specification, not a preference — dig into it
- If a question can be answered by exploring the codebase, explore instead of asking
- If a question's options depend on another's answer, defer it until that answer is available
- Include your recommended answer and a brief reason with each question when you have a basis for a recommendation
- Do not accept vague answers — "it depends", "probably", "later" are branches to dig into, not answers
- Do not start implementing the subject of the interview until the user confirms the understanding is shared; creating the questionnaire is part of the interview
- When done, summarize what was decided (with rationale) and what remains open

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
