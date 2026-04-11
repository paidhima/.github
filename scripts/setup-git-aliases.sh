#!/usr/bin/env bash
# setup-git-aliases.sh — Idempotent git alias configuration
# Works on macOS and Windows (Git Bash / WSL)
#
# Usage: bash scripts/setup-git-aliases.sh

set -euo pipefail

echo "Configuring global git aliases..."

git config --global alias.st      "status -sb"
git config --global alias.lg      "log --oneline --graph --decorate -20"
git config --global alias.co      "checkout"
git config --global alias.cb      "checkout -b"
git config --global alias.cm      "commit -m"
git config --global alias.amend   "commit --amend --no-edit"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last    "log -1 HEAD --stat"
git config --global alias.branches "branch -a --sort=-committerdate"
git config --global alias.sync    "pull --rebase --autostash"

echo ""
echo "Git aliases configured:"
git config --global --get-regexp alias | sort
