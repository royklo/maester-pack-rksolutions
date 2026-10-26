<#
.SYNOPSIS
    Copies module/Core/*.ps1 of RKSolutions-Module into intune-anomalies/helpers/core, with a header line naming the commit.
.EXAMPLE
    ./tools/Sync-Core.ps1 -ModuleRoot ../RKSolutions-Module
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $ModuleRoot,
    [string] $Commit
)
$ErrorActionPreference = 'Stop'
$source = Join-Path $ModuleRoot 'module/Core'
$target = Join-Path $PSScriptRoot '../intune-anomalies/helpers/core'
$files = @(Get-ChildItem -LiteralPath $source -Filter '*.ps1' -ErrorAction Stop | Sort-Object Name)
if ($files.Count -eq 0) { throw "No .ps1 files in $source." }
if (-not $Commit) {
    if (git -C $ModuleRoot status --porcelain -- module/Core) { throw 'module/Core has uncommitted changes; commit them first so the header names the code it copies.' }
    $Commit = git -C $ModuleRoot rev-parse --short HEAD
    if ($LASTEXITCODE -ne 0) { throw "git rev-parse failed in $ModuleRoot." }
}
New-Item -ItemType Directory -Path $target -Force | Out-Null
Get-ChildItem -Path $target -Filter '*.ps1' | Remove-Item
foreach ($file in $files) {
    $header = "# Synced from royklo/RKSolutions-Module@$Commit module/Core/$($file.Name). Do not edit here."
    $body = [System.IO.File]::ReadAllText($file.FullName).TrimStart([char]0xFEFF)
    $body = $body -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText((Join-Path $target $file.Name), "$header`n$body", [System.Text.UTF8Encoding]::new($false))
}
Write-Output "Synced $(@(Get-ChildItem $target -Filter '*.ps1').Count) file(s) from $Commit."
