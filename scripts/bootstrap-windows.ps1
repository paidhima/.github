[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "== Workstation Bootstrap (Windows) ==" -ForegroundColor Cyan

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Error "winget is required for this bootstrap script."
}

$packages = @(
  "Git.Git",
  "GitHub.cli",
  "Microsoft.VisualStudioCode",
  "Python.Python.3.12",
  "Microsoft.PowerShell"
)

foreach ($pkg in $packages) {
  Write-Host "Ensuring package: $pkg"
  winget install --id $pkg --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --exact | Out-Null
}

$extensions = @(
  "GitHub.copilot",
  "GitHub.copilot-chat",
  "ms-python.python",
  "ms-python.vscode-pylance",
  "ms-vscode.powershell",
  "GitHub.vscode-pull-request-github"
)

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
  Write-Error "VS Code command line 'code' not found. Start VS Code once and ensure shell command is installed."
}

foreach ($ext in $extensions) {
  Write-Host "Installing extension: $ext"
  code --install-extension $ext --force | Out-Null
}

Write-Host ""
Write-Host "Bootstrap complete. Run scripts/verify-environment-windows.ps1 next." -ForegroundColor Green
