---
name: Bug report
about: A check gives a wrong result, an error, or a skip you did not expect
title: '[Bug] '
labels: bug
assignees: ''
---

<!-- Remove device names, user names, e-mail addresses and tenant IDs from anything you paste below. -->

## Pack and check

- **Pack:** (e.g. RKSolutions Intune Anomalies)
- **Pack version:** (output of `Get-MtPack | Format-Table Id, Version`)
- **Check:** (e.g. MP.RKS.IA.1003)

## Description

A clear description of the problem.

## Steps to reproduce

1. Connect with '...'
2. Run '...' (e.g. `Invoke-Maester -Pack RKS.IA`)
3. See the result

## Expected behavior

What you expected the check to report.

## Actual behavior

What it reported instead: the result (Passed, Failed, Skipped, Error), the reason or error message, and the rows that
are wrong.

## Environment

- **Maester version:** (output of `(Get-Module Maester).Version`)
- **PowerShell version:** (output of `$PSVersionTable.PSVersion`)
- **OS:** (e.g. Windows 11, macOS 15, Ubuntu 24.04)
- **Connection:**
  - [ ] Delegated (signed in as a user). Role of the account: (e.g. Global Reader)
  - [ ] App-only (app registration or managed identity)

## Additional context

Anything else that might help, such as the result from the HTML report (with tenant data removed).
