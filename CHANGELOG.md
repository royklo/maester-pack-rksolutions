# Changelog

## intune-anomalies 0.1.3

- Core synced from RKSolutions-Module@ec3c365.

## intune-anomalies 0.1.2

- A broader description and page summary, ready for checks beyond Windows devices.

## intune-anomalies 0.1.1

- A banner for the pack index.

## intune-anomalies 0.1.0

First version. Eight read-only checks of Windows devices managed by Intune:

- **MP.RKS.IA.1001** Windows devices are BitLocker-encrypted and their recovery key is in Entra ID
- **MP.RKS.IA.1002** Windows devices back up their local administrator password to Entra ID
- **MP.RKS.IA.1003** Windows devices are compliant
- **MP.RKS.IA.1004** Windows devices have checked in with Intune recently
- **MP.RKS.IA.1005** The primary user of every Windows device is enabled
- **MP.RKS.IA.1006** Windows devices are registered in Windows Autopilot
- **MP.RKS.IA.1007** Single-user Autopilot devices are used by one person
- **MP.RKS.IA.1008** Settings Catalog policies use no deprecated settings
