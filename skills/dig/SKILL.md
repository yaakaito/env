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

Build the questionnaire from [assets/questionnaire.html](assets/questionnaire.html); do not write the page layout, styles, or script yourself. The template already groups questions by topic, shows answered/total progress, accepts custom answers and additional context, marks recommendations without selecting them, and copies all questions and answers as one text block with a selectable fallback.

- Copy the template to a new file outside the repository, such as the system temp directory, then replace the `__QUESTIONNAIRE_JSON__` line with the round's data. Escape every `<` in the JSON as `\u003c`
- Data shape: `{"title": string, "round": number, "description"?: string, "questions": [...]}`. Each question has `id` (1 to the question count, in presentation order), `topic`, `text`, `type`, optional `recommended`, optional `reason`, and optional `description`
  - `"type": "select"` with `options` (array of label strings) for choices; the template adds an "other" free-text choice
  - `"type": "text"` for open-ended answers
  - `description` at the top level or on a question is inserted as HTML, above the questions or below the question text. Use it for context the plain-text fields cannot carry, such as tables, diagrams (inline SVG), or code samples; omit it otherwise
- Link the generated file without running functional tests or browser checks
- Wait for the pasted answers, then recompute the frontier and choose the next round's format by the same rules
