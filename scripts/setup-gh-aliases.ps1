# setup-gh-aliases.ps1 — Idempotent GitHub CLI alias configuration
# Windows PowerShell / PowerShell 7
#
# Usage: .\scripts\setup-gh-aliases.ps1
#
# Prerequisites: gh must be installed and authenticated (gh auth login)

$ErrorActionPreference = "Stop"

Write-Host "Configuring gh CLI aliases..."

# PR checkout (shorthand)
gh alias set co          "pr checkout"             --clobber

# Create a PR targeting main with auto-filled title/body
gh alias set pr-create   "pr create --base main --fill" --clobber

# List your open PRs
gh alias set my-prs      "pr list --author @me"    --clobber

# Scaffold a new private repo from the Python template
gh alias set new-py      "repo create --template paidhima/template-python --private --clone" --clobber

# Scaffold a new private repo from the PowerShell template
gh alias set new-ps      "repo create --template paidhima/template-powershell --private --clone" --clobber

# View recent CI runs for the current repo
gh alias set ci          "run list -L 5"           --clobber

# Quick issue listing
gh alias set issues      "issue list -L 10"        --clobber

Write-Host ""
Write-Host "gh aliases configured:"
gh alias list
