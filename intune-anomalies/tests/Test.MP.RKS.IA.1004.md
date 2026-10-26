A device that has not synced with Intune for a long time no longer gets policies, updates or app installs, and its
compliance state is out of date. Often it is lost, replaced or not used any more, and it still counts as a managed
device. The test lists Windows devices whose last sync is older than the `InactiveDays` parameter (90 days by default).

#### Remediation action

1. Find out whether each device below is still in use.
2. Retire or delete the devices that are not, in the [Microsoft Intune admin center](https://intune.microsoft.com)
   under **Devices** > **Windows**.
3. Set up a device clean-up rule so this happens on its own.

#### Related links

- [Intune - Device clean-up rules](https://intune.microsoft.com/?ref=AdminCenter#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/deviceCleanUp)
- [Microsoft Learn - Device clean-up rules](https://learn.microsoft.com/intune/intune-service/fundamentals/device-cleanup-rules)

<!--- Results --->
%TestResult%
