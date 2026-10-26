function Test-RksIaDeprecated {
    [MaesterTest(
        Id           = 'MP.RKS.IA.1008',
        Title        = 'Settings Catalog policies use no deprecated settings',
        Product      = 'intune',
        Feature      = 'device-configuration',
        Area         = 'devices',
        ResourceType = 'Policy',
        Severity     = 'Low',
        Service      = 'Graph',
        License      = 'INTUNE_A',
        Author       = 'royklo'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $data = Get-RksIaData
    if (@($data.SecurityKeyContext.ConfigurationPolicies).Count -eq 0) { Add-MtTestResultDetail -SkippedBecause NotApplicable }

    $resolved = Resolve-IntuneDeprecatedAnomalies -Data $data
    $rows = @($resolved.Rows)
    Add-MtTestResultDetail -Result (Format-RksIaResult -Rows $rows -Warnings @($resolved.Warnings) -CollectedAt $data.CollectedAt -Noun 'setting' -Columns PolicyName, Platform, SettingDisplayName, ConfiguredValue)
    $rows.Count -eq 0
}
