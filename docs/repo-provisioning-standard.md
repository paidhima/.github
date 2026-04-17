# Repository Provisioning Standard

Single source of truth for creating a new repository in the `paidhima` account
with required standards, guardrails, and documentation already in place.

Use this document for all new repositories unless an exception is explicitly
approved.

## Outcomes

After following this guide, a new repository will have:

- Standardized quality workflow and dependency updates.
- Standardized ownership, security, and contribution templates.
- Baseline Copilot instruction policy with language profile coverage.
- Runtime/tooling expectations documented in README.
- Branch protection and review safety configured.

## Prerequisites

- GitHub CLI authenticated: `gh auth status`
- Local workspace root available: `c:\Users\<you>\git`
- Access to these source repositories:
  - `paidhima/.github`
  - `paidhima/template-python`
  - `paidhima/template-powershell`
  - `paidhima/copilot-config`

## One-Command Bootstrap (Recommended)

Use the provisioning script from this repository.

Windows PowerShell:

```powershell
.\scripts\provision-new-repo.ps1 -RepoName <repo-name> -Type python
.\scripts\provision-new-repo.ps1 -RepoName <repo-name> -Type powershell
```

macOS/Linux:

```bash
bash scripts/provision-new-repo.sh --name <repo-name> --type python
bash scripts/provision-new-repo.sh --name <repo-name> --type powershell
```

Behavior:

1. Creates repo from the selected template.
2. Clones into the configured workspace.
3. Applies baseline branch protection to the repository default branch.
4. Creates `feature/bootstrap-repo-standards` branch.

## Provisioning Paths

Choose one path.

1. Python repository: start from `template-python`.
2. PowerShell repository: start from `template-powershell`.
3. Other/mixed repository: start empty, then apply required baseline files.

## Path A: Python Repository (Preferred)

### 1. Create from template

```powershell
Set-Location c:\Users\<you>\git
gh repo create <repo-name> --private --template paidhima/template-python --clone
Set-Location <repo-name>
```

### 2. Rename package placeholders

- Replace template package/module placeholders in `src/` and `pyproject.toml`.
- Update project metadata in `pyproject.toml`.

### 3. Apply baseline repository files

Ensure these files exist and are correct:

- `.github/workflows/quality.yml`
- `.github/dependabot.yml`
- `.github/CODEOWNERS`
- `.gitattributes`
- `.gitignore`
- `README.md`
- `.copilot-instructions.md`

### 4. Set project-specific quality targets

- Update workflow paths/targets in `.github/workflows/quality.yml`.
- Ensure `ruff`, `mypy`, and `pytest` commands match repo layout.

### 5. Validate locally

```powershell
python -m pip install -e .[dev]
ruff check .
ruff format --check .
pytest
```

## Path B: PowerShell Repository (Preferred)

### 1. Create from template

```powershell
Set-Location c:\Users\<you>\git
gh repo create <repo-name> --private --template paidhima/template-powershell --clone
Set-Location <repo-name>
```

### 2. Apply baseline repository files

Ensure these files exist and are correct:

- `.github/workflows/quality.yml`
- `.github/dependabot.yml`
- `.github/CODEOWNERS`
- `.gitattributes`
- `.gitignore`
- `README.md`
- `.copilot-instructions.md`

### 3. Set project-specific quality targets

- Ensure ScriptAnalyzer and Pester paths match repo layout.
- Confirm line-ending policy for PowerShell scripts in `.gitattributes`.

### 4. Validate locally

```powershell
Invoke-ScriptAnalyzer -Path src/ -Recurse -WarningAction Stop
Invoke-Pester -Path tests/ -Verbose
```

## Path C: Other or Mixed Repository

### 1. Create repository

```powershell
Set-Location c:\Users\<you>\git
gh repo create <repo-name> --private --clone
Set-Location <repo-name>
```

### 2. Copy required baseline files

Copy from `paidhima/.github` and adjust as needed:

- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/SECURITY.md`
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`

Add repo-local files:

- `.github/workflows/quality.yml`
- `.github/dependabot.yml`
- `.github/CODEOWNERS`
- `.gitattributes`
- `.gitignore`
- `README.md`
- `.copilot-instructions.md` (language/domain profile)

### 3. Define checks for each language area

- Configure CI with path filters when repository is mixed-language.
- Require only relevant checks per changed paths.

## Copilot Instruction Standard

Instruction hierarchy for all new repos:

1. Global baseline in `copilot-config/global/copilot-instructions.md`
2. Language profile from:
   - `template-python/.copilot-instructions.md`
   - `template-powershell/.copilot-instructions.md`
3. Repo-local delta file for domain-specific rules only

Do not duplicate global baseline text inside repo-local instructions.

For sync operations and canonical file order, use:

- `copilot-config/docs/instructions-sync-checklist.md`

## Branch Protection and Safety

Configure these settings immediately after repository creation:

1. Protect default branch (main/master):
   - Require pull request before merge.
   - Require status checks.
   - Restrict direct pushes.
2. Require CODEOWNERS review where appropriate.
3. Enable Dependabot security and version updates.

## Required Baseline Validation Checklist

Before first feature work:

- [ ] CI workflow runs on PR.
- [ ] Dependabot config is valid.
- [ ] CODEOWNERS is present.
- [ ] README contains setup and quality commands.
- [ ] Copilot instructions are present and scoped.
- [ ] Local quality checks pass.

## First Commit Sequence (Exact)

```powershell
git checkout -b feature/bootstrap-repo-standards
git add .
git commit -m "chore: bootstrap repository standards"
git push -u origin feature/bootstrap-repo-standards
gh pr create --base <default-branch> --fill
```

## Non-Negotiable Rules

- No direct push to default branch for substantive changes.
- No repository starts without quality workflow and dependabot.
- No repository starts without explicit runtime/tooling docs in README.
- No secrets in repository history, examples, or logs.

## Related Standards

- `docs/modernization-standard.md`
- `docs/workstation-setup.md`
- `docs/workstation-consistency.md`
- `docs/copilot-consistency-checklist.md`
