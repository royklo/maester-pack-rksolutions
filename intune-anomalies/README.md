# RKSolutions Intune Anomalies

A [Maester Pack](https://maester.dev/docs/packs) with eight checks of the Windows devices that Intune manages. The
checks come from the Intune Anomalies report of the [RKSolutions PowerShell module](https://github.com/royklo/RKSolutions-Module).

## Install and run

    Install-MtPack royklo/maester-pack-rksolutions/intune-anomalies

A specific version is installed by its release tag:

    Install-MtPack royklo/maester-pack-rksolutions/intune-anomalies -Version intune-anomalies-v0.1.0

Then connect and run:

    Connect-MgGraph -Scopes ((Get-MtGraphScope) + 'BitlockerKey.ReadBasic.All', 'DeviceLocalCredential.ReadBasic.All') -NoWelcome
    Invoke-Maester -Pack RKS.IA

An account with the Global Reader role is enough (Intune Administrator also works). The first test of a run collects
the data for all eight, which can take minutes on a large tenant; keep that in mind if `Execution.TestTimeoutSeconds`
is set in your Maester configuration.

If Graph answers access denied for BitLocker keys or LAPS passwords, those two checks are skipped. Check both that the
connection has the two extra scopes and that the account has a role that may read them (Global Reader does).

## Settings

Three tests take parameters. Set them in `maester-config.json` under `TestSettings`, by test ID:

```json
{
  "TestSettings": [
    { "Id": "MP.RKS.IA.1002", "Parameters": { "MaximumBackupAgeDays": 30, "IncludeExcludedDevices": true } },
    { "Id": "MP.RKS.IA.1004", "Parameters": { "InactiveDays": 45 } }
  ]
}
```

| Test | Parameter | Default |
| --- | --- | --- |
| MP.RKS.IA.1001, MP.RKS.IA.1002 | `IncludeExcludedDevices` | `false` |
| MP.RKS.IA.1002 | `MaximumBackupAgeDays` | `60` |
| MP.RKS.IA.1004 | `InactiveDays` | `90` |

## Tests

| ID | Title |
| --- | --- |
| MP.RKS.IA.1001 | Windows devices are BitLocker-encrypted and their recovery key is in Entra ID |
| MP.RKS.IA.1002 | Windows devices back up their local administrator password to Entra ID |
| MP.RKS.IA.1003 | Windows devices are compliant |
| MP.RKS.IA.1004 | Windows devices have checked in with Intune recently |
| MP.RKS.IA.1005 | The primary user of every Windows device is enabled |
| MP.RKS.IA.1006 | Windows devices are registered in Windows Autopilot |
| MP.RKS.IA.1007 | Single-user Autopilot devices are used by one person |
| MP.RKS.IA.1008 | Settings Catalog policies use no deprecated settings |

A failing test lists up to 200 devices or settings. For the full list, run the HTML report
`Get-IntuneAnomaliesReport` from the RKSolutions module (`Install-Module RKSolutions`).

## Where the code comes from

`helpers/core` is copied from `module/Core` of RKSolutions-Module by a pull request. Change the logic there, not here.
