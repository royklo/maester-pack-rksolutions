function Sort-RksIaRow {
    <#
    .SYNOPSIS
        Orders rows by Severity (Critical, Warning, Info) when they have one; otherwise keeps the resolver's order.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Rows)

    if ($Rows.Count -eq 0 -or -not $Rows[0].PSObject.Properties['Severity']) { return $Rows }
    $rank = @{ Critical = 0; Warning = 1; Info = 2 }
    $Rows | Sort-Object -Stable { if ($rank.ContainsKey([string]$_.Severity)) { $rank[[string]$_.Severity] } else { 3 } }
}

function ConvertTo-RksIaCell {
    <#
    .SYNOPSIS
        A value as a markdown table cell: dates short, lists joined, backslashes and pipes escaped, line breaks removed.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param([AllowNull()] $Value)
    if ($Value -is [datetime]) { $text = $Value.ToString('yyyy-MM-dd HH:mm') }
    elseif ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) { $text = @($Value) -join ', ' }
    else { $text = [string]$Value }
    (($text -replace '\\', '\\') -replace '\|', '\|') -replace '\r\n|\n|\r', ' '
}

function ConvertTo-RksIaTable {
    <#
    .SYNOPSIS
        The lines of a markdown table of the given columns, with at most -Max rows.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Rows,
        [Parameter(Mandatory)] [string[]] $Columns,
        [Parameter(Mandatory)] [int] $Max
    )
    '| ' + ($Columns -join ' | ') + ' |'
    '| ' + (($Columns | ForEach-Object { '---' }) -join ' | ') + ' |'
    foreach ($row in @($Rows | Select-Object -First $Max)) {
        '| ' + (($Columns | ForEach-Object { ConvertTo-RksIaCell -Value $row.$_ }) -join ' | ') + ' |'
    }
}

function Format-RksIaResult {
    <#
    .SYNOPSIS
        The markdown result of an anomaly test: "Well done" or a count and a table of at most 200 rows, then the rows
        left out on purpose and the warnings.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [object[]] $Rows,
        [Parameter(Mandatory)] [string[]] $Columns,
        [Parameter(Mandatory)] [string] $Noun,
        [AllowEmptyCollection()] [object[]] $Warnings = @(),
        [AllowEmptyCollection()] [object[]] $InfoRows = @(),
        # When the data was collected; the same in every test of one run, so a reader (and G7) can see it was read once.
        [datetime] $CollectedAt
    )

    # ponytail: 200-row cap keeps the report small; raise it or add a parameter if people need every row in Maester.
    $max = 200
    $lines = [System.Collections.Generic.List[string]]::new()
    if ($Rows.Count -eq 0) { $lines.Add("Well done. No $Noun needs attention.") }
    else {
        $headline = if ($Rows.Count -eq 1) { "1 $Noun needs attention:" } else { "$($Rows.Count) $($Noun)s need attention:" }
        $lines.Add($headline); $lines.Add('')
        foreach ($l in (ConvertTo-RksIaTable -Rows $Rows -Columns $Columns -Max $max)) { $lines.Add($l) }
        if ($Rows.Count -gt $max) { $lines.Add(''); $lines.Add("... and $($Rows.Count - $max) more. Run ``Get-IntuneAnomaliesReport`` from the RKSolutions module for the full list.") }
    }
    if ($InfoRows.Count -gt 0) {
        $lines.Add(''); $lines.Add("$($InfoRows.Count) left out on purpose by an exclude group or an assignment filter:"); $lines.Add('')
        foreach ($l in (ConvertTo-RksIaTable -Rows $InfoRows -Columns $Columns -Max $max)) { $lines.Add($l) }
        if ($InfoRows.Count -gt $max) { $lines.Add(''); $lines.Add("... and $($InfoRows.Count - $max) more.") }
    }
    if ($Warnings.Count -gt 0) {
        $lines.Add(''); $lines.Add('Notes:')
        foreach ($w in $Warnings) { $lines.Add("- $($w.Message)") }
    }
    if ($PSBoundParameters.ContainsKey('CollectedAt')) { $lines.Add(''); $lines.Add("Data collected at $($CollectedAt.ToString('yyyy-MM-dd HH:mm:ss')).") }
    $lines -join "`n"
}
