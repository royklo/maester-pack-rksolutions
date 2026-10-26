<#
.SYNOPSIS
    Local gates for the pack. -Scan: Test-MtPack must be valid, Low, 0 findings. -Run: every test of the pack runs
    through the engine without a tenant and none is invalid.
#>
[CmdletBinding()]
param(
    [switch] $Scan,
    [switch] $Run,
    [string] $MaesterManifest = $env:MAESTER_MANIFEST,
    [string] $Pack = (Join-Path $PSScriptRoot '../intune-anomalies')
)
$ErrorActionPreference = 'Stop'
if (-not ($Scan -or $Run)) { throw 'Pass -Scan, -Run or both.' }
if ($MaesterManifest) { Import-Module $MaesterManifest -Force }
elseif (-not (Get-Module -ListAvailable Maester | Where-Object Version -GE '3.0.0')) { throw 'Maester 3.0 or later is required: install it (Install-PSResource Maester -Prerelease) or set MAESTER_MANIFEST to its Maester.psd1.' }
else { Import-Module Maester -MinimumVersion 3.0.0 -Force }
if (-not (Get-Command Test-MtPack -ErrorAction SilentlyContinue)) { throw 'Maester 3.0 or later is required (Test-MtPack not found).' }

if ($Scan) {
    $r = Test-MtPack $Pack
    $r | Format-List Id, Version, IsValid, Risk, Errors, Warnings, Findings | Out-String | Write-Host
    if (-not $r.IsValid -or $r.Risk -ne 'Low' -or @($r.Findings).Count -gt 0) { throw 'SCAN FAILED' }
    Write-Output 'SCAN OK: valid, Low, 0 findings'
}
if ($Run) {
    $rows = @(Invoke-MtTest -Path $Pack)
    $rows | Format-Table Id, Result, ReasonCode -AutoSize | Out-String -Width 200 | Write-Host
    $broken = @($rows | Where-Object { $_.ReasonCode -in 'InvalidMetadata', 'InvalidReturn', 'InvalidConfiguration', 'InvalidInstanceId', 'InstanceSourceFailed', 'DuplicateId' -or $_.Result -eq 'Error' })
    if ($broken -or $rows.Count -ne 8) { throw "RUN FAILED: $($rows.Count) rows, invalid or errored: $($broken.Id -join ', ')" }
    Write-Output 'RUN OK: 8 tests, none invalid or errored'
}
