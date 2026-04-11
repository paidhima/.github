[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$issues = @()

function Add-Issue {
  param([string]$Message)
  $script:issues += $Message
}

Write-Host "== Workstation Verify (Windows) ==" -ForegroundColor Cyan

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

$commands = @("git", "gh", "code")
foreach ($cmd in $commands) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Add-Issue "Missing command: $cmd"
  }
}

if (Get-Command git -ErrorAction SilentlyContinue) {
  $gitVersion = (git --version) 2>$null
  Write-Host "git: $gitVersion"
}

if (Get-Command gh -ErrorAction SilentlyContinue) {
  $ghVersion = (gh --version | Select-Object -First 1) 2>$null
  Write-Host "gh: $ghVersion"

  try {
    gh auth status | Out-Null
    Write-Host "gh auth: OK"
  }
  catch {
    Add-Issue "gh auth status failed"
  }
}

 $codeCli = Get-CodeCli
if ($codeCli) {
  $codeVersion = (& $codeCli --version | Select-Object -First 1) 2>$null
  Write-Host "code: $codeVersion"

  $requiredExtensions = @(
    "github.copilot-chat",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-vscode.powershell",
    "github.vscode-pull-request-github"
  )

  $installed = (& $codeCli --list-extensions) | ForEach-Object { $_.ToLowerInvariant() }
  foreach ($ext in $requiredExtensions) {
    if ($installed -notcontains $ext) {
      Add-Issue "Missing VS Code extension: $ext"
    }
  }
}
else {
  Add-Issue "VS Code CLI not found (code/code.cmd)"
}

if (Get-Command python -ErrorAction SilentlyContinue) {
  $pythonVersion = (python --version) 2>$null
  Write-Host "python: $pythonVersion"
}
else {
  Add-Issue "python not found on PATH"
}

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
  $pwshVersion = (pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()') 2>$null
  Write-Host "pwsh: $pwshVersion"
}
else {
  Add-Issue "pwsh not found on PATH"
}

if ($issues.Count -gt 0) {
  Write-Host ""
  Write-Host "Verification failed:" -ForegroundColor Red
  foreach ($issue in $issues) {
    Write-Host "- $issue" -ForegroundColor Red
  }
  exit 1
}

Write-Host ""
Write-Host "Verification passed." -ForegroundColor Green
