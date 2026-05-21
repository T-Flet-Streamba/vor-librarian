# Consumer prompt: reading vor-wiki efficiently (read-only)

You need **cross-repository orientation**—which products exist, which repo owns them, how systems connect—before diving into a single project’s `docs/` or code.

**Portfolio index:** **`streamba/vor-wiki`** (vor-wiki). Paths below are relative to the **root of that repository**.

**Canonical depth per project:** each `<project-repo>/docs/` tree—once you know the repo, follow **`docs_consumer_prompt.md`** for that tree.

**Your permissions.** You **must not** create, edit, move, or delete anything in vor-wiki (or project `docs/`) unless explicitly allowed elsewhere. This prompt governs **how to find and read** portfolio material efficiently.

**Where files live on disk.** Work from the **vor-wiki repository root** your session provides. To read a project’s `docs/`, use **`manifest/repos.yaml`** plus paths listed on **`repositories/<repo_slug>/index.md`**, then open `docs/...` under **that repository’s root** at the location your **entrypoint** or user indicates. This prompt does not prescribe parent directories, symlinks, or multi-repo layout—that is entrypoint context.

**Authority.**

- For **integration facts** (which repos exist, `branch_live`, `branch_dev`, `include_docs`): **`manifest/repos.yaml`** in vor-wiki wins.
- For **facts about one repository** (behaviour, APIs, layout, tests): that repo’s **`docs/` wins** over vor-wiki summaries.
- If vor-wiki prose contradicts a project’s `docs/` on **`branch_live`**, trust **`docs/`** and treat vor-wiki as stale until reconciled.

**Naming.** ASCII snake_case paths unless noted.

---

## 1. Layout (know where to list and search)

```text
README.md
manifest/
└── repos.yaml                # authoritative registry — read first for branch_live
catalog/
└── products.md               # product_id → repos, primary_doc
landscape/
├── overview.md               # estate narrative
└── interactions.md           # cross-repo integration edges
repositories/
└── <repo_slug>/
    └── index.md              # portfolio page per repo
```

**Optional:** `catalog/domains.md`, `landscape/platforms.md`, `manifest/README.md`, `.vor-docs.yaml` (optional nav metadata for combined indexes—not primary reading content).

Start many tasks by **listing** `manifest/`, `catalog/`, `landscape/`, or `repositories/` from the vor-wiki root—do not assume every repo has a portfolio page until you see `repositories/<repo_slug>/index.md`.

---

## 2. Predictable files (for listing and search)

### 2.1 `manifest/repos.yaml`

**Read first** when the task names a repo, branch, or “what is integrated.” Fields: `owner`, `name`, `repo_slug`, `branch_live`, `branch_dev`, optional `include_docs`.

Use **`branch_live`** to know which git ref to use when opening that project’s `docs/` (checkout or read at that ref per your session). **`branch_dev`** is for write/PR context only—not for choosing read paths in consumer mode.

### 2.2 `repositories/<repo_slug>/index.md`

Predictable **`##`** sections: **Repository**, **Documentation branch (live)**, **Development branch**, **Maintainers**, **Status**, **Products**, **Summary**, **Usage (portfolio view)**, **Features (index)**, **Integrations (outbound)**, **Inbound dependencies**, **Canonical documentation**, **Last synced**.

**Canonical documentation** lists paths **relative to that project repository’s root**, e.g. `docs/product/overview.md`. Open them under the project checkout your session provides (same path suffix after that repo’s root).

### 2.3 `catalog/products.md`

Table keyed by **`product_id`**. Grep `product_id`, display names, or `repo_slug` in the **repos** column. **`primary_doc`** names a **`repo_slug`** and a repo-root-relative `docs/...` path for the best overview.

### 2.4 `landscape/`

| File | Role |
| ---- | ---- |
| `overview.md` | Where to start; links to catalog and major repos |
| `interactions.md` | Directed integration graph; may start with `<!-- wiki_as_of: YYYY-MM-DD -->` |

---

## 3. Efficient retrieval workflow

**Default strategy:** **manifest → list/grep vor-wiki → read partial index/catalog → open project `docs/`**

1. **Read or grep `manifest/repos.yaml`** for `repo_slug`, `owner/name`, `branch_live`.
2. **List** `repositories/` under the vor-wiki root if you need the estate set; open only relevant `index.md` files.
3. **Search vor-wiki** using task anchors:
   - Product or capability names → `catalog/products.md`, then `repositories/`.
   - Integration partners → `landscape/interactions.md`, repo **Integrations** / **Inbound dependencies**.
   - `product_id`, `feature_<NN>`, `repo_slug` strings in prose or tables.
4. **Use index pages as routers**—read **Summary**, **Features (index)**, and **Canonical documentation** before loading full project `docs/`.
5. **Descend to project `docs/`** with **`docs_consumer_prompt.md`** on the identified repo; open files at `docs/...` under that repo’s root; grep there for symbols, paths, PR IDs as needed.
6. If a portfolio page is **missing** but the repo is in the manifest, treat as stub—go to project `docs/` or code if you can resolve that repo’s root; do not invent vor-wiki content.

**Token discipline:** Prefer **one** catalog row + **one** repo index + **one** `docs/product/overview.md` over reading every `repositories/*/index.md`.

---

## 4. Task → where to start reading

| Task shape | Read first (rough order) | Then follow |
| ---------- | ------------------------ | ----------- |
| “What repos/products exist?” | `manifest/repos.yaml`, `catalog/products.md`, `landscape/overview.md` | Selected `repositories/*/index.md` |
| “Which repo owns X?” | Grep `catalog/products.md`, `repositories/` **Products** / **Summary** | **Canonical documentation** paths → that repo’s `docs/` |
| “How do A and B connect?” | `landscape/interactions.md` | Both repos’ index **Integrations**; then each `docs/product/integrations.md` |
| “Who maintains repo Y?” | `repositories/<repo_slug>/index.md` **Maintainers** | — |
| “Is repo Z deprecated?” | Index **Status**; catalog **status** column | Successor `repo_slug` in prose |
| “Branch used for integrated docs?” | manifest `branch_live`; index **Documentation branch (live)** | Open project repo at that ref |
| Plan/ask spanning code + docs | vor-wiki for map → **`docs_consumer_prompt.md`** per repo | Code under paths from `docs/technical/project_layout.md` |

---

## 5. Linking expectations (read-only)

- **Within vor-wiki:** follow **relative** markdown links between portfolio files.
- **Into project `docs/`:** use **`repo_slug`** + paths from **Canonical documentation** or **`primary_doc`**; resolve the project repository root via entrypoint/session, then open `docs/...` there.

Do not “fix” broken paths in read-only mode; note staleness if cited `docs/...` paths are missing on **`branch_live`**.

---

## 6. What vor-wiki will not contain

Do not expect env-var catalogs, test commands, screenshot folders, full feature walkthroughs, or changelog threads here—they live in each project’s **`docs/technical/`**, **`docs/product/feature_*.md`**, **`docs/history/`**, etc.

If the task needs that depth, leave vor-wiki after routing and consume **`docs/`** in the target repository.
