# protect-main.ps1 — Apply baseline branch protection to a repo's default branch
#
# Usage:
#   .\scripts\protect-main.ps1 -Repo conduit
#   .\scripts\protect-main.ps1 -All
#
# Prerequisites: gh CLI authenticated with repo scope

[CmdletBinding()]
param(
    [Parameter(ParameterSetName = "Single")]
    [string]$Repo,

    [Parameter(ParameterSetName = "All")]
    [switch]$All
)

$ErrorActionPreference = "Stop"
$Owner = "paidhima"

function Protect-Repo {
    param([string]$RepoName)

    $defaultBranch = gh api "repos/${Owner}/${RepoName}" --jq ".default_branch" 2>&1
    if (-not $defaultBranch) {
        Write-Host "  FAILED: ${RepoName} - could not determine default branch" -ForegroundColor Red
        return
    }

    Write-Host "Applying branch protection to ${Owner}/${RepoName} (${defaultBranch})..."

    $body = @{
        required_status_checks        = $null
        enforce_admins                = $true
        required_pull_request_reviews = @{
            required_approving_review_count = 0
        }
        restrictions                  = $null
    } | ConvertTo-Json -Depth 3

    try {
        $body | gh api "repos/${Owner}/${RepoName}/branches/${defaultBranch}/protection" -X PUT --input - 2>&1 | Out-Null
        Write-Host "  OK: ${RepoName}" -ForegroundColor Green
    }
    catch {
        Write-Host "  FAILED: ${RepoName} - $_" -ForegroundColor Red
    }
}

if ($All) {
    Write-Host "Applying branch protection to all non-archived repos..."
    $repos = gh repo list $Owner --limit 100 --json name,isArchived `
        --jq '.[] | select(.isArchived == false) | .name' 2>&1
    foreach ($repo in $repos) {
        if ($repo) { Protect-Repo -RepoName $repo }
    }
}
elseif ($Repo) {
    Protect-Repo -RepoName $Repo
}
else {
    Write-Host "Usage:"
    Write-Host "  .\scripts\protect-main.ps1 -Repo <repo-name>"
    Write-Host "  .\scripts\protect-main.ps1 -All"
    exit 1
}
