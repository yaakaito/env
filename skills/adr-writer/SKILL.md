---
name: adr-writer
description: Create, update, or review Architecture Decision Records (ADRs) using the project's conventions. Use when asked to record an architecture decision or work on an ADR; not for general design discussion without a requested record.
---

# ADR Writer

Record the context, decision, consequences, and considered alternatives so readers can understand why the architecture was chosen.

## Project Conventions

Follow the user's requested format and the project's ADR conventions for location, naming, numbering, language, and structure. Inspect the target ADR, relevant existing ADRs, and any project template as needed to establish those conventions and understand the decision. Do not require a fixed number of documents or read unrelated ADRs.

When no convention exists, use `docs/adr/adr-NNN-short-description-in-english.md` with the next number after the highest existing ADR number (start at `001` if none exist), an English title, and Japanese body text under English section headings. Use [assets/adr-example.md](assets/adr-example.md) as the fallback template; load it only when creating an ADR without a project template.

## Decision and Status

Use the conversation and relevant project evidence to distinguish a proposal from an approved decision. Do not infer approval from a request to write an ADR. For a new ADR with no approval evidence, use the project's proposal status or `Proposed` if none is defined. Use `Approved` or the project's equivalent only when approval is established.

When editing an existing ADR, preserve its status and recorded decision unless the request or evidence supports changing them. If a decision is being replaced, follow the project's superseding convention and preserve the original rationale and links between records. Ask only when missing decision details prevent an accurate record; identify unresolved details rather than inventing them.

## Content

- Context explains why the decision is needed, using known facts and constraints.
- Decision states the chosen or proposed approach specifically enough to guide implementation. Include diagrams or language-agnostic pseudocode when they clarify the design; do not include implementation-specific code.
- Consequences describe benefits, drawbacks, trade-offs, and relevant side effects.
- Alternatives include options actually considered and the known reasons for not adopting them. Mark missing rationale as unknown rather than fabricating a comparison.
- References link to relevant ADRs and source material supporting the record.

## Completion

For creation or editing, save the requested ADR and check its numbering, links, status, and consistency with project conventions and the supplied decision. For a review-only request, report findings without changing files. Report unresolved decision details that affect the record's accuracy.
