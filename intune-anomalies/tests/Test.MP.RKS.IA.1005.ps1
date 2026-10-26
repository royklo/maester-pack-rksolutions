function Test-RksIaDisabledUser {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1005',
        Title        = 'The primary user of every Windows device is enabled',
        Product      = 'intune',
        Feature      = 'device-enrollment',
        Area         = 'devices',
        ResourceType = 'Device',
        Severity     = 'Medium',
        Service      = 'Graph',
        License      = 'INTUNE_A',
        Author       = 'royklo'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $data = Get-RksIaData
    if (@($data.Devices).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneDisabledPrimaryUsers -Data $data
    $rows = @($resolved.Rows)
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'device' -Columns DeviceName, PrimaryUser, Serialnumber)
    $rows.Count -eq 0
}
