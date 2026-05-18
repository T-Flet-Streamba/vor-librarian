#Requires -Version 5.1
<#
.SYNOPSIS
  Installs the vor-librarian Cursor skill (SKILL.md + vor-librarian.json).

.DESCRIPTION
  Fetches skill/local/SKILL.md from streamba/vor-librarian via GitHub CLI and writes
  to ~/.cursor/skills/vor-librarian/ (default) or ./.cursor/skills/vor-librarian/

.PARAMETER Project
  Install to the current directory's .cursor/skills/ instead of the user profile.

.PARAMETER Ref
  Git branch or tag for GitHub API fetches (default: master).

.PARAMETER Repo
  GitHub repository owner/name (default: streamba/vor-librarian).
#>
[CmdletBinding()]
param(
    [switch]$Project,
    [string]$Ref = 'master',
    [string]$Repo = 'streamba/vor-librarian'
)

$ErrorActionPreference = 'Stop'

$SkillName = 'vor-librarian'
$LocalSkillPath = 'skill/local/SKILL.md'

function Assert-GhInstalled {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw 'GitHub CLI (gh) is required. Install from https://cli.github.com and run: gh auth login'
    }
}

function Get-GhRepoFileContent {
    param(
        [string]$Repository,
        [string]$GitRef,
        [string]$FilePath
    )
    $endpoint = "repos/$Repository/contents/${FilePath}?ref=$GitRef"
    $output = gh api $endpoint -H 'Accept: application/vnd.github.raw' 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "gh api failed for $Repository@${GitRef}:$FilePath : $output"
    }
    return $output
}

function Get-SkillsRoot {
    if ($Project) {
        return Join-Path (Join-Path (Get-Location) '.cursor') 'skills'
    }
    return Join-Path (Join-Path $env:USERPROFILE '.cursor') 'skills'
}

Assert-GhInstalled

$skillsRoot = Get-SkillsRoot
$targetDir = Join-Path $skillsRoot $SkillName

if (-not (Test-Path $skillsRoot)) {
    New-Item -ItemType Directory -Path $skillsRoot -Force | Out-Null
}
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

$localSkillFile = $null
if ($PSScriptRoot) {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
    $localSkillFile = Join-Path $repoRoot ($LocalSkillPath -replace '/', [IO.Path]::DirectorySeparatorChar)
}

$skillContent = $null
try {
    Write-Host "Fetching ${Repo}@${Ref}:${LocalSkillPath} via gh ..."
    $skillContent = Get-GhRepoFileContent -Repository $Repo -GitRef $Ref -FilePath $LocalSkillPath
}
catch {
    if ($localSkillFile -and (Test-Path $localSkillFile)) {
        Write-Warning "Remote fetch failed; using local SKILL.md from repository ($localSkillFile)."
        $skillContent = Get-Content -Path $localSkillFile -Raw -Encoding UTF8
    }
    else {
        throw
    }
}

$scope = if ($Project) { 'project' } else { 'personal' }
$installedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')

$config = @{
    repo          = $Repo
    ref           = $Ref
    installedAt   = $installedAt
    installScope  = $scope
} | ConvertTo-Json -Depth 3

$skillPath = Join-Path $targetDir 'SKILL.md'
$configPath = Join-Path $targetDir 'vor-librarian.json'

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($skillPath, $skillContent, $utf8NoBom)
[System.IO.File]::WriteAllText($configPath, $config, $utf8NoBom)

Write-Host ""
Write-Host "vor-librarian installed successfully." -ForegroundColor Green
Write-Host "  Location:  $targetDir"
Write-Host "  Repo:      $Repo"
Write-Host "  Ref:       $Ref"
Write-Host "  Scope:     $scope"
Write-Host ""
Write-Host "Invoke the skill in Cursor (e.g. @vor-librarian)."
Write-Host "Maintainers: edit vor-librarian.json to change repo/ref for branch testing."
