[CmdletBinding()]
param(
    [string]$DestinationRoot = [Environment]::GetFolderPath('UserProfile'),
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$sourceSkills = Join-Path $repositoryRoot '.agents\skills'
$sourceRules = Join-Path $repositoryRoot '.codex\AGENTS.md'
$destinationSkills = Join-Path $DestinationRoot '.agents\skills'
$destinationRules = Join-Path $DestinationRoot '.codex\AGENTS.md'

if (-not (Test-Path -LiteralPath $sourceSkills -PathType Container)) {
    throw "Source skills directory not found: $sourceSkills"
}

if (-not (Test-Path -LiteralPath $sourceRules -PathType Leaf)) {
    throw "Source AGENTS.md not found: $sourceRules"
}

$sourceSkillDirectories = Get-ChildItem -LiteralPath $sourceSkills -Directory
$conflicts = @(
    $sourceSkillDirectories |
        Where-Object { Test-Path -LiteralPath (Join-Path $destinationSkills $_.Name) } |
        ForEach-Object { Join-Path $destinationSkills $_.Name }
)

if (-not $Force -and $conflicts.Count -gt 0) {
    throw "Existing skill directories found. They were not changed: $($conflicts -join ', '). Re-run with -Force only after reviewing them."
}

if (-not $Force -and (Test-Path -LiteralPath $destinationRules -PathType Leaf)) {
    throw "Existing global rules found. They were not changed: $destinationRules. Re-run with -Force only after reviewing them."
}

New-Item -ItemType Directory -Path $destinationSkills -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path -Parent $destinationRules) -Force | Out-Null

foreach ($skill in $sourceSkillDirectories) {
    Copy-Item -LiteralPath $skill.FullName -Destination (Join-Path $destinationSkills $skill.Name) -Recurse -Force
}

Copy-Item -LiteralPath $sourceRules -Destination $destinationRules -Force

Write-Host "Installed $($sourceSkillDirectories.Count) skills to $destinationSkills"
Write-Host "Installed global rules to $destinationRules"
Write-Host 'Restart Codex before starting a new session.'
