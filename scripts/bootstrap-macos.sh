#!/usr/bin/env bash
set -euo pipefail

echo "== Workstation Bootstrap (macOS) =="

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it first: https://brew.sh"
  exit 1
fi

brew update

brew install git gh python@3.12
brew install --cask visual-studio-code
brew install --cask powershell

if ! command -v code >/dev/null 2>&1; then
  echo "VS Code command line 'code' not found. In VS Code run: Shell Command: Install 'code' command in PATH"
  exit 1
fi

extensions=(
  "github.copilot-chat"
  "ms-python.python"
  "ms-python.vscode-pylance"
  "ms-vscode.powershell"
  "github.vscode-pull-request-github"
)

for ext in "${extensions[@]}"; do
  echo "Installing extension: ${ext}"
  code --install-extension "${ext}" --force >/dev/null

done

echo
echo "Bootstrap complete. Run scripts/verify-environment-macos.sh next."
