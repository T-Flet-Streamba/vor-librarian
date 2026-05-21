# Vor Librarian

Vor Librarian is both a **Cursor skill** backed by this repository and soon it will also be a **remote service** using the same skill and prompts, with visibility across **all VOR projects and their documentation at once**—not only the repo open in your editor.
For the skill version, you install a small local skill (`SKILL.md`) that orchestrates documentation-aware AI processes in whatever project you have open.

Those processes include implementation plans, stakeholder answers, documentation creation and updates, and agent implementation with pull requests—all grounded in standardized `docs/` folders in project repos.

You **do not need to clone this repository** to use the skill or the service (only maintainers would clone it).

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
- [GitHub CLI](https://cli.github.com/) (`gh`) — then run `gh auth login` (needed for public and private repos)

  **Windows**

  ```powershell
  winget install --id GitHub.cli --source winget
  ```

  **macOS**

  ```bash
  brew install gh
  ```

  **Linux (Debian / Ubuntu)**

  Other Linux distros and package managers: [GitHub CLI installation](https://github.com/cli/cli#installation).


## Install

Log into `gh` first if not already done so, then run the installation oneliner for your OS (see the install options below to decide whether to use the option-passing oneliners).
```bash
gh auth login
```

### Windows

```powershell
gh api repos/streamba/vor-librarian/contents/scripts/install.ps1?ref=master -H "Accept: application/vnd.github.raw" | powershell -NoProfile -ExecutionPolicy Bypass -
```

**Oneliner with options** (append switches after the closing brackets; the one in this example installs it to the current repo):

```powershell
& ([scriptblock]::Create(((gh api repos/streamba/vor-librarian/contents/scripts/install.ps1?ref=master -H "Accept: application/vnd.github.raw") -join "`n"))) -Project
```

(The `-join` is required because `gh` returns one string per line).
Add other switches on the same line instead or after `-Project`, e.g. `-Ref dev` or `-Repo your-org/vor-librarian`.

### macOS / Linux

```bash
gh api repos/streamba/vor-librarian/contents/scripts/install.sh?ref=master -H "Accept: application/vnd.github.raw" | bash
```

**Oneliner with options** (append flags after `bash -s --`; the flag in this example installs it to the current repo):

```bash
gh api repos/streamba/vor-librarian/contents/scripts/install.sh?ref=master -H "Accept: application/vnd.github.raw" | bash -s -- --project
```

### Install options

| Switch (PowerShell) | Flag (bash) | Default | Meaning |
|---------------------|-------------|---------|---------|
| *(none)* | *(none)* | personal | Install to `~/.cursor/skills/vor-librarian/` (all projects) |
| `-Project` | `--project` | — | Install to `.cursor/skills/vor-librarian/` in the current directory |
| `-Ref` | `--ref` | `master` | Branch or tag for GitHub API fetches |
| `-Repo` | `--repo` | `streamba/vor-librarian` | Repository owner/name (forks, mirrors) |

If you are a maintainer and cloned this repository, you can of course run the script directly:

```powershell
.\scripts\install.ps1              # personal
.\scripts\install.ps1 -Project     # project-local
.\scripts\install.ps1 -Ref v1.0.0  # pin to a tag/branch
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
   - *"Plan how to add rate limiting using our docs."* → **Plan**
   - *"Can we support SSO for enterprise customers?"* → **Ask**
   - *"Update docs for everything merged since last release."* → **Update docs**
4. The agent loads remote prompts and applies them to your workspace.

## Updates

| What changed | What you do |
|--------------|-------------|
| Prompts or `entrypoint.md` on `master` | Nothing; the next skill use will fetch the latest |
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

- Clone `vor-librarian`
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
skill/worker/         # entrypoint.md — used by librarian-worker containers (local prompts)
scripts/              # install.ps1, install.sh (remote one-liner entrypoints)
container/            # Future containerized runtime
```

