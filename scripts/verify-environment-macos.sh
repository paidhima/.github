#!/usr/bin/env bash
set -euo pipefail

issues=()

add_issue() {
  issues+=("$1")
}

echo "== Workstation Verify (macOS) =="

for cmd in git gh code; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    add_issue "Missing command: $cmd"
  fi
done

if command -v git >/dev/null 2>&1; then
  echo "git: $(git --version)"
fi

if command -v gh >/dev/null 2>&1; then
  echo "gh: $(gh --version | head -n 1)"
  if ! gh auth status >/dev/null 2>&1; then
    add_issue "gh auth status failed"
  else
    echo "gh auth: OK"
  fi
fi

if command -v code >/dev/null 2>&1; then
  echo "code: $(code --version | head -n 1)"
  required_extensions=(
    "GitHub.copilot"
    "GitHub.copilot-chat"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-vscode.powershell"
    "GitHub.vscode-pull-request-github"
  )

  installed_extensions="$(code --list-extensions)"
  for ext in "${required_extensions[@]}"; do
    if ! grep -Fxq "$ext" <<<"$installed_extensions"; then
      add_issue "Missing VS Code extension: $ext"
    fi
  done
fi

if command -v python3 >/dev/null 2>&1; then
  echo "python3: $(python3 --version)"
else
  add_issue "python3 not found on PATH"
fi

if command -v pwsh >/dev/null 2>&1; then
  echo "pwsh: $(pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()')"
else
  add_issue "pwsh not found on PATH"
fi

if [ ${#issues[@]} -gt 0 ]; then
  echo
  echo "Verification failed:"
  for issue in "${issues[@]}"; do
    echo "- ${issue}"
  done
  exit 1
fi

echo
echo "Verification passed."
