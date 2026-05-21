# Vor Librarian — entrypoint

You have been invoked via the vor-librarian skill. Use the **repo** and **ref** already resolved by the skill (from `vor-librarian.json` or defaults). All paths below are repository-relative file paths.

Fetch every referenced file **in full** before proceeding. Use the GitHub CLI:

```bash
gh api "repos/{repo}/contents/PATH?ref={ref}" -H "Accept: application/vnd.github.raw"
```

Replace `{repo}`, `{ref}`, and `PATH` for each file. Requires `gh auth login`.

## Mode selection

Determine which mode applies from the user's request. If unclear, default to **Plan**.

| Mode | When to use | Fetch these prompts (in order) |
|------|-------------|--------------------------------|
| **Plan** (default) | Developer wants an implementation plan using project docs | `prompts/plan_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |
| **Ask** | Non-technical question, feasibility, plain-language answer | `prompts/ask_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |
| **Create docs** | Scaffold `docs/` from scratch in a repo | `prompts/create_docs_mode_prompt.md`, then `prompts/docs_maintainer_prompt.md` |
| **Update docs** | Update docs after a change (PR, diff, date anchor) | `prompts/update_docs_mode_prompt.md`, then `prompts/docs_maintainer_prompt.md` |
| **Agent** | Implement changes on a branch and open a PR | `prompts/agent_mode_prompt.md`, then `prompts/docs_consumer_prompt.md` |

For each file in the appropriate table row, fetch with `gh api` using that path.

Example for **Plan**:

1. `gh api "repos/{repo}/contents/prompts/plan_mode_prompt.md?ref={ref}" -H "Accept: application/vnd.github.raw"`
2. `gh api "repos/{repo}/contents/prompts/docs_consumer_prompt.md?ref={ref}" -H "Accept: application/vnd.github.raw"`

## After loading prompts

1. Apply the mode-specific instructions from the fetched prompt files.
2. Use the **current workspace** as the target repository unless the user names another.
3. Read and use the target repo's `docs/` tree (`product/`, `technical/`, `history/`, `future/`, and optional `extras/` under each) when it exists.
4. Honor the user's concrete request (scope, constraints, output format) on top of the loaded prompts.

## Plan output (default mode)

When in **Plan** mode, produce a structured implementation plan (e.g. `plan.md` or in chat) covering: affected repos/files, step-by-step changes with rationale, edge cases/risks, and suggested PR breakdown—unless the user asks for a different format.

## Ask output

When in **Ask** mode, produce a plain-language answer (e.g. `answer.md` or in chat) per `ask_mode_prompt.md`.

## Create docs / Update docs output

When in **Create docs** or **Update docs** mode, follow the maintainer and mode prompts for documentation structure, PRs, and placeholders.

## Agent output

When in **Agent** mode, implement on a feature branch and open a PR per `agent_mode_prompt.md`, using `docs/` for orientation unless the user scopes otherwise.


