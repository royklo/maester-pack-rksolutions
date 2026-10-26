Every Windows device should be encrypted with BitLocker, be covered by an Intune BitLocker policy, and have the
recovery key of its system drive stored in Microsoft Entra ID. A lost or stolen laptop without BitLocker gives away
its data. A device whose key is not in Entra ID cannot be unlocked by the helpdesk when BitLocker asks for the key.

The test lists each device with what is wrong: not encrypted, no BitLocker policy assigned, or encrypted without a
key in Entra ID. Cloud PCs are left out: Windows 365 encrypts their disks itself.

#### Remediation action

1. In the [Microsoft Intune admin center](https://intune.microsoft.com), go to **Endpoint security** > **Disk encryption**.
2. Make sure a BitLocker policy is assigned to these devices, with **Require Device Encryption** on and recovery
   information stored in Entra ID.
3. For an encrypted device without a key in Entra ID, run `BackupToAAD-BitLockerKeyProtector` on the device, or
   make the policy back up the key and let the device sync.

#### Related links

- [Intune - Disk encryption](https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/diskEncryption)
- [Microsoft Learn - Encrypt Windows devices with BitLocker in Intune](https://learn.microsoft.com/intune/intune-service/protect/encrypt-devices)

<!--- Results --->
%TestResult%
