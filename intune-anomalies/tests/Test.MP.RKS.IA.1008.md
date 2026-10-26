Microsoft marks Settings Catalog settings as deprecated when a newer setting replaces them or Windows no longer
reads them. A policy that still sets one may stop working without any error. The test lists each deprecated setting
in your Settings Catalog policies, for every platform.

#### Remediation action

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), go to **Devices** > **Configuration** and
   open each policy below.
2. Remove the deprecated setting, and configure its replacement if there is one (the setting's information text
   names it).

#### Related links

- [Intune - Configuration](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration)
- [Microsoft Learn - Settings Catalog](https://learn.microsoft.com/intune/intune-service/configuration/settings-catalog)

<!--- Results --->
%TestResult%
