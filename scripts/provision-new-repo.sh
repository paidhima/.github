#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/provision-new-repo.sh --name <repo-name> [options]

Options:
  --name <repo-name>           Repository name (required)
  --type <python|powershell>   Template type (default: python)
  --visibility <private|public> Visibility (default: private)
  --owner <owner>              GitHub owner (default: paidhima)
  --workspace <path>           Local workspace root (default: ~/git)
  --skip-protect               Skip branch protection step
  --skip-bootstrap-branch      Skip bootstrap branch creation
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

repo_name=""
repo_type="python"
visibility="private"
owner="paidhima"
workspace_root="${HOME}/git"
skip_protect="false"
skip_bootstrap_branch="false"

while [ $# -gt 0 ]; do
  case "$1" in
    --name)
      repo_name="$2"
      shift 2
      ;;
    --type)
      repo_type="$2"
      shift 2
      ;;
    --visibility)
      visibility="$2"
      shift 2
      ;;
    --owner)
      owner="$2"
      shift 2
      ;;
    --workspace)
      workspace_root="$2"
      shift 2
      ;;
    --skip-protect)
      skip_protect="true"
      shift
      ;;
    --skip-bootstrap-branch)
      skip_bootstrap_branch="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "${repo_name}" ]; then
  echo "--name is required" >&2
  usage
  exit 1
fi

case "${repo_type}" in
  python)
    template="paidhima/template-python"
    ;;
  powershell)
    template="paidhima/template-powershell"
    ;;
  *)
    echo "Unsupported type: ${repo_type}" >&2
    exit 1
    ;;
esac

case "${visibility}" in
  private|public)
    ;;
  *)
    echo "Unsupported visibility: ${visibility}" >&2
    exit 1
    ;;
esac

require_cmd gh
require_cmd git

echo "Verifying GitHub CLI authentication..."
gh auth status >/dev/null

mkdir -p "${workspace_root}"

full_repo="${owner}/${repo_name}"
repo_path="${workspace_root}/${repo_name}"

if [ -e "${repo_path}" ]; then
  echo "Target path already exists: ${repo_path}" >&2
  exit 1
fi

echo "Provisioning repository: ${full_repo}"
echo "Type: ${repo_type}"
echo "Template: ${template}"
echo "Visibility: ${visibility}"

pushd "${workspace_root}" >/dev/null
gh repo create "${full_repo}" --template "${template}" --"${visibility}" --clone
popd >/dev/null

if [ "${skip_protect}" != "true" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  protect_script="${script_dir}/protect-main.sh"
  if [ -x "${protect_script}" ]; then
    echo "Applying baseline branch protection..."
    bash "${protect_script}" "${repo_name}"
  else
    echo "Warning: branch protection script not executable at ${protect_script}" >&2
  fi
fi

if [ "${skip_bootstrap_branch}" != "true" ]; then
  pushd "${repo_path}" >/dev/null
  echo "Creating bootstrap branch..."
  git checkout -b feature/bootstrap-repo-standards >/dev/null
  popd >/dev/null
fi

echo
echo "Provisioning complete."
echo "Local path: ${repo_path}"
echo "Next steps:"
echo "  1) Update placeholders and README content."
echo "  2) Run quality checks for the selected template."
echo "  3) Commit bootstrap changes and open a PR."
