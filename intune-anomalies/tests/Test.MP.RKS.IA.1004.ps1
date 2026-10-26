function Test-RksIaInactive {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1004',
        Title        = 'Windows devices have checked in with Intune recently',
        Product      = 'intune',
        Feature      = 'device-enrollment',
        Area         = 'devices',
        ResourceType = 'Device',
        Severity     = 'Low',
        Service      = 'Graph',
        License      = 'INTUNE_A',
        Author       = 'royklo'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        # A device that has not synced with Intune for longer than this many days is inactive.
        [ValidateRange(7, 365)] [int] $InactiveDays = 90
    )

    $data = Get-RksIaData
    if (@($data.Devices).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneInactiveDevices -Data $data -Days $InactiveDays
    $rows = @($resolved.Rows)
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'device' -Columns DeviceName, PrimaryUser, Serialnumber, LastContact)
    $rows.Count -eq 0
}
