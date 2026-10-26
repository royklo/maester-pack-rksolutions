BeforeAll {
    if ($env:MAESTER_MANIFEST) { Import-Module $env:MAESTER_MANIFEST -Force } else { Import-Module Maester -MinimumVersion 3.0.0 -Force }
    $root = Join-Path $PSScriptRoot '../../intune-anomalies/helpers'
    . (Join-Path $root 'core/RKCoreGraph.ps1')
    . (Join-Path $root 'GraphAdapter.ps1')
}

Describe 'Pack adapters' {
    It 'Invoke-RKCoreGraphRequest -All lets Maester page' {
        Mock Invoke-MtGraphRequest { @(1, 2, 3) }
        @(Invoke-RKCoreGraphRequest -Uri 'beta/deviceManagement/managedDevices?$select=id' -All) | Should -Be @(1, 2, 3)
        Should -Invoke Invoke-MtGraphRequest -Times 1 -ParameterFilter { $RelativeUri -eq 'deviceManagement/managedDevices?$select=id' -and $ApiVersion -eq 'beta' -and -not $DisablePaging }
    }
    It 'Invoke-RKCoreGraphRequest without -All asks for the raw body' {
        Mock Invoke-MtGraphRequest { [pscustomobject]@{ value = @(1) } }
        $null = Invoke-RKCoreGraphRequest -Uri 'v1.0/organization'
        Should -Invoke Invoke-MtGraphRequest -Times 1 -ParameterFilter { $ApiVersion -eq 'v1.0' -and $DisablePaging }
    }
    It 'Invoke-RKCoreGraphBatch returns 200 and the error status per request' {
        Mock Invoke-MtGraphRequest -ParameterFilter { $RelativeUri -eq 'groups/gone' } {
            $response = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::NotFound)
            throw [Microsoft.Graph.PowerShell.Authentication.Helpers.HttpResponseException]::new('Not found', $response)
        }
        Mock Invoke-MtGraphRequest -ParameterFilter { $RelativeUri -eq 'groups/ok' } { [pscustomobject]@{ id = 'ok' } }
        $out = @(Invoke-RKCoreGraphBatch -Requests @([pscustomobject]@{ Id = 'a'; Url = 'v1.0/groups/ok' }, [pscustomobject]@{ Id = 'b'; Url = 'v1.0/groups/gone' }))
        ($out | Where-Object Id -EQ 'a').Status | Should -Be 200
        ($out | Where-Object Id -EQ 'b').Status | Should -Be 404
    }
    It 'Invoke-RKCoreGraphBatch carries the message when the status is unreadable' {
        Mock Invoke-MtGraphRequest { throw 'socket closed' }
        $out = @(Invoke-RKCoreGraphBatch -Requests @([pscustomobject]@{ Id = 'a'; Url = 'v1.0/groups/x' }))
        $out[0].Status | Should -Be 0
        $out[0].Body.error.message | Should -BeLike '*socket closed*'
    }
}
