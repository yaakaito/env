---
name: dig
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking or requests an in-depth interview with dig.
user-invocable: true
disable-model-invocation: true
license: MIT
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

## Answer format

Count the questions in the current frontier. As a default, use chat for up to five questions and an HTML questionnaire for six or more. Follow the user's preferred format when specified. Present the whole frontier in one round in either format; the format does not change which questions are ready to ask.

### Chat

- Present all questions in the round together. Use a structured question tool when it can present the whole round; otherwise use plain text
- Prefix each question with progress such as `(1/5)`. The denominator is the current frontier's question count, not a promise that no follow-up questions will arise. Show the round number so progress in later rounds is distinct
- Include choices and allow free-text answers and additional context. Show your recommended answer separately from the user's answer; an unanswered question is not agreement with the recommendation

### HTML questionnaire

- Create and link a self-contained HTML file the user can open locally, with selection controls and free-text fields for their answers. Group questions by topic and show answered/total progress for the current round
- Allow custom answers and additional context alongside choices. Mark recommendations without treating them as submitted answers
- Include a button to copy all questions and answers as one text block for the user to paste back into the conversation. Preserve question numbers, question text, selected option labels, free-text answers, and explicit unanswered markers
- Provide a selectable text fallback if clipboard access fails
- Verify selection, text entry, progress, and answer export before delivering the file
- Wait for the pasted answers, then recompute the frontier and choose the next round's format by the same rules
