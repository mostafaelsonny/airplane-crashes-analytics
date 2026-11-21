# ==============================================================================
# Setup GitHub Repository (PowerShell) - Real-Time Airplane Crashes Analytics
# ==============================================================================
param(
    [string]$RepoName = "airplane-crashes-analytics",
    [string]$Visibility = "public",
    [string[]]$Collaborators = @()
)

$ErrorActionPreference = "Stop"

Write-Host ">>> Checking Git and GitHub CLI..." -ForegroundColor Cyan
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is not installed."
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) is not installed. Please install from https://cli.github.com"
}

# Verify login
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ">>> Logging in to GitHub..." -ForegroundColor Yellow
    gh auth login
}

Set-Location -Path "$PSScriptRoot\.."

if (-not (Test-Path ".git")) {
    Write-Host ">>> Initializing local git repository..." -ForegroundColor Cyan
    git init -b main
}

git add -A
git commit -m "chore: initial project scaffold and architecture governance" 2>$null

Write-Host ">>> Creating repository '$RepoName' on GitHub ($Visibility)..." -ForegroundColor Cyan
gh repo create $RepoName "--$Visibility" --source=. --remote=origin --push

Write-Host ">>> Pushing and configuring develop branch..." -ForegroundColor Cyan
git checkout -B develop
git push -u origin develop
gh repo edit --default-branch develop

Write-Host ">>> Setting up Project Labels..." -ForegroundColor Cyan
function Add-Label($name, $color, $desc) {
    gh label create $name --color $color --description $desc --force 2>$null
}

Add-Label "sprint-1"          "1d76db" "Sprint 1 — Foundation & PoC"
Add-Label "sprint-2"          "0e8a16" "Sprint 2 — Analytics & Processing"
Add-Label "sprint-3"          "fbca04" "Sprint 3 — Integration & Optimization"
Add-Label "leader"            "2cbe4e" "Team Leader & Architecture Review"
Add-Label "data-engineering"  "e3b341" "Data Producer & Dataset Inspection"
Add-Label "infrastructure"    "f66a0a" "Docker, Kafka & Networking"
Add-Label "etl-nifi"          "d73a4a" "Apache NiFi ETL & Routing"
Add-Label "spark-processing"  "8250df" "Apache Spark Structured Streaming"
Add-Label "database"          "0969da" "PostgreSQL & Database Schema"
Add-Label "data-contract"     "5319e7" "Unified Data Contract"
Add-Label "task"              "ededed" "Sprint Task"
Add-Label "bug"               "b60205" "Something is broken or failing"
Add-Label "blocked"           "d73a4a" "Blocked by dependency"
Add-Label "needs-fixes"       "e99695" "Reviewed by Mostafa - changes requested"

Write-Host ">>> Setting up Milestones..." -ForegroundColor Cyan
foreach ($s in 1..3) {
    gh api "repos/{owner}/{repo}/milestones" -f title="Sprint $s" 2>$null
}

Write-Host ">>> Applying Rulesets (protect main & develop)..." -ForegroundColor Cyan
foreach ($b in @("main", "develop")) {
    $rulesetPath = ".github/rulesets/protect-$b.json"
    if (Test-Path $rulesetPath) {
        gh api -X POST "repos/{owner}/{repo}/rulesets" --input $rulesetPath 2>$null
        Write-Host "Applied ruleset for $b" -ForegroundColor Green
    }
}

foreach ($user in $Collaborators) {
    if ($user) {
        gh api -X PUT "repos/{owner}/{repo}/collaborators/$user" -f permission=push 2>$null
        Write-Host "Invited collaborator: $user" -ForegroundColor Green
    }
}

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host "Done! Only Mostafa (@mostafaelsonny) has permission to review & merge PRs." -ForegroundColor Green
Write-Host "Repository URL: $(gh repo view --json url -q .url)" -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green
