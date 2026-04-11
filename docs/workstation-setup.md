# Workstation Setup Guide

Cross-platform instructions for setting up a new development machine to work
with `paidhima` repositories. Covers Windows 11 and macOS.

---

## Prerequisites

### Both platforms

| Tool | Purpose | Verify |
|------|---------|--------|
| Git | Version control | `git --version` |
| GitHub CLI (`gh`) | GitHub API, repo management, aliases | `gh --version` |
| Python 3.12+ | Primary dev language | `python3 --version` |
| VS Code | Editor | `code --version` |

### Windows 11

Install via winget (preferred) or manually:

```powershell
winget install Git.Git
winget install GitHub.cli
winget install Python.Python.3.12
winget install Microsoft.VisualStudioCode
```

### macOS

Install via Homebrew:

```bash
brew install git gh python@3.12
brew install --cask visual-studio-code
```

---

## Step 1: Authenticate GitHub CLI

```bash
gh auth login
```

Choose:
- **GitHub.com**
- **HTTPS** (recommended)
- **Login with a web browser**

Verify:

```bash
gh auth status
```

You should see scopes including `repo` and `workflow`.

---

## Step 2: Clone this repo

```bash
# From your git workspace root (e.g., ~/git or C:\Users\<you>\git)
gh repo clone paidhima/.github
```

---

## Step 3: Configure git aliases

Git aliases are stored in `~/.gitconfig` (macOS) or
`C:\Users\<you>\.gitconfig` (Windows). They're global and apply to all repos.

**macOS / Linux / Git Bash:**

```bash
bash .github/scripts/setup-git-aliases.sh
```

**Windows PowerShell:**

```powershell
.\.github\scripts\setup-git-aliases.ps1
```

**What gets configured:**

| Alias | Expands to | Purpose |
|-------|-----------|---------|
| `git st` | `git status -sb` | Compact status |
| `git lg` | `git log --oneline --graph --decorate -20` | Visual log |
| `git co <branch>` | `git checkout <branch>` | Switch branch |
| `git cb <name>` | `git checkout -b <name>` | Create + switch |
| `git cm "msg"` | `git commit -m "msg"` | Quick commit |
| `git amend` | `git commit --amend --no-edit` | Amend last commit |
| `git unstage <file>` | `git reset HEAD -- <file>` | Unstage file |
| `git last` | `git log -1 HEAD --stat` | Show last commit |
| `git branches` | `git branch -a --sort=-committerdate` | Recent branches |
| `git sync` | `git pull --rebase --autostash` | Clean pull |

These are idempotent — safe to re-run on an already-configured machine.

---

## Step 4: Configure GitHub CLI aliases

GH aliases are stored in `~/.config/gh/config.yml` (macOS) or
`%APPDATA%\GitHub CLI\config.yml` (Windows). They're global.

**macOS / Linux / Git Bash:**

```bash
bash .github/scripts/setup-gh-aliases.sh
```

**Windows PowerShell:**

```powershell
.\.github\scripts\setup-gh-aliases.ps1
```

**What gets configured:**

| Alias | Expands to | Purpose |
|-------|-----------|---------|
| `gh co` | `gh pr checkout` | Check out a PR locally |
| `gh pr-create` | `gh pr create --base main --fill` | Quick PR to main |
| `gh my-prs` | `gh pr list --author @me` | Your open PRs |
| `gh new-py <name>` | `gh repo create --template ... --private --clone` | New Python repo from template |
| `gh new-ps <name>` | `gh repo create --template ... --private --clone` | New PowerShell repo from template |
| `gh ci` | `gh run list -L 5` | Recent CI runs |
| `gh issues` | `gh issue list -L 10` | Recent issues |

Uses `--clobber` internally, so re-running updates existing aliases safely.

---

## Step 5: Configure git identity

Set your name and email if not already configured:

```bash
git config --global user.name "Robert"
git config --global user.email "paidhima@gmail.com"
```

### Credential storage

**Windows:** Git Credential Manager is included with Git for Windows. Verify:

```powershell
git config --global credential.helper
# Expected: manager
```

**macOS:** Use the macOS Keychain:

```bash
git config --global credential.helper osxkeychain
```

---

## Step 6: VS Code extensions

Install recommended extensions. These can be run from any terminal:

```bash
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
code --install-extension GitHub.vscode-pull-request-github
code --install-extension ms-python.python
code --install-extension charliermarsh.ruff
```

---

## Step 7: Global gitignore (optional but recommended)

Prevent OS/editor artifacts from ever being committed.

**macOS:**

```bash
cat > ~/.gitignore_global << 'EOF'
.DS_Store
.Thumbs.db
*.swp
*.swo
*~
.vscode/settings.json
.idea/
EOF
git config --global core.excludesfile ~/.gitignore_global
```

**Windows PowerShell:**

```powershell
@"
Thumbs.db
Desktop.ini
*.swp
*.swo
*~
.vscode/settings.json
.idea/
"@ | Set-Content "$env:USERPROFILE\.gitignore_global" -Encoding UTF8
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"
```

---

## Step 8: Verify everything

Run these checks on a fresh machine to confirm setup is complete:

```bash
# Identity
git config --global user.name
git config --global user.email

# Aliases
git config --global --get-regexp alias
gh alias list

# Auth
gh auth status

# Template access
gh repo create --template paidhima/template-python --private test-verify --dry-run 2>&1 || true
```

---

## Platform-specific notes

### Windows 11

- **Line endings:** Git for Windows defaults to `core.autocrlf=true`. This is
  fine for most repos. Repos with `.gitattributes` (recommended) override
  this per-file.
- **PowerShell execution policy:** If scripts won't run, enable for current
  user:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```
- **gh stderr quirk:** `gh` writes progress messages to stderr. PowerShell
  treats any stderr output as an error. This is cosmetic — commands still
  succeed. Suppress with `$ErrorActionPreference = "Continue"` or redirect:
  `gh ... 2>$null`.

### macOS

- **Homebrew Python:** `python3` and `pip3` are the correct commands (not
  `python` / `pip` unless you create aliases or use pyenv).
- **Xcode CLT:** `git` comes from Xcode Command Line Tools. If prompted to
  install, accept.
- **Shell:** Default is zsh. All bash scripts in this repo are compatible with
  both bash and zsh.
- **GH config location:** `~/.config/gh/config.yml`

---

## Keeping machines in sync

The scripts in this repo are the source of truth. When you add or change an
alias:

1. Update the script in `scripts/`
2. Commit and push to `paidhima/.github`
3. On other machines: `git -C <path-to-.github> pull && bash scripts/setup-git-aliases.sh && bash scripts/setup-gh-aliases.sh`

Git aliases live in `~/.gitconfig` and gh aliases in the gh config file. Both
are overwritten idempotently by the scripts, so re-running is always safe.
