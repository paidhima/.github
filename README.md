# .github

Default community health files, reusable CI workflows, and developer setup
scripts for **paidhima** repositories.

## What this repo provides

### Default community health files

Files in `.github/` are inherited by any `paidhima/*` repo that does not
define its own version:

- **PULL_REQUEST_TEMPLATE.md** — general-purpose PR checklist
- **ISSUE_TEMPLATE/** — bug report and feature request forms
- **SECURITY.md** — security disclosure policy
- **CONTRIBUTING.md** — contribution guidelines

### Reusable CI workflows

Workflows in `.github/workflows/` can be called from any repo:

- **python-quality.yml** — lint (ruff), typecheck (mypy), test (pytest) matrix

### Developer setup scripts

Scripts in `scripts/` bootstrap a consistent local dev environment:

- **setup-git-aliases.sh** — cross-platform git alias configuration
- **setup-gh-aliases.sh** — GitHub CLI alias configuration
- **bootstrap-windows.ps1** — installs baseline Windows tools and VS Code extensions
- **bootstrap-macos.sh** — installs baseline macOS tools and VS Code extensions
- **verify-environment-windows.ps1** — verifies Windows workstation parity
- **verify-environment-macos.sh** — verifies macOS workstation parity

See [docs/workstation-setup.md](docs/workstation-setup.md) for full
cross-platform setup instructions.

## Workstation Consistency

- [docs/workstation-consistency.md](docs/workstation-consistency.md) — cross-machine standards and operating cadence
- [docs/copilot-consistency-checklist.md](docs/copilot-consistency-checklist.md) — pre-session Copilot consistency checks
