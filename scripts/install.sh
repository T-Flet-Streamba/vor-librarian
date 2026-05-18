#!/usr/bin/env bash
# Installs the vor-librarian Cursor skill (SKILL.md + vor-librarian.json).
set -euo pipefail

REPO="streamba/vor-librarian"
SKILL_NAME="vor-librarian"
LOCAL_SKILL_PATH="skill/local/SKILL.md"
REF="master"
PROJECT=0

usage() {
  cat <<'EOF'
Usage: install.sh [--project] [--ref BRANCH] [--repo OWNER/NAME]

  --project     Install to ./.cursor/skills/ (default: ~/.cursor/skills/)
  --ref BRANCH  Git ref for GitHub API fetches (default: master)
  --repo        GitHub repository owner/name (default: streamba/vor-librarian)
EOF
}

gh_fetch() {
  local repo="$1" ref="$2" path="$3"
  gh api "repos/${repo}/contents/${path}?ref=${ref}" -H "Accept: application/vnd.github.raw"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT=1; shift ;;
    --ref) REF="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is required. Install from https://cli.github.com and run: gh auth login" >&2
  exit 1
fi

if [[ "$PROJECT" -eq 1 ]]; then
  SKILLS_ROOT="$(pwd)/.cursor/skills"
  SCOPE="project"
else
  SKILLS_ROOT="${HOME}/.cursor/skills"
  SCOPE="personal"
fi

TARGET_DIR="${SKILLS_ROOT}/${SKILL_NAME}"

mkdir -p "$TARGET_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOCAL_SKILL_FILE="${REPO_ROOT}/${LOCAL_SKILL_PATH}"

echo "Fetching ${REPO}@${REF}:${LOCAL_SKILL_PATH} via gh ..."
if skill_content="$(gh_fetch "$REPO" "$REF" "$LOCAL_SKILL_PATH" 2>/dev/null)"; then
  :
elif [[ -f "$LOCAL_SKILL_FILE" ]]; then
  echo "Warning: remote fetch failed; using local SKILL.md from repository." >&2
  skill_content="$(<"$LOCAL_SKILL_FILE")"
else
  echo "Failed to fetch ${LOCAL_SKILL_PATH} from ${REPO}@${REF}. Run: gh auth login" >&2
  exit 1
fi

INSTALLED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

write_skill() {
  printf '%s' "$skill_content" > "${TARGET_DIR}/SKILL.md"
}

write_config() {
  cat > "${TARGET_DIR}/vor-librarian.json" <<EOF
{
  "repo": "${REPO}",
  "ref": "${REF}",
  "installedAt": "${INSTALLED_AT}",
  "installScope": "${SCOPE}"
}
EOF
}

write_skill
write_config

echo ""
echo "vor-librarian installed successfully."
echo "  Location:  ${TARGET_DIR}"
echo "  Repo:      ${REPO}"
echo "  Ref:       ${REF}"
echo "  Scope:     ${SCOPE}"
echo ""
echo "Invoke the skill in Cursor (e.g. @vor-librarian)."
echo "Maintainers: edit vor-librarian.json to change repo/ref for branch testing."
