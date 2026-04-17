#!/usr/bin/env bash
# protect-main.sh — Apply baseline branch protection to a repo's default branch
#
# Usage:
#   bash scripts/protect-main.sh <repo-name>
#   bash scripts/protect-main.sh conduit
#   bash scripts/protect-main.sh --all          # Apply to all non-archived repos
#
# Prerequisites: gh CLI authenticated with repo scope
#
# What this configures:
#   - Enforce admins (owner can't bypass)
#   - No direct pushes encouraged (PR-based workflow)
#   - required_status_checks left null (set per-repo as needed)
#   - No restrictions on who can push (solo developer)

set -euo pipefail

OWNER="paidhima"

protect_repo() {
    local repo="$1"
    local default_branch
    default_branch=$(gh api "repos/${OWNER}/${repo}" --jq '.default_branch')

    if [ -z "${default_branch}" ]; then
        echo "  FAILED: ${repo} - could not determine default branch" >&2
        return 1
    fi

    echo "Applying branch protection to ${OWNER}/${repo} (${default_branch})..."

    gh api "repos/${OWNER}/${repo}/branches/${default_branch}/protection" \
        -X PUT \
        --input - <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0
  },
  "restrictions": null
}
EOF

    if [ $? -eq 0 ]; then
        echo "  OK: ${repo}"
    else
        echo "  FAILED: ${repo}" >&2
    fi
}

if [ "${1:-}" = "--all" ]; then
    echo "Applying branch protection to all non-archived repos..."
    repos=$(gh repo list "${OWNER}" --limit 100 --json name,isArchived \
        --jq '.[] | select(.isArchived == false) | .name')
    for repo in $repos; do
        protect_repo "$repo"
    done
elif [ -n "${1:-}" ]; then
    protect_repo "$1"
else
    echo "Usage: bash scripts/protect-main.sh <repo-name>"
    echo "       bash scripts/protect-main.sh --all"
    exit 1
fi
