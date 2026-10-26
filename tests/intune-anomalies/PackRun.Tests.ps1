BeforeAll {
    if ($env:MAESTER_MANIFEST) { Import-Module $env:MAESTER_MANIFEST -Force } else { Import-Module Maester -MinimumVersion 3.0.0 -Force }
    Import-Module Microsoft.Graph.Authentication
    . (Join-Path $PSScriptRoot 'FakeGraph.ps1')
    $pack = Join-Path $PSScriptRoot '../../intune-anomalies'
    function Invoke-FakedRun([string] $Scenario) {
        $global:SimScenario = $Scenario
        $global:SimCalls.Clear()
        Clear-MtGraphCache
        @(Invoke-MtTest -Path $pack)
    }
}

AfterAll {
    foreach ($f in 'Get-MgContext', 'Get-MgEnvironment', 'Invoke-MgGraphRequest') { Remove-Item "function:global:$f" -ErrorAction SilentlyContinue }
    Remove-Variable SimScenario, SimCalls, SimData -Scope Global -ErrorAction SilentlyContinue
    Clear-MtGraphCache
}

# A renamed resolver, property or column in the synced core breaks the test bodies, which a run without a tenant
# (every test skipped as ServiceNotConnected) never executes.
Describe 'The eight tests against faked Graph' {
    It 'Run on normal data: eight results, none errored or skipped' {
        $rows = Invoke-FakedRun 'Happy'
        $rows.Count | Should -Be 8
        @($rows | Where-Object Result -EQ 'Error') | Should -BeNullOrEmpty
        @($rows | Where-Object Result -EQ 'Skipped') | Should -BeNullOrEmpty
    }
    It 'Skip 1001 and 1002 on a 403 and run the other six' {
        $rows = Invoke-FakedRun 'Forbidden'
        $rows.Count | Should -Be 8
        @($rows | Where-Object Result -EQ 'Skipped').Id | Sort-Object | Should -Be 'MP.RKS.IA.1001', 'MP.RKS.IA.1002'
        @($rows | Where-Object { $_.Result -in 'Error', 'Skipped' }).Count | Should -Be 2
    }
    It 'Error all eight on a 400 and read managedDevices once' {
        $rows = Invoke-FakedRun 'Broken'
        @($rows | Where-Object Result -EQ 'Error').Count | Should -Be 8
        @($global:SimCalls | Where-Object { $_ -like '*beta/deviceManagement/managedDevices?*' }).Count | Should -Be 1
    }
}
