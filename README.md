# RKSolutions Maester packs

[Maester Packs](https://maester.dev/docs/packs) by Roy Klooster (rksolutions.nl).

| Pack | Install | What it checks |
| --- | --- | --- |
| [RKSolutions Intune Anomalies](intune-anomalies/README.md) | `Install-MtPack royklo/maester-pack-rksolutions/intune-anomalies` | Windows devices managed by Intune: BitLocker keys, LAPS backups, compliance, inactive devices, Autopilot and deprecated settings |

The logic of the Intune Anomalies pack comes from the [RKSolutions PowerShell module](https://github.com/royklo/RKSolutions-Module)
(`module/Core`). It is copied here by a pull request; do not edit `intune-anomalies/helpers/core` by hand.
