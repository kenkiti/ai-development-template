#requires -Version 7.0
<#
.SYNOPSIS
Creates or validates a project from the development template.
.DESCRIPTION
Performs safe mechanical creation, cloning, validation, and optional local initialization. Never pushes.
.PARAMETER ProjectName
Repository and local directory name.
.PARAMETER Description
Repository description.
.PARAMETER LocalParent
Parent directory for the local clone.
.PARAMETER Visibility
GitHub repository visibility.
.PARAMETER Owner
GitHub owner.
.PARAMETER AllowPublic
Allows public creation after an explicit safety decision.
.PARAMETER SkipCommit
Skips the optional local initialization commit in validation mode.
.PARAMETER ValidateOnly
Validates an existing local project without creating or cloning.
.EXAMPLE
./tools/init-project.ps1 -ProjectName app -Description "App" -LocalParent C:\src
.EXAMPLE
./tools/init-project.ps1 -ProjectName app -Description "App" -LocalParent C:\src -ValidateOnly
.EXAMPLE
./tools/init-project.ps1 -ProjectName app -Description "App" -LocalParent C:\src -Visibility public -AllowPublic -WhatIf
.NOTES
Requires PowerShell 7+, git, and GitHub CLI. The script never pushes.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$ProjectName,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Description,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$LocalParent,
    [ValidateSet('private', 'public')][string]$Visibility = 'private',
    [ValidateNotNullOrEmpty()][string]$Owner = 'kenkiti',
    [switch]$AllowPublic,
    [switch]$SkipCommit,
    [switch]$ValidateOnly
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$TemplateRepository = 'kenkiti/ai-development-template'
$RequiredFiles = @('README.md','AGENTS.md','CLAUDE.md','DESIGN.md','CHANGELOG.md','LICENSE','docs/DEVELOPMENT.md','docs/HANDOFF.md','docs/ADR/README.md','docs/ADR/0000-template.md','docs/research/README.md','tools/NEW_PROJECT.md','tools/UPDATE_TEMPLATE.md','tools/RELEASE.md','tools/init-project.ps1')
$InitializationFiles = @('README.md','CLAUDE.md','DESIGN.md','docs/HANDOFF.md')

function Assert-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) { throw "Required command is missing: $Name" }
}
function Invoke-Checked([string]$Name, [string[]]$Arguments, [string]$Purpose) {
    $output = & $Name @Arguments 2>&1
    $code = $LASTEXITCODE
    if ($code -ne 0) { throw "$Purpose failed (exit code $code). Review the command output without exposing credentials. $([Environment]::NewLine)$($output -join [Environment]::NewLine)" }
    return @($output)
}
function Get-PlaceholderResults([string]$Root) {
    Get-ChildItem -LiteralPath $Root -Recurse -File -Force |
        Where-Object { $_.FullName -notmatch '[\\/](\.git|node_modules|bin|obj|dist|build|coverage)[\\/]' } |
        Select-String -Pattern '<[^>]+>|TBD-REQUIRED-BEFORE-IMPLEMENTATION|TBD-REQUIRED-BEFORE-RELEASE|TBD-OPTIONAL|ai-development-template'
}
function Assert-RequiredFiles([string]$Root) {
    $missing = @($RequiredFiles | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Root $_) -PathType Leaf) })
    if ($missing.Count -gt 0) { throw "Required files are missing: $($missing -join [Environment]::NewLine)" }
}
function Invoke-ProjectValidation {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$Root)
    Assert-RequiredFiles $Root
    Push-Location $Root
    try {
        $status = @(Invoke-Checked 'git' @('status','--short') 'Git status')
        $branch = @(Invoke-Checked 'git' @('branch','--show-current') 'Git branch check')
        $origin = @(Invoke-Checked 'git' @('remote','get-url','origin') 'Origin check')
        $null = Invoke-Checked 'git' @('diff','--check') 'Git diff check'
        $placeholders = @(Get-PlaceholderResults $Root)
        $blocking = @($placeholders | Where-Object { $_.Path -match '(CLAUDE|DESIGN)\.md$|docs[\\/]HANDOFF\.md$' -and $_.Line -match 'TBD-REQUIRED-BEFORE-IMPLEMENTATION' })
        Write-Output 'BLOCKING BEFORE IMPLEMENTATION'; $blocking | ForEach-Object { Write-Output $_ }
        Write-Output 'BLOCKING BEFORE RELEASE'; @($placeholders | Where-Object { $_.Path -match '(CLAUDE|DESIGN)\.md$|docs[\\/]HANDOFF\.md$' -and $_.Line -match 'TBD-REQUIRED-BEFORE-RELEASE' }) | ForEach-Object { Write-Output $_ }
        Write-Output 'OPTIONAL'; @($placeholders | Where-Object { $_.Line -match 'TBD-OPTIONAL' }) | ForEach-Object { Write-Output $_ }
        Write-Output 'TEMPLATE REFERENCES TO REVIEW'; @($placeholders | Where-Object { $_.Line -match 'ai-development-template' }) | ForEach-Object { Write-Output $_ }
        if (-not $SkipCommit -and $blocking.Count -eq 0 -and $status.Count -gt 0 -and $PSCmdlet.ShouldProcess($Root, 'Create initialization commit')) {
            $filesToCommit = $InitializationFiles
            $existing = @($filesToCommit | Where-Object { Test-Path -LiteralPath (Join-Path $Root $_) })
            $null = Invoke-Checked 'git' (@('add') + $existing) 'Stage initialization files'
            $null = Invoke-Checked 'git' @('commit','-m','Initialize project from development template') 'Create initialization commit'
        }
        Write-Output "Repository: $Owner/$ProjectName"
        Write-Output "Local path: $Root"
        Write-Output "Branch: $($branch -join '')"
        Write-Output "Origin: $($origin -join '')"
        Write-Output "Commit status: $(if ($SkipCommit) { 'SKIPPED' } else { 'CHECKED' })"
        Write-Output 'Push status: NOT PUSHED — script does not push'
    } finally { Pop-Location }
}
try {
    if ($PSVersionTable.PSVersion.Major -lt 7) { throw 'PowerShell 7 or later is required.' }
    if ($Visibility -eq 'public' -and -not $AllowPublic) { throw 'Public creation requires -AllowPublic.' }
    Assert-Command 'git'; Assert-Command 'gh'
    $projectPath = Join-Path $LocalParent $ProjectName
    if ($ValidateOnly) {
        if (-not (Test-Path -LiteralPath $projectPath -PathType Container)) { throw "Validation path does not exist: $projectPath" }
        Invoke-ProjectValidation $projectPath
        exit 0
    }
    if (-not (Test-Path -LiteralPath $LocalParent -PathType Container)) { throw "LocalParent is not a directory: $LocalParent" }
    $null = Invoke-Checked 'gh' @('auth','status') 'GitHub authentication check'
    $repoCheck = & gh repo view "$Owner/$ProjectName" 2>&1
    if ($LASTEXITCODE -eq 0) { throw "GitHub repository already exists: $Owner/$ProjectName" }
    if (($repoCheck -join ' ') -notmatch 'not found|Could not resolve|404') { throw "Unable to distinguish repository absence from access or network failure. $($repoCheck -join [Environment]::NewLine)" }
    if (Test-Path -LiteralPath $projectPath) { throw "Local project path already exists: $projectPath" }
    if ($Visibility -eq 'public') { Write-Warning '-AllowPublic does not guarantee that secrets, personal data, or internal records have been audited.' }
    Push-Location $LocalParent
    try {
        $visibilityArgs = if ($Visibility -eq 'public') { @('--public') } else { @('--private') }
        $args = @('repo','create',"$Owner/$ProjectName",'--template',$TemplateRepository) + $visibilityArgs + @('--description',$Description,'--clone')
        if (-not $PSCmdlet.ShouldProcess("$Owner/$ProjectName and $projectPath", 'Create and clone GitHub repository')) { return }
        $null = Invoke-Checked 'gh' $args 'Create and clone repository'
    } finally { Pop-Location }
    Invoke-ProjectValidation $projectPath
    Write-Output 'Next action: edit project-specific files, then run -ValidateOnly.'
} catch {
    Write-Error $_
    exit 1
}
