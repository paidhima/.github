# Repository Modernization Standard

This standard defines the minimum modernization bar for repositories in the paidhima account.

For new repositories, use the canonical provisioning guide first:
- [docs/repo-provisioning-standard.md](repo-provisioning-standard.md)

## Scope

- Applies to active Python and PowerShell repositories.
- Archived repositories are out of scope unless explicitly reactivated.
- All changes must be done on feature branches and merged through pull requests.

## Lifecycle

1. Baseline capture
2. Workflow standardization
3. Tooling modernization
4. Runtime compatibility updates
5. Documentation refresh
6. Validation and merge

## Baseline Capture

Collect and record:
- Primary language and runtime versions
- Current CI workflows and status
- Dependency management approach
- Branch protections and CODEOWNERS status
- Last push date and maintenance activity

## Python Standard

- Runtime target: Python 3.12+ where feasible
- Tooling:
  - ruff for linting and formatting
  - mypy for type checking
  - pytest for tests
- Remove duplicate format/lint tools when ruff covers the same concern.
- Use reusable quality workflow from paidhima/.github where possible.

Required repository files:
- .github/workflows/quality.yml
- .github/dependabot.yml (pip + github-actions)
- .github/CODEOWNERS
- .gitattributes

## PowerShell Standard

- Use PSScriptAnalyzer and Pester in CI.
- Keep script line endings consistent using .gitattributes (CRLF for ps1/psm1/psd1).
- Use reusable patterns from template-powershell.

Required repository files:
- .github/workflows/quality.yml
- .github/dependabot.yml (github-actions)
- .github/CODEOWNERS
- .gitattributes

## Documentation Standard

At minimum, update:
- README runtime/version prerequisites
- Local development and test commands
- CI workflow summary
- Upgrade notes when breaking changes are introduced

## Validation Gate

A repo is considered modernized when:
- CI is green on PR
- Dependabot is configured and active
- Standard tooling is in place
- Runtime target is documented and tested
- Documentation updates are merged

## Tracking Model

Use GitHub Project "Repository Modernization Program" with one item per repository.

Project fields to set on each item:
- Language
- Tier
- Runtime Target
- Modernization Stage

Tier guidance:
- T1-Active: frequently updated or business-critical
- T2-Maintained: occasional updates, still in use
- T3-Legacy: low activity, modernization optional

## Rollout Cadence

- Work in weekly batches of 2-4 repositories.
- Complete one repo end-to-end before moving to the next.
- Reuse template-driven changes to reduce drift across repositories.

## Non-Goals

- Rewriting stable code without clear value
- Expanding scope into feature work during modernization
- Enforcing runtime upgrades that break required compatibility without stakeholder approval
