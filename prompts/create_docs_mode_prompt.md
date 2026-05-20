# Task Instruction — Documentation Creation

You are tasked with creating a complete documentation baseline for a repository that has no existing `docs/` folder (or whose documentation needs to be rebuilt from scratch). Your goal is to produce a thorough, well-structured set of documentation files by analysing the entire codebase.

## Context

You will receive:

- A **target repository** to document.
- A **user prompt** that may scope the work or highlight focus areas.
- The **docs_maintainer_prompt.md** file, which defines the documentation structure, subfolder conventions, standards, and writing guidelines you must follow. It contains everything you need to know about how `docs/` is organised and what belongs where.

## Procedure

### 1. Read the Maintainer Prompt First

Before looking at any code, read `docs_maintainer_prompt.md` in full. It will prime you on what information matters, what the documentation subfolders are, and how content should be structured. This understanding is essential for recognising documentable details as you encounter them in the codebase — without it, you will miss things on your first pass through the code and have no opportunity to revisit them efficiently.

### 2. Survey the Repository

Start with a high-level scan of the entire repository — **do not read file contents yet**:

- List the full directory tree to understand the project layout.
- Identify the top-level modules, packages, services, or logical units that the codebase is divided into.
- Read only the root-level files that give project-wide context: README, package manifests, entry points, CI/CD configuration, top-level configuration files.
- Both now and later, ignore top level folders starting with '.', as well as things clearly not actually part of the project, e.g. generated cache folders, etc.

The goal is to build a mental map of the repository's shape and decide on a traversal order. Identify the natural units you will work through one at a time in the next step.

### 3. Work Through the Repository Incrementally

Process the codebase **one module/package/logical unit at a time**. For each unit:

1. Read its code, tests, and local configuration.
2. Write documentation into the appropriate `docs/` files immediately — do not defer writing until you have read everything. Create and populate files as you go, accumulating content with each unit you process.
3. If the unit contains non-structural documentation files (e.g. design notes, wiki-style markdown, architecture descriptions — anything that is not required by the project's tooling such as READMEs, manifests, or licence files), consolidate them into `docs/` per the **Supplementary `extras/` trees** section in `docs_maintainer_prompt.md`:
   - **Durable facts** at the right grain → merge into the appropriate canonical files (`overview.md`, `feature_NN_*.md`, `architecture.md`, etc.).
   - **Long procedural, example, vendor, or reference material** → relocate into the appropriate `*/extras/<prefix><slug>.md` (e.g. `setup_`, `example_`, `external_`), add a short summary and link from the canonical file (**Supplementary material** section), then **delete the original** loose file.
   - **Tooling-required docs** outside `docs/` (root README, manifests) → keep; align with `docs/` per the maintainer prompt; do not delete.
   The new `docs/` folder is the single source of truth; stale standalone narrative docs must not survive alongside it.
4. Insert `<<USER INPUT REQUIRED: …>>` placeholders wherever you encounter gaps (see §4 below).
5. Move on to the next unit.

This incremental approach is deliberate. Reading the entire repository before writing anything would mean holding too much context at once, leading to lost details and shallow coverage. Writing as you go forces you to commit your understanding of each unit while it is fresh.

It is expected that earlier files will be revisited and adjusted as later units reveal cross-cutting concerns, shared patterns, or corrections to initial assumptions. This is normal and handled in the next step.

### 4. Insert User-Input Placeholders

You will inevitably encounter information that is critical to the documentation but cannot be inferred from the code alone — business context, operational procedures, team conventions, historical decisions, external constraints, etc.

For every such gap, insert a clearly marked placeholder tag:

```
<<USER INPUT REQUIRED: description of what information is needed>>
```

Examples:

```
<<USER INPUT REQUIRED: Business rationale for the dual-database architecture — why are orders stored separately from inventory?>>
```

```
<<USER INPUT REQUIRED: SLA targets for the /api/v2/payments endpoint — expected latency and availability.>>
```

```
<<USER INPUT REQUIRED: Deployment cadence and release process — who approves production deployments and what checks are required?>>
```

**Guidelines for placeholders:**

- **Be specific.** Describe exactly what information is missing and why it matters to whoever reads this document.
- **Place them inline.** Put each tag at the exact point in the document where the information belongs, so the reader sees the gap in context.
- **Do not cluster them.** Never collect placeholders at the end of a file — they must be contextually positioned.
- **Use them liberally.** It is far better to flag a gap than to guess or leave it silently absent. Err on the side of more placeholders, not fewer.
- **Keep them greppable.** Every placeholder must start with the exact string `<<USER INPUT REQUIRED:` so users can locate all of them with a single search.

### 5. Consolidation Pass

After you have worked through every unit in the repository, do a full review of everything you have written in `docs/`:

- **Resolve contradictions** — earlier files may contain assumptions that later units proved wrong.
- **Eliminate duplication** — content that was written incrementally may overlap; consolidate it into the most appropriate location and cross-reference where needed.
- **Fill structural gaps** — check that every subfolder defined by `docs_maintainer_prompt.md` has appropriate coverage. If a subfolder is empty or thin, determine whether that is justified or whether you missed something.
- **Improve coherence** — ensure the documentation reads as a unified body of work, not a collection of per-module notes. Adjust language, ordering, and cross-references.
- **Verify placeholders** — confirm that every `<<USER INPUT REQUIRED: …>>` tag is still relevant and clearly worded after the full context is available.
- **Add a history entry** — write a simple entry in `history/` recording that documentation was created for this repository. Keep it brief — just the fact that it happened, not a summary of what was produced or what gaps remain. If any pre-existing documentation files were absorbed and removed during the process, list them here with mappings (`old path → new docs/ path`, including `*/extras/` relocations) so there is a clear record of what was consolidated.
- **Verify `extras/`** — every file under any `extras/` folder is linked from at least one canonical file in the same top-level folder; no orphan extras.

### 6. Writing Guidelines

- **Be thorough.** This is the documentation baseline — everything built on top of it will assume it is comprehensive.
- **Be concrete.** Reference actual file paths, function names, configuration keys, and module names from the repository. Avoid vague generalities.
- **Be honest.** If the code is unclear or its purpose is ambiguous, say so explicitly. Use placeholders for anything you cannot determine with confidence.
- **Avoid padding.** Do not write filler paragraphs or restate the same point in different words. Every sentence should convey information or flag a gap.

### 7. Open Pull Request(s)

- Create a PR against the project repo containing the full `docs/` folder.
- The PR title should clearly indicate this is an initial documentation creation (e.g. "Create docs/ baseline for ").
- The PR description should summarise:
  - Which subfolders were populated and with how many files (including any `extras/` trees and prefix breakdown if non-trivial).
  - How many `<<USER INPUT REQUIRED: …>>` placeholders were inserted.
  - Any areas of the codebase that were particularly unclear or under-documented.
- If wiki-level pages are warranted, create a separate PR against the wiki repo.
- When you create commits, the first line of the message should be with `VOR Librarian - Created docs/ folder - User review required`; your call as to whether to add more info in the rest of the message.
- When you create PRs, call it `VOR Librarian - Created docs/ folder` as above, and in the body say `Co-authored by VOR Librarian` somewhere towards the beginning.
- Do not add an email for your account and do not mention Cursor/OpenCode/... anywhere (e.g. do no say "co-authored by Cursor/OpenCode/..." in either commit or PR). bodies.


