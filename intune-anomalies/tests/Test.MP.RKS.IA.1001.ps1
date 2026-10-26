function Test-RksIaBitLocker {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1001',
        Title        = 'Windows devices are BitLocker-encrypted and their recovery key is in Entra ID',
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
        # Also list devices that a BitLocker policy leaves out on purpose (exclude group or assignment filter).
        [bool] $IncludeExcludedDevices = $false
    )

    $data = Get-RksIaData
    if (-not $data.BitLockerKeysReadable) {
        Add-MtTestResultDetail -SkippedBecause Custom -SkippedCustomReason 'BitLocker recovery keys could not be read (access denied). Check that the connection has BitlockerKey.ReadBasic.All and that the account has a role that may read them, such as Global Reader (see the pack README), then run again.'
    }
    if (@($data.Devices | Where-Object { -not $_.IsCloudPC }).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneBitLockerAnomalies -Data $data
    $rows = @(Sort-RksIaRow -Rows @($resolved.Rows | Where-Object Severity -NE 'Info'))
    $info = if ($IncludeExcludedDevices) { @($resolved.Rows | Where-Object Severity -EQ 'Info') } else { @() }
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -InfoRows $info -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'device' -Columns DeviceName, PrimaryUser, Serialnumber, IsEncrypted, KeyEscrowed, Severity, Status)
    $rows.Count -eq 0
}
