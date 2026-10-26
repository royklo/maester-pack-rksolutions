function Test-RksIaAutopilot {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1006',
        Title        = 'Windows devices are registered in Windows Autopilot',
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
    param()

    $data = Get-RksIaData
    if (@($data.Devices | Where-Object { -not $_.IsCloudPC }).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneMissingAutopilotDevices -Data $data
    $rows = @($resolved.Rows)
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'device' -Columns DeviceName, PrimaryUser, Serialnumber, DeviceManufacturer, DeviceModel)
    $rows.Count -eq 0
}
