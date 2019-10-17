# Microsoft Azure Backup Enforcement Policy

## Prerequisites

The account used to run this script must have either of these roles assigned:

* Resource Policy Contributor
* Owner

Backup Enforcement is controlled on a per-region basis, as Recovery Services Vaults can only apply to a single region.
You will need to create both vaults and policies for every region in which you want to automatically back up VMs.

## Instructions

* Clone this repository and ensure that all files remain in the same folder
* Edit BackupEnforcementPolicy.json if necessary (if you need to change the supported VM operating system types)
* Run the New-BackupPolicy function and supply the following parameters:

    - Name : The name to be used for both the policy definition and the policy assignment
    - subscriptionId : The Azure subscription to be used for the policy scope
    - location : The Azure region in which both the VMs and the Recovery Services Vault are located
    - backupVaultRGName : The name of the Resource Group containing the Recovery Services Vault
    - backupVaultName : The name of the Recovery Services Vault
    - backupPolicyName : The backup policy to apply for each VM

* Policy application can take some time, so you may see the compliance state listed as "Not Started" directly after running this script
