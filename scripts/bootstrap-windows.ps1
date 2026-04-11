[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Get-CodeCli {
  $candidates = @(
    "C:\Program Files\Microsoft VS Code\bin\code.cmd",
    "C:\Program Files\Microsoft VS Code Insiders\bin\code-insiders.cmd"
  )

  foreach ($candidate in $candidates) {
    if (Test-Path $candidate) {
      return $candidate
    }
  }

  if (Get-Command code -ErrorAction SilentlyContinue) {
    return "code"
  }

  return $null
}

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
  "github.copilot-chat",
  "ms-python.python",
  "ms-python.vscode-pylance",
  "ms-vscode.powershell",
  "github.vscode-pull-request-github"
)

$codeCli = Get-CodeCli
if (-not $codeCli) {
  Write-Error "VS Code CLI not found. Start VS Code once and ensure shell command is installed."
}

foreach ($ext in $extensions) {
  Write-Host "Installing extension: $ext"
  & $codeCli --install-extension $ext --force | Out-Null
}

Write-Host ""
Write-Host "Bootstrap complete. Run scripts/verify-environment-windows.ps1 next." -ForegroundColor Green
