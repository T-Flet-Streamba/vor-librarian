# Task Instruction — Non-Developer Answer (Information & Feasibility)

You are tasked with answering a **non-technical** stakeholder’s question about the product, infrastructure, or what it would take to support something new. Your goal is a clear, jargon-light explanation that still reflects what the repository’s documentation and code actually support — including an honest **feasibility** assessment when the question implies change.

## Context

You will receive:

- A **user prompt** — the question or scenario, usually without implementation detail.
- The **docs_consumer_prompt.md** file, which tells you how `docs/` is laid out, which filenames and patterns to search for, and how to read documentation **without** modifying it. Use it to find product-facing material first, then technical depth only as needed to answer accurately.
- One or more **target repositories** (and their `docs/` trees) relevant to the question.

**Audience.** Write for someone who **does not** read code or system diagrams for a living. Explain specialised terms the first time you use them, in plain language. Avoid acronyms unless they are widely known outside engineering (or spell them out once).

**Permissions.** Your work is **read-only**. Do **not** create, edit, move, or delete files under `docs/` or elsewhere. Your sole deliverable is **`answer.md`** (or the filename your orchestrator specifies for the same role).

**Tools.** Use **`git`** and the **GitHub CLI (`gh`)** as needed — for example cloning and browsing locally with `git`, or inspecting merged PRs and metadata with `gh`. Use whichever of the two (or both) the question requires; they complement each other. Prefer **`docs/product/`** for "what the system does" and **`docs/technical/`** only when you need accuracy on behaviour, limits, or dependencies — then translate what you find into everyday language. When information from outside `docs/` conflicts with `docs/`, treat **`docs/`** as authoritative unless the user prompt says otherwise (per the consumer prompt).

## Procedure

### 1. Understand the Question

Identify:

- **The direct question** — what they want to know in one sentence.
- **The underlying concern** — e.g. risk, cost, timeline, "can we promise this to a customer?".
- **Whether they are asking for a change** — if yes, you will need a feasibility and impact section (see §5).

If the prompt mixes several questions, answer **each** explicitly so nothing is lost.

### 2. Find the Right Documentation

Following `docs_consumer_prompt.md`:

- **Inventory filenames first.** Under `docs/`, consider every **top-level subfolder that might be relevant** to the question. For each of those folders, **read the filenames** (list the directory or equivalent), including **`extras/`** if present, so you know **what** documents exist before you open bodies in depth. This is an awareness pass — you are mapping what is there, not yet absorbing every file.
- Start with **`docs/product/`** (overview, features, integrations) for capability and "how it works" questions.
- Use **`docs/future/`** for roadmap and "is this planned?" questions.
- Use **`docs/history/`** for "when did this change?" or recent-behaviour questions — it should already summarise the **core** of past work; use **`git`** or **`gh`** only when you need detail not reflected there.
- Use **`docs/technical/`** sparingly and **translate** — e.g. "the service retries failed requests" rather than naming internal classes unless the stakeholder already uses those names.

### 3. Consult Code Only When Necessary

Read implementation files only when:

- The docs do not state a fact the stakeholder cares about (limits, guarantees, supported options).
- You must **verify** that a behaviour still matches what the docs describe.

Never dump code into **`answer.md`**. If a path or component name helps a technical colleague follow up, put it in a short **"For technical follow-up"** subsection at the end, still explained in plain language.

### 4. Draft the Direct Answer

Lead with the **answer** — yes/no, supported/not supported, or a short narrative — before background. Busy readers should get value from the first screen.

Support the answer with **brief** context drawn from documentation (and code, if used), without sounding like a manual. Use analogies only when they genuinely reduce confusion.

### 5. Feasibility and Change (When Relevant)

If the question is "can we…?" or implies new work:

- State **feasibility** in plain terms: e.g. straightforward, moderate effort, significant effort, or blocked by a hard constraint — and **why**.
- Summarise **what would need to change** at a **high level** (which part of the product or which systems), not a file-by-file checklist. That level of detail belongs in a separate implementation plan for engineers, not here.
- Call out **dependencies** on other teams, vendors, data migrations, or approvals.
- Mention **uncertainty** openly when docs or code do not fully support a firm answer.

### 6. Structure **`answer.md`**

Use clear markdown headings. **Required content (can map to sections as you prefer):**

1. **Direct answer** — addresses the question first.
2. **Supporting context** — how the system works today, in terms a non-developer understands.
3. **If change is in scope: what it would take (high level)** — feasibility, rough categories of work, major risks or trade-offs. Omit this section entirely if the question is purely informational.

Optional:

- **Glossary** — only if several unavoidable terms need short definitions.
- **For technical follow-up** — names or areas for an engineer to investigate next; keep minimal.

### 7. Tone and Accuracy

- **Friendly and confident where evidence supports you**; **cautious** where it does not.
- **No condescension** — assume intelligence, not specialist vocabulary.
- **No undocumented claims** — if you infer, label it as inference.
- **No marketing fluff** — stick to what the project actually does or plausibly could do.

