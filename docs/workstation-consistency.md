# Workstation Consistency Standard (VS Code + Copilot)

## Purpose
This document defines the baseline for keeping development environments consistent across Windows and macOS workstations.

## Canonical Home
All cross-workstation standards live in the account-level `.github` repository.

Why:
- Single source of truth for all repositories
- Versioned and reviewable through pull requests
- Reusable across machines and projects

## Scope Boundaries
- Global workstation defaults and personal Copilot defaults belong here.
- Repository-specific rules belong in each repo's `.github/copilot-instructions.md`.
- Avoid duplicating repo-specific behavior in global prompts/instructions.

## Required Baseline
1. Identity and authentication
- Same GitHub account in VS Code and Copilot on all machines
- Same Git credential strategy (Git Credential Manager)
- Same commit signing strategy (SSH/GPG) where used

2. VS Code runtime
- One channel policy across machines (Stable only, or Insiders only)
- Same required extension set installed
- Same VS Code profile selected before coding sessions

3. Copilot behavior
- Global instructions contain personal defaults only
- Repo instructions contain project constraints and conventions
- Instruction/prompt changes reviewed by PR

4. Language and tooling parity
- Python repos: `ruff`, `mypy`, `pytest`; Python 3.12+ where feasible
- PowerShell repos: `PSScriptAnalyzer` and `Pester`
- Dependabot and reusable workflows standardized

## Suggested Cadence
- Weekly: run verify scripts on each workstation
- Per repository modernization: apply checklist, open PR, merge after green CI
- Monthly: reconcile extensions and remove drift
- Quarterly: clean up stale/overlapping prompt and instruction rules

## Scripts
- Windows bootstrap: `scripts/bootstrap-windows.ps1`
- macOS bootstrap: `scripts/bootstrap-macos.sh`
- Windows verify: `scripts/verify-environment-windows.ps1`
- macOS verify: `scripts/verify-environment-macos.sh`
