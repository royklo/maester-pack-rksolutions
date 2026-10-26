## Summary of changes

Brief description of what this PR does.

## Related issue

Fixes #(issue number) — or "None".

## Pack

Which pack this changes (folder name) and its new version.

## Checklist

- The pack's `Version` in `maester-pack.json` is raised, and `CHANGELOG.md` has a `## <folder> <version>` section for it
- `Test-MtPack ./<folder>` rates the pack valid and Low, with no findings (for Intune Anomalies:
  `./tools/Test-Pack.ps1 -Scan -Run`)
- The Pester tests pass (`Invoke-Pester ./tests`)
- A new check has a `Test.<ID>.ps1` with a `[MaesterTest]` attribute and a `Test.<ID>.md` that ends with
  `<!--- Results --->` and `%TestResult%`
- New Microsoft Graph permissions are in `Uses.GraphScopes` of `maester-pack.json` and in the pack's README
- I did not edit `intune-anomalies/helpers/core` by hand (that code comes from `module/Core` in
  [RKSolutions-Module](https://github.com/royklo/RKSolutions-Module))
- No tenant data (device names, user names, tenant IDs) in code, tests or screenshots
