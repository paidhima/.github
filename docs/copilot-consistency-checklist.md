# Copilot Consistency Checklist

Use this checklist before starting a modernization session on a workstation.

## Identity
- [ ] Signed into VS Code with the expected GitHub account
- [ ] GitHub Copilot shows active entitlement for the same account
- [ ] `gh auth status` is healthy for the same account

## VS Code Session Baseline
- [ ] Correct profile selected
- [ ] Settings Sync enabled
- [ ] Prompts/instructions sync enabled
- [ ] Workspace trust enabled for the repository

## Instruction Hierarchy
- [ ] Global instructions only include personal defaults
- [ ] Repository instructions include project-specific constraints
- [ ] No duplicated/conflicting rules between global and repository instructions

## Prompt and Workflow Guardrails
- [ ] Use repository feature branch workflow (never direct push to `main`)
- [ ] Use reusable workflows where available
- [ ] Run repository quality checks before merge

## Validation
- [ ] Run environment verify script for current OS
- [ ] Confirm expected extensions are present
- [ ] Confirm Python/PowerShell toolchain versions meet baseline

## Quick Commands
```bash
gh auth status
```

```powershell
# Windows
.\scripts\verify-environment-windows.ps1
```

```bash
# macOS
./scripts/verify-environment-macos.sh
```
