Function New-BackupPolicy {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$true)][string]$name,
      [parameter(Mandatory=$true)][string]$subscriptionId,
      [parameter(Mandatory=$true)][string]$location,
      [parameter(Mandatory=$true)][string]$backupVaultRGName,
      [parameter(Mandatory=$true)][string]$backupVaultName,
      [parameter(Mandatory=$true)][string]$backupPolicyName
  )

  $error.clear()

  $polDefFile = "BackupEnforcementPolicy.json"
  $polParamFile = "BackupEnforcementPolicy.param.json"
  $polSettings = '{ "BackupVaultLocation": { "value": "' + $location + '" }, "BackupVaultRGName": { "value": "' + $backupVaultRGName + '" }, "BackupVaultName": { "value": "' + $backupVaultName + '" }, "BackupPolicyName": { "value": "' + $backupPolicyName + '" } }'

  $PolDef = New-AzPolicyDefinition -Name $name -Policy $polDefFile -Parameter $polParamFile
  if (! $?) { Write-Host "Failed to create the policy definition $Name - $error[0]" }

  $PolAs = New-AzPolicyAssignment -Name $name -PolicyDefinition $PolDef -Scope "/subscriptions/$subscriptionId" -PolicyParameter $polSettings -Location $location -AssignIdentity
  if (! $?) { Write-Host "Failed to create the policy assignment $Name - $error[0]" }

  Start-AzPolicyRemediation -Name $name -PolicyAssignmentId $PolAs.PolicyAssignmentId
  if (! $?) { Write-Host "Failed to start the policy remediation $Name - $error[0]" }
}