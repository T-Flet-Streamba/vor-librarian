# Vor Librarian

Vor Librarian is a **remote Cursor skill** backed by this repository. It gives developers documentation-aware AI workflows: implementation plans, stakeholder answers, documentation creation and updates, and agent implementation with pull requests—all grounded in standardized `docs/` folders in project repos.

You **do not need to clone this repository** to use it.

## How it works

```text
Install (one-liner)  →  Local skill (SKILL.md + vor-librarian.json)
                              ↓
Invoke @vor-librarian in Cursor
                              ↓
Agent fetches skill/remote/entrypoint.md from GitHub (gh api)
                              ↓
Agent fetches the right files from prompts/ on GitHub
                              ↓
Agent works in your open project (especially its docs/ tree)
```

- **Install once** (or again if the installed `SKILL.md` contract changes): a small directory is written under your Cursor skills path.
- **Each invocation**: the agent downloads current orchestration and prompts from `streamba/vor-librarian` on the branch configured in `vor-librarian.json` (default `master`). No `git pull` on your machine.
- **Your project** stays the workspace; vor-librarian only supplies instructions and standards.

## Modes

| Mode | Purpose | Remote prompt files (fetched in order) |
|------|---------|----------------------------------------|
| **Plan** (default) | Implementation plan using `docs/` | `plan_mode_prompt.md`, `docs_consumer_prompt.md` |
| **Ask** | Plain-language / feasibility answers | `ask_mode_prompt.md`, `docs_consumer_prompt.md` |
| **Create docs** | Scaffold `docs/` from scratch | `create_docs_mode_prompt.md`, `docs_maintainer_prompt.md` |
| **Update docs** | Update docs after a code change | `update_docs_mode_prompt.md`, `docs_maintainer_prompt.md` |
| **Agent** | Implement work and open a PR | `agent_mode_prompt.md`, `docs_consumer_prompt.md` |

Mode selection is described in `skill/remote/entrypoint.md` (fetched automatically when you use the skill). The installed `SKILL.md` also summarizes when to use each mode.

## Prerequisites

- [Cursor](https://cursor.com) with agent / skills support
- [GitHub CLI](https://cli.github.com/) (`gh`) with `gh auth login` (public and private repos)
- PowerShell 5.1+ on Windows, or bash on macOS/Linux, for install only

## Install

### Windows (recommended)

```powershell
gh api repos/streamba/vor-librarian/contents/scripts/install.ps1?ref=master -H "Accept: application/vnd.github.raw" | powershell -NoProfile -ExecutionPolicy Bypass -
```

### macOS / Linux

```bash
gh api repos/streamba/vor-librarian/contents/scripts/install.sh?ref=master -H "Accept: application/vnd.github.raw" | bash
```

### Install options

Pass arguments after the one-liner (bash example):

```bash
gh api repos/streamba/vor-librarian/contents/scripts/install.sh?ref=master -H "Accept: application/vnd.github.raw" | bash -s -- --project
```

| Flag | Default | Meaning |
|------|---------|---------|
| *(none)* | personal | Install to `~/.cursor/skills/vor-librarian/` (all projects) |
| `--project` | — | Install to `.cursor/skills/vor-librarian/` in the current directory |
| `--ref` | `master` | Branch or tag for GitHub API fetches |
| `--repo` | `streamba/vor-librarian` | Repository owner/name (forks, mirrors) |

PowerShell (when running the script file directly):

```powershell
.\scripts\install.ps1              # personal
.\scripts\install.ps1 -Project     # project-local
.\scripts\install.ps1 -Ref v1.0.0  # pin to a tag
```

### What gets installed

| File | Role |
|------|------|
| `SKILL.md` | Cursor skill: modes, repo/ref resolution, fetch entrypoint and prompts via `gh` |
| `vor-librarian.json` | Local config: `repo`, `ref`, install metadata |

Default source: **`streamba/vor-librarian`** on ref **`master`**.

## Using the skill

1. Open the **project repository** you want to work on (the one with or without a `docs/` folder).
2. In Cursor, invoke the skill (e.g. **@vor-librarian**).
3. Describe what you need—for example:
   - *“Plan how to add rate limiting using our docs.”* → **Plan**
   - *“Can we support SSO for enterprise customers?”* → **Ask**
   - *“Update docs for everything merged since last release.”* → **Update docs**
4. The agent loads remote prompts and applies them to your workspace.

## Updates

| What changed | What you do |
|--------------|-------------|
| Prompts or `entrypoint.md` on `master` | Nothing—next skill use fetches the latest |
| Installed `SKILL.md` contract | Re-run the install one-liner |
| Test a feature branch (maintainers) | Edit installed `vor-librarian.json` (`repo` / `ref`) or reinstall with `--ref` |

### Maintainer: test another branch

Edit the installed config (personal install path shown):

`%USERPROFILE%\.cursor\skills\vor-librarian\vor-librarian.json` (Windows)  
`~/.cursor/skills/vor-librarian/vor-librarian.json` (macOS/Linux)

Example:

```json
{
  "repo": "streamba/vor-librarian",
  "ref": "feature/my-branch",
  "installScope": "personal"
}
```

**Repo/ref resolution order** (used by the skill): `repo` / `ref` in `vor-librarian.json` → defaults in `SKILL.md`.

## Troubleshooting

| Problem | Things to check |
|---------|------------------|
| 404 on fetch | Branch exists and is pushed; `ref` in `vor-librarian.json` is correct |
| Auth errors | Run `gh auth login`; confirm your account can read the repo (private repos need access) |
| `gh` not found | Install [GitHub CLI](https://cli.github.com/) |
| Skill not listed | Install path; restart Cursor; confirm `SKILL.md` is under `.cursor/skills/vor-librarian/` |
| Wrong project context | Open the target repo in Cursor before invoking the skill |

## What you do not need to do

- Clone `vor-librarian` into each project
- Copy files from `prompts/` into your app repos
- Run `git pull` to refresh prompts (unless you are developing vor-librarian itself)

## For maintainers

- Edit **`prompts/`** for shared standards and mode instructions (including `agent_mode_prompt.md`).
- Edit **`skill/remote/entrypoint.md`** for mode routing (which prompt files to load).
- Edit **`skill/local/SKILL.md`** when changing install-time skill behavior or mode summary (users must reinstall).
- See **`skill/local/vor-librarian.json.example`** for the installed config schema.
- **`container/`** holds a future Docker image that `COPY`s the same `prompts/` and `skill/remote/` trees; not used by end-user install.

## Repository layout

```text
prompts/              # Canonical prompt files (single source of truth)
skill/local/          # SKILL.md installed to users' machines (local skill)
skill/remote/         # entrypoint.md — fetched on every skill use
scripts/              # install.ps1, install.sh (remote one-liner entrypoints)
container/            # Future containerized runtime
```
