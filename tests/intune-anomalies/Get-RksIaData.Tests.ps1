BeforeAll {
    if ($env:MAESTER_MANIFEST) { Import-Module $env:MAESTER_MANIFEST -Force } else { Import-Module Maester -MinimumVersion 3.0.0 -Force }
    . (Join-Path $PSScriptRoot '../../intune-anomalies/helpers/Get-RksIaData.ps1')
    function Get-RKIntuneAnomalyData { }
}

Describe 'Get-RksIaData' {
    BeforeEach {
        $script:RksIaMemo = $null
        $script:cache = @{}
        Mock Get-MgContext { [pscustomobject]@{ TenantId = 't1' } }
        Mock Get-MtSession { @{ GraphCache = $script:cache } }
        Mock Get-RKIntuneAnomalyData { [pscustomobject]@{ N = [guid]::NewGuid() } }
    }
    It 'Collects once per run' {
        $a = Get-RksIaData; $b = Get-RksIaData
        $a.N | Should -Be $b.N
        Should -Invoke Get-RKIntuneAnomalyData -Times 1 -Exactly
    }
    It 'Collects again when Maester starts a new run' {
        $null = Get-RksIaData
        $script:cache = @{}
        $null = Get-RksIaData
        Should -Invoke Get-RKIntuneAnomalyData -Times 2 -Exactly
    }
    It 'Collects again for another tenant' {
        $null = Get-RksIaData
        Mock Get-MgContext { [pscustomobject]@{ TenantId = 't2' } }
        $null = Get-RksIaData
        Should -Invoke Get-RKIntuneAnomalyData -Times 2 -Exactly
    }
    It 'Collects again after a reconnect with other scopes' {
        $null = Get-RksIaData
        Mock Get-MgContext { [pscustomobject]@{ TenantId = 't1'; Scopes = @('BitlockerKey.ReadBasic.All') } }
        $null = Get-RksIaData
        Should -Invoke Get-RKIntuneAnomalyData -Times 2 -Exactly
    }
    It 'Remembers a failed collection and rethrows it' {
        Mock Get-RKIntuneAnomalyData { throw 'Graph said no' }
        { Get-RksIaData } | Should -Throw '*Graph said no*'
        { Get-RksIaData } | Should -Throw '*Graph said no*'
        Should -Invoke Get-RKIntuneAnomalyData -Times 1 -Exactly
    }
}
