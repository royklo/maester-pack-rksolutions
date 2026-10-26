# RKSolutions Maester Packs

[Maester Packs](https://maester.dev/docs/packs) by Roy Klooster ([rksolutions.nl](https://rksolutions.nl)): extra
Maester checks for Microsoft 365, ready to install next to the tests that ship with Maester. Each pack lives in its own
folder and is installed, versioned and released on its own. Every pack needs Maester 3.0 or later.

## Packs

| Pack | Code | What it checks |
| --- | --- | --- |
| [RKSolutions Intune Anomalies](intune-anomalies/README.md) | `RKS.IA` | Windows devices managed by Intune: BitLocker keys, LAPS backups, compliance, inactive devices, primary users, Autopilot, shared single-user devices and deprecated settings |

## Install and run a pack

Install a pack by its folder, then run it by its code:

    Install-MtPack royklo/maester-pack-rksolutions/<folder>
    Invoke-Maester -Pack <code>

For example, `Install-MtPack royklo/maester-pack-rksolutions/intune-anomalies` and `Invoke-Maester -Pack RKS.IA`.
Each pack's README says which Microsoft Graph permissions to connect with. `Update-MtPack` installs a newer release,
and `Uninstall-MtPack` removes a pack.

## Versions and releases

Every pack has its own version, in the `Version` of its `maester-pack.json`. A release is tagged
`<folder>-v<version>`, such as `intune-anomalies-v0.1.0`, and installs with
`Install-MtPack royklo/maester-pack-rksolutions/<folder> -Version <folder>-v<version>`. The changes of each pack are in
[CHANGELOG.md](CHANGELOG.md), under a `## <folder> <version>` heading per release.

## Repository layout

| Path | Contents |
| --- | --- |
| `<folder>/` | One pack: `maester-pack.json`, `maester-pack.guide.json`, `README.md`, `helpers/` and `tests/` |
| `tests/<folder>/` | Pester tests of that pack's helpers (outside the pack folder, so they are not installed with it) |
| `tools/` | Scripts for the Intune Anomalies pack: `Sync-Core.ps1` and the local checks in `Test-Pack.ps1` |
| `.github/workflows/check-pack.yml` | Checks every pack folder on each push and pull request, and releases new pack versions |

The checks of the Intune Anomalies pack come from the [RKSolutions PowerShell module](https://github.com/royklo/RKSolutions-Module)
(`module/Core`). A workflow in that repository copies them here as a pull request; do not edit
`intune-anomalies/helpers/core` by hand.

## Issues

Report a problem or an idea in [Issues](https://github.com/royklo/maester-pack-rksolutions/issues). Say which pack and
which version it is about.

## License

[MIT](LICENSE)
