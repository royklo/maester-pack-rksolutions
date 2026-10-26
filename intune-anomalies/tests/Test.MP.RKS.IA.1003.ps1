function Test-RksIaCompliance {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1003',
        Title        = 'Windows devices are compliant',
        Product      = 'intune',
        Feature      = 'device-compliance',
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

    $resolved = Resolve-IntuneNoncompliantDevices -Data $data
    $rows = @($resolved.Rows)
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'failing rule' -Columns DeviceName, PrimaryUser, NoncompliantBasedOn)
    $rows.Count -eq 0
}
