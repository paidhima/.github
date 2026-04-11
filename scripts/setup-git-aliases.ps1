# setup-git-aliases.ps1 — Idempotent git alias configuration
# Windows PowerShell / PowerShell 7
#
# Usage: .\scripts\setup-git-aliases.ps1

$ErrorActionPreference = "Stop"

Write-Host "Configuring global git aliases..."

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

Write-Host ""
Write-Host "Git aliases configured:"
git config --global --get-regexp alias | Sort-Object
