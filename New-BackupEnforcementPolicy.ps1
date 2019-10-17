Function BackupPolicy {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$true)][string]$namePrefix,
      [parameter(Mandatory=$true)][string]$policyFilePath
  )

  $policyDefName = $namePrefix + "-Def"
  $PolicyAsName = $namePrefix + "-As"
  $Subscription = Get-AzSubscription
  $policyFilePath.TrimEnd('\')
  $policyDefPath = $policyFilePath + "\BackupEnforcementPolicy.json"
  $policyParamPath = $policyFilePath + "\BackupEnforcementPolicy.param.json"

  $PolicyDef = New-AzPolicyDefinition -Name $policyDefName -Policy $policyDefPath
  if ($? -eq "false") {
      Write-Host "Failed to create the policy definition $policyDefName - $error[0]"
  }

  #$PolicyDef = Get-AzPolicyDefinition -Name $policyDefName
  New-AzPolicyAssignment -Name $PolicyAsName -PolicyDefinition $PolicyDef -Scope "/subscriptions/$($Subscription.Id)" -PolicyParameter $policyParamPath -AssignIdentity
  if ($? -eq "false") {
      Write-Host "Failed to create the policy assignment $policyAsName - $error[0]"
  }

}