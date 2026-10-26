function Get-RksIaData {
    <#
    .SYNOPSIS
        Returns the Intune anomaly data, collected at most once per Maester run and tenant. A failed collection is
        remembered too and rethrown, so the eight tests do not each retry it.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $tenantId = [string](Get-MgContext).TenantId
    # The scopes are part of the key: after a reconnect with more scopes outside Invoke-Maester the data is read again.
    $scopes = (@((Get-MgContext).Scopes) | Sort-Object) -join ' '
    $runCache = (Get-MtSession).GraphCache
    $memo = $script:RksIaMemo
    # ponytail: keyed on Maester's per-run GraphCache identity; a public run ID from Maester would be the cleaner signal.
    $reuse = $memo -and $tenantId -and $null -ne $runCache -and $memo.TenantId -eq $tenantId -and $memo.Scopes -eq $scopes -and
        [object]::ReferenceEquals($memo.RunCache.Target, $runCache)
    if (-not $reuse) {
        $data = $null; $failure = $null
        try { $data = Get-RKIntuneAnomalyData } catch { $failure = $_ }
        $memo = [pscustomobject]@{ TenantId = $tenantId; Scopes = $scopes; RunCache = [System.WeakReference]::new($runCache); Data = $data; Failure = $failure }
        $script:RksIaMemo = $memo
    }
    if ($memo.Failure) { throw $memo.Failure }
    $memo.Data
}
