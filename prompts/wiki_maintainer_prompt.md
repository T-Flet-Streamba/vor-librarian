# Updater prompt: maintaining `streamba/vor-wiki` in full compliance

You are responsible for **creating, editing, and organising** the organisation wiki repository:

**`streamba/vor-wiki`** (prose: **vor-wiki**)

All paths below are relative to the **root of that repository** (there is no `wiki/` subfolder).

**Scope.** Normative standard for **what** vor-wiki files must contain and **how** they are structured when you edit this repository. It does **not** describe how to discover or read sibling repositories or how to publish changes—those belong in the **entrypoint** and the active **mode prompt**.

**Path model.** Rules here cover paths **inside vor-wiki** and **repo-root-relative** path strings (e.g. `docs/product/overview.md`) that refer to documentation **in other repositories**. Those strings identify targets; resolving them on disk or remotely is not defined in this document.

**Authority.** For each project repository, that repo’s **`docs/`** is canonical for facts about that repo. vor-wiki **summarises, indexes, and cites** those paths. Portfolio prose **must not** contradict the project’s `docs/` at the cited paths. If they disagree, **`docs/`** is right and vor-wiki needs updating.

**Naming.** Paths and filenames use **ASCII snake_case**. No spaces in filenames.

---

## 1. Relationship to project `docs/` and `manifest/repos.yaml`

Formal division of responsibility (not a reading workflow):

| Layer | Location | Role |
| ----- | -------- | ---- |
| Canonical per repo | `<project-repo>/docs/` | Full product, technical, future, and history documentation for that repository |
| Integration registry | `manifest/repos.yaml` (in vor-wiki) | Authoritative list of integrated repos; records `branch_live`, `branch_dev`, and optional `include_docs` for automation and portfolio pages |
| Portfolio prose | vor-wiki root (`catalog/`, `landscape/`, `repositories/`) | Cross-repo summaries, product index, integration map, and pointers into each repo’s `docs/` |

vor-wiki **does not** replace or mirror project `docs/` trees. It records **which** repos exist, **how** they are labelled in the estate, and **where** to read depth (`docs/...` paths per `repo_slug`).

---

## 2. Mandatory layout

```text
README.md
manifest/
└── repos.yaml                # required — see §3
catalog/
└── products.md               # required — see §5
landscape/
├── overview.md               # required — see §6.1
└── interactions.md           # required — see §6.2
repositories/
└── <repo_slug>/
    └── index.md              # required for each indexed repo in prose — see §4
```

**Optional** (do not rename mandatory siblings):

```text
manifest/README.md
catalog/domains.md
landscape/platforms.md
repositories/_template/index.md
.vor-docs.yaml                # optional — see §11
```

Do **not** mirror the full `docs/` four-folder layout inside vor-wiki.

---

## 3. `manifest/repos.yaml` (integration registry)

**This file wins** over `repositories/` folder presence or `catalog/products.md` for integration facts.

**Per-repo entry (required):** `owner`, `name`, `repo_slug`, `branch_live`, `branch_dev`. Optional: `include_docs` (default `true`; machine-oriented; do not duplicate in portfolio prose).

**Rules:**

- **MUST** include **`vor-wiki`** (`repo_slug: vor-wiki`).
- **`repo_slug`** **MUST** match the GitHub repository name spelling (hyphens allowed).
- Should `branch_live` or `branch_dev` change (which has never happened), update **manifest first**, then the matching sections on every affected `repositories/*/index.md`.
- Do **not** maintain a second copy of this registry outside vor-wiki.

**Order when adding a repo (content only):** (1) manifest entry → (2) `repositories/<repo_slug>/index.md` → (3) catalog / landscape as needed.

If branch values are not yet known, use:

```text
<<USER INPUT REQUIRED: branch_live and branch_dev for this repository in manifest/repos.yaml — live/docs line vs development PR line (may differ from GitHub default).>>
```

---

## 4. `repositories/<repo_slug>/index.md`

One primary page per indexed repo. **`repo_slug`** must match manifest.

### 4.1 Required `##` sections

| Section | Contents |
| ------- | -------- |
| **Repository** | **Single** `https://github.com/<owner>/<repo>` link—the **only** GitHub URL on this page; one-line portfolio role. |
| **Documentation branch (live)** | Exact ref; **MUST** equal `branch_live` in manifest. |
| **Development branch** | Exact ref; **MUST** equal `branch_dev` in manifest. |
| **Maintainers** | See §4.2. |
| **Status** | `active`, `deprecated`, `experimental`, or `archived`; optional successor `repo_slug`. |
| **Products** | Logical products/services; names align with `catalog/products.md`. |
| **Summary** | Compressed from `docs/product/overview.md` in the target repo. |
| **Usage (portfolio view)** | Compressed from `docs/product/usage.md`—no step-by-step tutorials. |
| **Features (index)** | Table or bullets: each `docs/product/feature_<NN>_*.md` with number, slug, one-line capability. |
| **Integrations (outbound)** | Compressed from `docs/product/integrations.md`—name, role, artifact type only. |
| **Inbound dependencies** | Other indexed repos/products that rely on this repo. |
| **Canonical documentation** | Repo-root-relative paths (§9)—at minimum `docs/product/overview.md`, `docs/product/usage.md`, `docs/product/integrations.md`, and `docs/technical/project_layout.md` when that file exists in the target repo. |
| **Last synced** | `Last synced: YYYY-MM-DD` at end of page. |

**Optional:** **Technical pointer** (boundary only), **Notes** (portfolio-only caveats).

Summaries and indexes in this file **must** reflect the target repo’s `docs/` at the cited paths, not invented detail.

### 4.2 Maintainers

- Bullet list of people or teams responsible for the **project** repository (not vor-wiki itself).
- Optional `(team)` or `(primary)` labels.
- If owners are unknown, use:

```text
<<USER INPUT REQUIRED: Named maintainers or owning team for this repository — confirm or replace any commit-author tally.>>
```

### 4.3 Stubs and deprecated repos

- **Stub:** no `docs/` yet (or empty)—`Status: experimental` or explicit “documentation pending”; **Products** / **Features** may use `TBD`.
- **Deprecated:** `Status: deprecated`; **Summary** states replacement; update peer **Inbound dependencies** when migrations complete.

---

## 5. `catalog/products.md`

Product-centric table; one row per `product_id` (stable snake_case, never reused after retirement).

| Column | Requirement |
| ------ | ------------- |
| `product_id` | Stable slug |
| `display_name` | Human name |
| `repos` | One or more `repo_slug` values |
| `summary` | One or two sentences |
| `primary_doc` | **`repo_slug`** and repo-root-relative path, e.g. `payment_api` → `docs/product/overview.md` (§9) |
| `status` | `active`, `deprecated`, `planned` |

Align **Products** on each repo index page. Do not paste full feature bodies.

---

## 6. `landscape/`

### 6.1 `overview.md`

Estate narrative; links to catalog and key `repositories/*/index.md`. No file trees or API field lists.

### 6.2 `interactions.md`

Directed edges: endpoints as `product_id` and/or `repo_slug`, direction, artifact (HTTP, queue, DB, etc.). Content **must** be consistent with each repo’s `docs/product/integrations.md` at cited paths. No intra-repo module calls.

Line 1 **SHOULD** be: `<!-- wiki_as_of: YYYY-MM-DD -->`

If portfolio integration facts conflict with a project’s `docs/`, **do not** settle the conflict in vor-wiki alone; correct the project `docs/` first, then update vor-wiki.

---

## 7. Correspondence: project `docs/` folders → vor-wiki

What vor-wiki **may** draw from each folder in a project’s `docs/` tree (when content is updated):

| Project `docs/` folder | vor-wiki usage |
| ---------------------- | -------------- |
| `product/` | **Primary**—summaries and feature index only |
| `technical/` | **Rare**—boundary pointer only; never copy layout, env vars, tests |
| `future/` | **Almost never**—only named stable portfolio decisions |
| `history/` | **Do not mirror**—at most one status line pointing to `docs/history/` |

Do not copy screenshots or `extras/` bodies; cite repo-root-relative `docs/...` paths where depth is needed.

---

## 8. When vor-wiki content should change

| Trigger | vor-wiki updates |
| ------- | ---------------- |
| New repo in estate | manifest; `repositories/<slug>/index.md`; catalog; landscape |
| New/changed products or public features | repo index **Features**; catalog; interactions if boundaries changed |
| Integration change | repo **Integrations**; `landscape/interactions.md`; peer inbound |
| Repo deprecated/renamed/split | Status; catalog; landscape; redirect notes |
| `branch_live` / `branch_dev` change | manifest; matching branch sections on index pages; refresh summaries and canonical paths if `docs/` moved |

**Typically not wiki-level:** refactors, test-only changes, typos, `history/` entries, env vars—unless portfolio-visible product or integration facts change.

---

## 9. Linking and cross-repo path citations

| Target | Format | Example |
| ------ | ------ | ------- |
| Another vor-wiki page | **Relative** markdown inside this repo | `[payment API](../repositories/payment_api/index.md)` |
| Documentation in another repository | **Repo-root-relative path** plus `repo_slug` in prose or table—not a markdown link from vor-wiki files | `payment_api`: `docs/product/overview.md` |
| GitHub repository home | **HTTPS** in **Repository** section only | one link per `index.md` |

- Paths like `docs/product/overview.md` are relative to the **named project repository root**, not to vor-wiki.
- **Never** use `https://github.com/.../blob/...` in vor-wiki (including catalog **`primary_doc`**).
- **Never** use site-assembler URL prefixes (e.g. `/projects/...`) in vor-wiki source.
- For feature depth, cite `docs/product/feature_<NN>_*.md` on the appropriate `repo_slug`.

Within each project repository, `docs/` internal links follow that repo’s own documentation standard (relative links inside `docs/`).

---

## 10. Grain and style

- Roughly **½–2 pages** per typical `repositories/*/index.md`.
- Plain language; tables for feature and integration indexes.
- Stable citations: `product_id`, `feature_03`, `repo_slug`.
- Bump **Last synced** when portfolio content was substantively reconciled against project `docs/`.

---

## 11. Optional `.vor-docs.yaml` (vor-wiki root)

vor-wiki **MAY** include **`.vor-docs.yaml`** at the repository root with optional fields:

| Field | Purpose |
| ----- | ------- |
| `nav_title` | Short label when this repo’s pages appear in a combined documentation index |
| `exclude` | Optional globs relative to vor-wiki root to omit from nav (rare; default is full tree, sections collapsed) |
| `nav_order` | Optional list of repo-root-relative paths to order top-level nav entries |

Do not put branch names or the repo list here—that belongs in **`manifest/repos.yaml`**.

---

## 12. Consistency checklist (before finishing edits)

1. **`manifest/repos.yaml`** — Integration set and branch fields correct; every indexed `index.md` **Documentation branch** / **Development branch** matches manifest.
2. **`repositories/<repo_slug>/index.md`** — Required sections present; **Last synced** updated when content was reconciled.
3. **`catalog/products.md`** — Rows align with repo **Products**; **`primary_doc`** uses `repo_slug` + valid `docs/...` paths.
4. **`landscape/`** — `interactions.md` consistent with repo integration summaries; `wiki_as_of` updated when touched.
5. **Linking** — No `blob/` or `/projects/`-style URLs; relative links within vor-wiki valid; cited `docs/...` paths match files in the target repo’s tree.
6. **Authority** — No portfolio prose contradicts target `docs/` at cited paths.
7. **Placeholders** — No unresolved `<<USER INPUT REQUIRED: …>>` unless intentionally left for a human.
8. **`.vor-docs.yaml`** — Updated only if excludes or `nav_title` should change.

---

## 13. Hygiene: what not to do

- Do **not** duplicate full `docs/` trees or feature bodies in vor-wiki.
- Do **not** add per-file GitHub links—one repo home URL per index page.
- Do **not** edit **`manifest/repos.yaml`** based only on which folders exist under `repositories/`.
- Do **not** resolve integration conflicts by choosing vor-wiki over project `docs/`.
- Portfolio-only facts **should** be recorded in project `docs/` when possible, then reflected here.
