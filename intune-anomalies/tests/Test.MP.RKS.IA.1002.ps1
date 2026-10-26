function Test-RksIaLaps {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1002',
        Title        = 'Windows devices back up their local administrator password to Entra ID',
        Product      = 'intune',
        Feature      = 'endpoint-security',
        Area         = 'devices',
        ResourceType = 'Device',
        Severity     = 'High',
        Service      = 'Graph',
        License      = 'INTUNE_A',
        Author       = 'royklo'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        # A LAPS backup older than this many days is stale.
        [ValidateRange(1, 365)] [int] $MaximumBackupAgeDays = 60,
        # Also list devices that a LAPS policy leaves out on purpose (exclude group or assignment filter).
        [bool] $IncludeExcludedDevices = $false
    )

    $data = Get-RksIaData
    if (-not $data.LapsCredentialsReadable) {
        Add-MtTestResultDetail -SkippedBecause Custom -SkippedCustomReason 'Windows LAPS passwords could not be read (access denied). Check that the connection has DeviceLocalCredential.ReadBasic.All and that the account has a role that may read them, such as Global Reader (see the pack README), then run again.'
    }
    if (@($data.Devices).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneLapsAnomalies -Data $data -MaxBackupAgeDays $MaximumBackupAgeDays
    $rows = @(Sort-RksIaRow -Rows @($resolved.Rows | Where-Object Severity -NE 'Info'))
    $info = if ($IncludeExcludedDevices) { @($resolved.Rows | Where-Object Severity -EQ 'Info') } else { @() }
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -InfoRows $info -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'device' -Columns DeviceName, PrimaryUser, OwnerType, LastBackupDateTime, BackupAgeDays, Severity, Status)
    $rows.Count -eq 0
}
