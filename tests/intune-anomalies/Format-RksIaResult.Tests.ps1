BeforeAll { . (Join-Path $PSScriptRoot '../../intune-anomalies/helpers/Format-RksIaResult.ps1') }

Describe 'Format-RksIaResult' {
    It 'Says well done without rows' {
        Format-RksIaResult -Rows @() -Columns DeviceName -Noun 'device' | Should -BeLike 'Well done*'
    }
    It 'Caps the table at 200 rows and escapes pipes' {
        $rows = 1..250 | ForEach-Object { [pscustomobject]@{ DeviceName = "D|$_" } }
        $md = Format-RksIaResult -Rows $rows -Columns DeviceName -Noun 'device'
        $md | Should -BeLike '*250 devices*'
        $md | Should -BeLike '*and 50 more*'
        $md | Should -BeLike '*D\|1 |*'
        ([regex]::Matches($md, '(?m)^\| D\\\|')).Count | Should -Be 200
    }
    It 'Uses the singular for one row' {
        Format-RksIaResult -Rows @([pscustomobject]@{ DeviceName = 'A' }) -Columns DeviceName -Noun 'device' | Should -BeLike '1 device needs attention*'
    }
    It 'Lists warnings and info rows' {
        $md = Format-RksIaResult -Rows @([pscustomobject]@{ DeviceName = 'A' }) -Columns DeviceName -Noun 'device' -Warnings @([pscustomobject]@{ Area = 'BitLocker'; Message = 'w' }) -InfoRows @([pscustomobject]@{ DeviceName = 'X' })
        $md | Should -BeLike '*Notes:*- w*'
        $md | Should -BeLike '*left out on purpose*X*'
    }
    It 'Caps the info rows like the main table' {
        $info = 1..205 | ForEach-Object { [pscustomobject]@{ DeviceName = "I$_" } }
        $md = Format-RksIaResult -Rows @() -Columns DeviceName -Noun 'device' -InfoRows $info
        $md | Should -BeLike '*and 5 more*'
        ([regex]::Matches($md, '(?m)^\| I\d')).Count | Should -Be 200
    }
    It 'Ends with the collection time' {
        Format-RksIaResult -Rows @() -Columns DeviceName -Noun 'device' -CollectedAt ([datetime]'2026-10-25 10:42:00') | Should -BeLike '*Data collected at 2026-10-25 10:42:00.'
    }
}

Describe 'Sort-RksIaRow' {
    It 'Orders by severity' {
        $rows = @([pscustomobject]@{ Severity = 'Warning'; N = 2 }, [pscustomobject]@{ Severity = 'Critical'; N = 1 })
        @(Sort-RksIaRow -Rows $rows).N | Should -Be @(1, 2)
    }
}

Describe 'Sort-RksIaRow stability' {
    It 'Keeps the original order within a severity' {
        $rows = @(1..30 | ForEach-Object { [pscustomobject]@{ Severity = 'Warning'; N = $_ } }) + [pscustomobject]@{ Severity = 'Critical'; N = 0 }
        @(Sort-RksIaRow -Rows $rows).N | Should -Be (@(0) + (1..30))
    }
}

Describe 'ConvertTo-RksIaCell' {
    It 'Escapes backslashes before pipes' { ConvertTo-RksIaCell -Value 'x\|y' | Should -BeExactly 'x\\\|y' }
    It 'Joins lists' { ConvertTo-RksIaCell -Value @('a', 'b') | Should -BeExactly 'a, b' }
    It 'Shortens dates' { ConvertTo-RksIaCell -Value ([datetime]'2026-01-02 03:04:05') | Should -BeExactly '2026-01-02 03:04' }
    It 'Turns null into an empty string' { ConvertTo-RksIaCell -Value $null | Should -BeExactly '' }
    It 'Removes line breaks' { ConvertTo-RksIaCell -Value "a`r`nb`nc`rd" | Should -BeExactly 'a b c d' }
}
