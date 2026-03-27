---
name: epic
description: Epic feature development — break a large feature into phased stories, then execute each phase via /feature. Use when building multi-phase features, large initiatives, or features that span multiple components/layers.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Agent, AskUserQuestion, Skill
user-invocable: true
argument-hint: <epic description>
---

# Epic — Multi-Phase Feature Development

Break a large feature into phased stories, then develop each phase end-to-end via `/feature`.

**Flow**: Analyze → Plan Phases → User Approval → Execute Each Phase (via /feature) → Epic Report

**STOP on any failure** — do not continue to the next phase if the current one fails.

## Critical Rules

1. **NEVER skip user approval of the phase plan** — the user MUST approve before execution starts
2. **Each phase is a self-contained deliverable** — it must compile, pass tests, and be shippable on its own
3. **Phases build on each other** — later phases depend on earlier ones, never the reverse
4. **Use /feature for every phase** — do NOT implement phases manually
5. **All code, comments, and docs MUST be in English**
6. **Max 5 phases** — if the epic needs more, suggest splitting into multiple epics

---

## Phase 1: Analyze the Epic

Before planning anything:

1. Read the epic description provided as argument
2. Explore the codebase to understand the current state:
   - Which modules/files are relevant?
   - What patterns and abstractions already exist?
   - What infrastructure is in place that can be reused?
3. Identify the major components/layers the epic touches
4. Identify risks, dependencies, and unknowns

Produce a brief **Epic Analysis** (5-10 bullet points):

```
EPIC ANALYSIS
=============
Epic:         <name>
Components:   <list of modules/layers touched>
Dependencies: <external deps, APIs, services needed>
Risks:        <unknowns, breaking changes, performance concerns>
Reuse:        <existing code/patterns to build on>
```

---

## Phase 2: Plan the Phases

Break the epic into 2-5 ordered phases. Each phase must be:

- **Self-contained**: passes tests, works independently
- **Incremental**: adds value on top of previous phases
- **Focused**: one clear goal per phase
- **Testable**: clear acceptance criteria

Present the plan in this format:

```
EPIC PLAN
=========
Epic: <name>
Phases: <count>

Phase 1: <title>
  Goal:     <one sentence>
  Scope:    <files/modules to create or modify>
  Depends:  <nothing, or previous phase>
  Criteria: <how to verify it works>

Phase 2: <title>
  Goal:     <one sentence>
  Scope:    <files/modules to create or modify>
  Depends:  Phase 1
  Criteria: <how to verify it works>

Phase 3: <title>
  ...
```

### Phase ordering strategy

Follow this order when breaking down:

1. **Core/data model** — types, schemas, database changes
2. **Backend logic** — business logic, API endpoints, services
3. **Integration** — wiring into existing systems, events, hooks
4. **Frontend/UI** — user-facing components, dashboard updates
5. **Polish** — docs, config, DX improvements, edge cases

Not every epic needs all 5 layers. Skip what doesn't apply.

---

## Phase 3: User Approval

Present the full plan to the user via `AskUserQuestion`:

- Show the Epic Analysis and Phase Plan
- Ask: "Does this phase breakdown look good?"
- Options: "Approved — start execution", "Needs changes", "Cancel epic"

### If "Needs changes":
1. Ask what to adjust (add/remove/reorder phases, change scope)
2. Update the plan
3. Ask again — **repeat until approved** (max 3 iterations)

### If "Cancel epic":
STOP and report. No changes made.

### If "Approved":
Continue to Phase 4.

---

## Phase 4: Execute Phases

For each phase in order, invoke the `/feature` skill:

### Before each phase:

1. Announce: `Starting Phase X of Y: <title>`
2. Prepare the feature description for `/feature` by combining:
   - The phase goal and scope from the plan
   - Context from previous phases (what was already built)
   - The acceptance criteria

### Invoke /feature:

Call the `feature` skill with a clear, detailed description:

```
Phase X of Epic "<epic name>": <phase title>

Goal: <phase goal>

Context: <what previous phases built — files created, APIs added, etc.>

Scope:
- <specific file/module 1>: <what to do>
- <specific file/module 2>: <what to do>

Acceptance criteria:
- <criterion 1>
- <criterion 2>
```

### After each phase:

1. Verify the phase completed successfully (tests pass, code committed)
2. Record what was built (files, APIs, abstractions) for context in next phases
3. Announce: `Phase X complete. Moving to Phase X+1.`

### If a phase fails:

1. Report which phase failed and why
2. Ask the user: "Retry this phase, skip it, or abort the epic?"
3. If retry: re-invoke `/feature` with adjusted description
4. If skip: mark as skipped, continue to next phase (warn about missing dependency)
5. If abort: STOP and produce partial report

---

## Phase 5: Epic Report

After all phases complete (or on abort), produce:

```
EPIC REPORT
===========
Epic:        <name>
Phases:      X/Y completed
Duration:    <phases executed>

Phase Results:
  Phase 1: <title> ............. [DONE]
    Files: <count> modified, <count> created
    Commit: <hash> <message>

  Phase 2: <title> ............. [DONE]
    Files: <count> modified, <count> created
    Commit: <hash> <message>

  Phase 3: <title> ............. [SKIPPED/FAILED/DONE]
    ...

Summary:
  Total files changed: <count>
  Total tests added:   <count>
  Docs updated:        <list>
  All tests passing:   [YES/NO]
```

---

## Example Usage

```
/epic Add per-session sandbox workspace with live preview

/epic Implement multi-tenant RBAC with OAuth2 and API key auth

/epic Add real-time collaborative editing for graph builder
```

Each of these would be broken into 2-5 phases and executed sequentially via `/feature`.
