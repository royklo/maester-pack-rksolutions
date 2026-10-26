function Invoke-RKCoreGraphRequest {
    <#
    .SYNOPSIS
        The pack's implementation of the core's single-request adapter, on Invoke-MtGraphRequest (cached per run).
        Without -All: the raw body. With -All: every item, paged by Maester. Throws on an HTTP error.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Uri,
        [switch] $All
    )

    $target = ConvertTo-RKCoreGraphPath -Uri $Uri
    # Parameters by name: the pack scanner counts a splat into Invoke-MtGraphRequest as a possible tenant write.
    if ($All) { return @(Invoke-MtGraphRequest -RelativeUri $target.Path -ApiVersion $target.Version) }
    Invoke-MtGraphRequest -RelativeUri $target.Path -ApiVersion $target.Version -DisablePaging
}

function Invoke-RKCoreGraphBatch {
    <#
    .SYNOPSIS
        The pack's implementation of the core's batch adapter: one GET per request, returning Id, Status and Body.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Requests)

    # ponytail: one GET per sub-request; switch to batching if Maester exposes per-request batch results.
    foreach ($request in $Requests) {
        $target = ConvertTo-RKCoreGraphPath -Uri $request.Url
        try {
            $body = Invoke-MtGraphRequest -RelativeUri $target.Path -ApiVersion $target.Version -DisablePaging
            [pscustomobject]@{ Id = [string]$request.Id; Status = 200; Body = $body }
        }
        catch {
            $status = Get-RKCoreGraphErrorStatus -ErrorRecord $_
            # Without a readable status the exception message is the only error text; the core reads body.error.message.
            $body = if ($status -eq 0) { [pscustomobject]@{ error = [pscustomobject]@{ message = $_.Exception.Message } } }
            [pscustomobject]@{ Id = [string]$request.Id; Status = $status; Body = $body }
        }
    }
}
