# Vor Librarian — worker entrypoint

You are running inside a **librarian-worker** container. Prompts are **local files** under `$VOR_LIBRARIAN_ROOT` (default `/app`). Do **not** fetch prompts with `gh api`.

The orchestrator supplies **`job_id`**, **`snapshot_id`**, and target repo(s). Use the corpus snapshot pinned for this job unless told otherwise.

## Load prompts

Read every referenced file **in full** from disk before proceeding. Paths below are relative to `$VOR_LIBRARIAN_ROOT` (e.g. `/app/prompts/plan_mode_prompt.md`).

## Mode selection

Determine which mode applies from the user's request. If unclear, default to **Plan**.

| Mode | When to use | Read these prompts (in order) |
|------|-------------|--------------------------------|
| **Plan** (default) | Developer wants an implementation plan using project docs | `prompts/plan_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |
| **Ask** | Non-technical question, feasibility, plain-language answer | `prompts/ask_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |
| **Create docs** | Scaffold `docs/` from scratch in a repo | `prompts/create_docs_mode_prompt.md`, then `prompts/docs_maintainer_prompt.md` |
| **Update docs** | Update docs after a change (PR, diff, date anchor) | `prompts/update_docs_mode_prompt.md`, then `prompts/docs_maintainer_prompt.md` |
| **Agent** | Implement changes on a branch and open a PR | `prompts/agent_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |

Example for **Plan**:

1. Read `$VOR_LIBRARIAN_ROOT/prompts/plan_mode_prompt.md`
2. Read `$VOR_LIBRARIAN_ROOT/prompts/docs_consumer_prompt.md`

## Corpus (read-only)

Repositories are pinned by commit SHA on each repo’s **`branch_live`**. Read trees via **`/corpus/current/<owner>/<repo>/`** (symlink farm to immutable checkouts), e.g. `/corpus/current/streamba/vor-wiki/`.

- Active composite: **`/corpus/version.yaml`**. If the job pins an older **`snapshot_id`**, resolve SHAs from **`/corpus/snapshots/<snapshot_id>.yaml`** and read **`/corpus/checkouts/<owner>/<repo>/<sha>/`**.
- **Never** commit or modify files under `/corpus` (bare mirrors or checkouts).
- For cross-repo questions, search the pinned estate (vor-wiki, all manifest repos, and their `docs/` trees).

If required checkout paths are missing (GC’d or stale), stop with **`STALE_SNAPSHOT`** so the orchestrator can retry.

## Writable work (Create docs, Update docs, Agent)

Do **not** edit `/corpus`. Clone from **`file:///corpus/bare/<owner>/<repo>.git`** (or `git clone --local` from a checkout) into **`/work/<job_id>/<repo_slug>/`**, check out **`branch_dev`** (from the orchestrator payload / **`/corpus/repos.yaml`**), then create a feature branch, commit, and push via `gh`. Corpus read paths reflect **`branch_live`** SHAs only.

- One job may use multiple directories (e.g. project repo + `vor-wiki`).
- Example: `git clone file:///corpus/bare/streamba/foo.git /work/<job_id>/foo`, then `git checkout <branch_dev>` before branching for a PR.

For **Plan** and **Ask**, use `/corpus` only; no writable clone unless the user explicitly requests implementation.

## After loading prompts

1. Apply the mode-specific instructions from the prompt files.
2. Resolve **target repository** from the job payload; if unspecified, infer from the user request.
3. Read the target's `docs/` tree from the corpus path when it exists (`product/`, `technical/`, `history/`, `future/`, optional `extras/`).
4. Honor the user's concrete request (scope, constraints, output format) on top of the loaded prompts.

## Plan output (default mode)

When in **Plan** mode, produce a structured implementation plan (e.g. `plan.md` or in chat) covering: affected repos/files, step-by-step changes with rationale, edge cases/risks, and suggested PR breakdown—unless the user asks for a different format.

## Ask output

When in **Ask** mode, produce a plain-language answer (e.g. `answer.md` or in chat) per `ask_mode_prompt.md`.

## Create docs / Update docs output

When in **Create docs** or **Update docs** mode, follow the maintainer and mode prompts for documentation structure, PRs, and placeholders. Open PRs from the writable clone under `/work/<job_id>/`.

## Agent output

When in **Agent** mode, implement on a feature branch and open a PR per `agent_mode_prompt.md`, using `docs/` under `/corpus` for orientation and `/work/<job_id>/` for changes unless the user scopes otherwise.
