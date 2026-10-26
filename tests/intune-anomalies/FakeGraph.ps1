# Canned Microsoft Graph below Maester: the real engine, Invoke-MtGraphRequest and its cache run on these global
# functions. $global:SimScenario is Happy, Forbidden (403 on three reads) or Broken (400 on managedDevices).
$global:SimCalls = [System.Collections.Generic.List[string]]::new()
$now = (Get-Date).ToUniversalTime()
function J($o) { if ($o -is [hashtable] -and $o.ContainsKey('value')) { $o['@odata.context'] = 'https://graph.microsoft.com/sim/$metadata#x' }; $o | ConvertTo-Json -Depth 20 -Compress }
$global:SimData = @{
    'v1.0/organization'                                   = J @{ value = @(@{ id = 't1'; displayName = 'Contoso' }) }
    'v1.0/subscribedSkus'                                 = J @{ value = @(@{ skuId = 's1'; capabilityStatus = 'Enabled'; servicePlans = @(@{ servicePlanName = 'INTUNE_A'; servicePlanId = 'c1ec4a95-1f05-45b3-a911-aa3fa01094f5' }, @{ servicePlanName = 'AAD_PREMIUM'; servicePlanId = '41781fb2-bc02-4b7c-bd55-b576c07bb09d' }) }) }
    'beta/users'                                          = J @{ value = @(@{ id = 'u1'; userPrincipalName = 'alice@contoso.com'; userType = 'Member'; accountEnabled = $true }, @{ id = 'u2'; userPrincipalName = 'bob@contoso.com'; userType = 'Member'; accountEnabled = $false }, @{ id = 'u3'; userPrincipalName = 'carol@contoso.com'; userType = 'Member'; accountEnabled = $true }) }
    'beta/deviceManagement/managedDevices'                = J @{ value = @(
            @{ id = 'd1'; deviceName = 'DESKTOP-1'; azureADDeviceId = 'aad1'; userPrincipalName = 'alice@contoso.com'; serialNumber = 'S1'; manufacturer = 'Dell'; model = 'XPS'; isEncrypted = $true; complianceState = 'compliant'; lastSyncDateTime = $now.AddDays(-1).ToString('o'); enrollmentProfileName = 'UserDriven'; usersLoggedOn = @(@{ userId = 'u1' }, @{ userId = 'u3' }); managementAgent = 'mdm'; operatingSystem = 'Windows'; osVersion = '10.0.26100.1'; managedDeviceOwnerType = 'company'; hardwareInformation = @{ tpmVersion = '2.0' }; skuFamily = 'Enterprise'; totalStorageSpaceInBytes = 1000; freeStorageSpaceInBytes = 500; enrolledDateTime = $now.AddDays(-100).ToString('o') },
            @{ id = 'd2'; deviceName = 'LAPTOP|2'; azureADDeviceId = 'aad2'; userPrincipalName = 'bob@contoso.com'; serialNumber = 'S2'; manufacturer = 'HP'; model = 'EliteBook'; isEncrypted = $false; complianceState = 'noncompliant'; lastSyncDateTime = $now.AddDays(-200).ToString('o'); enrollmentProfileName = $null; usersLoggedOn = @(); managementAgent = 'mdm'; operatingSystem = 'Windows'; osVersion = '10.0.22631.1'; managedDeviceOwnerType = 'company'; hardwareInformation = @{ tpmVersion = '2.0' }; skuFamily = 'Pro'; totalStorageSpaceInBytes = 1000; freeStorageSpaceInBytes = 500; enrolledDateTime = $now.AddDays(-300).ToString('o') }
        ) }
    'beta/deviceManagement/managedDevices/d2'             = J @{ id = 'd2'; deviceType = 'windowsRT' }
    'beta/deviceManagement/windowsAutopilotDeviceIdentities' = J @{ value = @(@{ serialNumber = 'S1' }) }
    'beta/deviceManagement/importedDeviceIdentities'      = J @{ value = @() }
    'beta/deviceManagement/settings'                      = J @{ deviceComplianceCheckinThresholdDays = 30 }
    'beta/deviceManagement/managedDevices/d2/deviceCompliancePolicyStates' = J @{ value = @(@{ id = 'ps1'; state = 'nonCompliant' }) }
    'beta/deviceManagement/managedDevices/d2/deviceCompliancePolicyStates/ps1/settingStates' = J @{ value = @(@{ settingName = 'Windows10CompliancePolicy.BitLockerEnabled'; state = 'nonCompliant' }) }
    'beta/deviceManagement/windowsAutopilotDeploymentProfiles' = J @{ value = @(@{ displayName = 'UserDriven'; outOfBoxExperienceSettings = @{ deviceUsageType = 'singleUser' } }) }
    'beta/deviceManagement/assignmentFilters'             = J @{ value = @() }
    'beta/deviceManagement/configurationPolicies'         = J @{ value = @(@{ id = 'cp1'; name = 'BitLocker'; platforms = 'windows10' }, @{ id = 'cp2'; name = 'LAPS'; platforms = 'windows10' }) }
    'beta/deviceManagement/configurationPolicies/cp1/settings' = J @{ value = @(
            @{ settingInstance = @{ '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'; settingDefinitionId = 'device_vendor_msft_bitlocker_requiredeviceencryption'; choiceSettingValue = @{ value = 'device_vendor_msft_bitlocker_requiredeviceencryption_1' } }; settingDefinitions = @(@{ id = 'device_vendor_msft_bitlocker_requiredeviceencryption'; displayName = 'Require Device Encryption' }) },
            @{ settingInstance = @{ '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'; settingDefinitionId = 'device_vendor_msft_policy_config_old'; choiceSettingValue = @{ value = 'device_vendor_msft_policy_config_old_1' } }; settingDefinitions = @(@{ id = 'device_vendor_msft_policy_config_old'; displayName = 'Old thing (Deprecated)' }) }
        ) }
    'beta/deviceManagement/configurationPolicies/cp2/settings' = J @{ value = @(@{ settingInstance = @{ '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'; settingDefinitionId = 'device_vendor_msft_laps_policies_backupdirectory'; choiceSettingValue = @{ value = 'device_vendor_msft_laps_policies_backupdirectory_1' } }; settingDefinitions = @(@{ id = 'device_vendor_msft_laps_policies_backupdirectory'; displayName = 'Backup Directory' }) }) }
    'beta/deviceManagement/configurationPolicies/cp1/assignments' = J @{ value = @(@{ id = 'a1'; target = @{ '@odata.type' = '#microsoft.graph.allDevicesAssignmentTarget' } }) }
    'beta/deviceManagement/configurationPolicies/cp2/assignments' = J @{ value = @(@{ id = 'a2'; target = @{ '@odata.type' = '#microsoft.graph.allDevicesAssignmentTarget' } }) }
    'beta/deviceManagement/deviceConfigurations'          = J @{ value = @() }
    'beta/deviceManagement/intents'                       = J @{ value = @() }
    'v1.0/informationProtection/bitlocker/recoveryKeys'   = J @{ value = @(@{ id = 'k1'; deviceId = 'aad1'; volumeType = 1 }) }
    'v1.0/directory/deviceLocalCredentials'               = J @{ value = @(@{ id = 'aad1'; deviceName = 'DESKTOP-1'; lastBackupDateTime = $now.AddDays(-5).ToString('o') }) }
    'v1.0/devices'                                        = J @{ value = @(@{ deviceId = 'aad1'; displayName = 'DESKTOP-1' }, @{ deviceId = 'aad2'; displayName = 'LAPTOP|2' }) }
}

function global:Get-MgContext { [pscustomobject]@{ TenantId = 't1'; Environment = 'Global'; AuthType = 'Delegated'; Account = 'admin@contoso.com'; Scopes = @('DeviceManagementManagedDevices.Read.All') } }
function global:Get-MgEnvironment { param($Name) [pscustomobject]@{ Name = 'Global'; GraphEndpoint = 'https://graph.microsoft.com' } }
function global:Invoke-MgGraphRequest {
    param($Method, $Uri, $Headers, $OutputType, $Body)
    $u = [uri]$Uri
    $key = ($u.AbsolutePath.TrimStart('/'))
    $global:SimCalls.Add("$Method $($u.AbsoluteUri)")
    $fail = {
        param([int] $code)
        $response = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]$code)
        throw [Microsoft.Graph.PowerShell.Authentication.Helpers.HttpResponseException]::new("Simulated $code", $response)
    }
    switch ($global:SimScenario) {
        'Forbidden' { if ($key -in 'v1.0/informationProtection/bitlocker/recoveryKeys', 'v1.0/directory/deviceLocalCredentials') { & $fail 403 } }
        'Broken' { if ($key -eq 'beta/deviceManagement/managedDevices') { & $fail 400 } }
        'Empty' { if ($key -eq 'beta/deviceManagement/managedDevices' -or $key -eq 'beta/deviceManagement/configurationPolicies') { return (J @{ value = @() } | ConvertFrom-Json) } }
    }
    if ($global:SimData.ContainsKey($key)) { return ($global:SimData[$key] | ConvertFrom-Json) }
    if ($key -like '*/transitiveMembers/*') { return (J @{ value = @() } | ConvertFrom-Json) }
    $global:SimCalls.Add("UNKNOWN $key")
    & $fail 404
}
