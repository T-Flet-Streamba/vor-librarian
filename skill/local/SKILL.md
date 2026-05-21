---
name: vor-librarian
description: >-
  Documentation-aware workflows for Cursor: implementation plans (Plan), stakeholder
  answers (Ask), scaffolding or updating docs/ (Create docs, Update docs), and
  implementation with PRs (Agent). Loads prompts from streamba/vor-librarian remotely.
  Use when the user invokes vor-librarian, @vor-librarian, or asks for doc-backed
  planning, documentation maintenance, or feasibility answers using project docs/.
disable-model-invocation: true
---

# Vor Librarian

Vor Librarian connects Cursor to shared prompts and orchestration hosted in **streamba/vor-librarian**. On each invocation, fetch remote instructions from GitHub, then work in the **user's open project** (especially its `docs/` tree).

## Resolve repo and ref

Determine which GitHub repository and ref to fetch from:

1. `repo` and `ref` in `vor-librarian.json` in this skill directory (same folder as this file)
2. Fallback: `streamba/vor-librarian` and `master`

Maintainers may edit `vor-librarian.json` locally to test another branch without reinstalling.

## Fetch files from GitHub

Use the **GitHub CLI** (`gh`). The user must have run `gh auth login` with access to the configured repo (works for public and private repos).

For a repository file at path `PATH` (e.g. `skill/remote/entrypoint.md`):

```bash
gh api "repos/{repo}/contents/PATH?ref={ref}" -H "Accept: application/vnd.github.raw"
```

Replace `{repo}` and `{ref}` with the resolved values. Run via the shell tool; read the full stdout before continuing.

## Execution workflow

1. Fetch `skill/remote/entrypoint.md` in full. Do not continue until you have read the entire file. If the fetch fails, stop and report the repo, ref, and path.
2. Follow `entrypoint.md` for mode selection, loading prompts, workspace scope, and deliverables.

## Fetch failures

If `gh` is missing, returns 404, auth errors, or network failure, stop. Report the repo, ref, and path. Suggest `gh auth login` and checking `repo` / `ref` in `vor-librarian.json`.


