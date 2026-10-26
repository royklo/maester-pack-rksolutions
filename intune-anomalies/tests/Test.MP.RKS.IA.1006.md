Devices registered in Windows Autopilot (with a hardware hash or a corporate identifier for Autopilot device
preparation) are recognised as company devices when they are reset, and enrol again on their own. A device that is
not registered can be reset and set up as a personal device. The test lists physical Windows devices with neither a
hardware hash nor a corporate identifier. Cloud PCs are left out.

#### Remediation action

1. Upload the hardware hash of each device below (Get-WindowsAutopilotInfo), or add its corporate identifier.
2. In the [Microsoft Intune admin center](https://intune.microsoft.com), go to **Devices** > **Enrollment** >
   **Windows Autopilot** > **Devices** and import them.

#### Related links

- [Microsoft Learn - Add devices to Windows Autopilot](https://learn.microsoft.com/autopilot/add-devices)
- [Microsoft Learn - Corporate identifiers for Autopilot device preparation](https://learn.microsoft.com/autopilot/device-preparation/tutorial/user-driven/entra-join-corporate-identifier)

<!--- Results --->
%TestResult%
