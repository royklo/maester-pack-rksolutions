Every Windows device should back up the password of its local administrator account to Microsoft Entra ID with
Windows LAPS, and do it regularly. Without LAPS, local admin passwords tend to be the same on every device, so one
stolen password opens them all. A backup that is older than the rotation period means rotation has stalled.

The test lists devices without an Entra-backed LAPS policy, devices with a policy but no password in Entra ID, and
devices whose last backup is older than the `MaximumBackupAgeDays` parameter (60 days by default).

#### Remediation action

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), go to **Endpoint security** > **Account protection**.
2. Assign a **Local admin password solution (Windows LAPS)** policy with **Backup Directory** set to **Azure AD only**.
3. For a device with a policy but no backup, check in the device's **Device configuration** status why the policy
   fails, and sync the device.

#### Related links

- [Intune - Account protection](https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/accountprotection)
- [Microsoft Learn - Windows LAPS with Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/windows-laps-overview)

<!--- Results --->
%TestResult%
