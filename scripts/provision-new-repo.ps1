[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RepoName,

    [ValidateSet("python", "powershell")]
    [string]$Type = "python",

    [ValidateSet("private", "public")]
    [string]$Visibility = "private",

    [string]$Owner = "paidhima",

    [string]$WorkspaceRoot = "$HOME\\git",

    [switch]$SkipBranchProtection,

    [switch]$SkipBootstrapBranch
)

$ErrorActionPreference = "Stop"

function Assert-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Get-TemplateRepo {
    param([string]$RepoType)
    switch ($RepoType) {
        "python" { return "paidhima/template-python" }
        "powershell" { return "paidhima/template-powershell" }
        default { throw "Unsupported type: $RepoType" }
    }
}

Assert-Command -Name "gh"
Assert-Command -Name "git"

Write-Host "Verifying GitHub CLI authentication..."
gh auth status | Out-Null

if (-not (Test-Path $WorkspaceRoot)) {
    Write-Host "Creating workspace root: $WorkspaceRoot"
    New-Item -ItemType Directory -Path $WorkspaceRoot -Force | Out-Null
}

$fullRepo = "$Owner/$RepoName"
$template = Get-TemplateRepo -RepoType $Type
$repoPath = Join-Path $WorkspaceRoot $RepoName

Write-Host "Provisioning repository: $fullRepo"
Write-Host "Type: $Type"
Write-Host "Template: $template"
Write-Host "Visibility: $Visibility"

if (Test-Path $repoPath) {
    throw "Target path already exists: $repoPath"
}

Push-Location $WorkspaceRoot
try {
    $visibilityFlag = if ($Visibility -eq "private") { "--private" } else { "--public" }

    gh repo create $fullRepo --template $template $visibilityFlag --clone

    if (-not (Test-Path $repoPath)) {
        throw "Repository was created but local clone path was not found: $repoPath"
    }
}
finally {
    Pop-Location
}

if (-not $SkipBranchProtection) {
    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $protectScript = Join-Path $scriptRoot "protect-main.ps1"
    if (Test-Path $protectScript) {
        Write-Host "Applying baseline branch protection..."
        & $protectScript -Repo $RepoName
    }
    else {
        Write-Warning "Branch protection script not found at $protectScript"
    }
}

if (-not $SkipBootstrapBranch) {
    Push-Location $repoPath
    try {
        Write-Host "Creating bootstrap branch..."
        git checkout -b feature/bootstrap-repo-standards | Out-Null
    }
    finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Provisioning complete." -ForegroundColor Green
Write-Host "Local path: $repoPath"
Write-Host "Next steps:"
Write-Host "  1) Update placeholders and README content."
Write-Host "  2) Run quality checks for the selected template."
Write-Host "  3) Commit bootstrap changes and open a PR."
