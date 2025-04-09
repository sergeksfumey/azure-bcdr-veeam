<#
.SYNOPSIS
    Deploys a 3-tier Azure infrastructure with VMs, VMSS, Azure SQL, File Share, and prepares for Veeam Backup integration.

.DESCRIPTION
    Creates 3 VNETs, deploys a jumpbox VM, VM Scale Set, Azure SQL Database, and a File Share. Targets France Central region.

.NOTES
    Author: <Your Name>
    GitHub: https://github.com/<your-github>/Azure-BCDR-Veeam
#>

# Set variables
$location = "francecentral"
$resourceGroup = "BCDR-RG"
$adminUsername = "azureuser"
$adminPassword = "P@ssw0rd1234!"  # NOTE: For production use, secure this with Azure Key Vault or prompt
$vnetPrefix = "10"
$timestamp = Get-Date -Format "yyyyMMddHHmm"

# Create Resource Group
az group create --name $resourceGroup --location $location

# Create VNETs and Subnets
Write-Host "Creating VNETs..."
for ($i=0; $i -lt 3; $i++) {
    $vnetName = "VNET-$i"
    $subnetName = "Subnet-$i"
    $addressPrefix = "$vnetPrefix.$i.0.0/16"
    $subnetPrefix = "$vnetPrefix.$i.0.0/24"

    az network vnet create `
        --resource-group $resourceGroup `
        --location $location `
        --name $vnetName `
        --address-prefix $addressPrefix `
        --subnet-name $subnetName `
        --subnet-prefix $subnetPrefix
}

# Deploy Jumpbox VM in VNET-0
Write-Host "Deploying Jumpbox VM..."
az vm create `
  --resource-group $resourceGroup `
  --name JumpboxVM `
  --image Win2022Datacenter `
  --vnet-name VNET-0 `
  --subnet Subnet-0 `
  --admin-username $adminUsername `
  --admin-password $adminPassword `
  --size Standard_B2s `
  --public-ip-sku Standard

# Deploy Web Tier VMSS in VNET-1
Write-Host "Deploying VM Scale Set for Web Tier..."
az vmss create `
  --resource-group $resourceGroup `
  --name WebVMSS `
  --image UbuntuLTS `
  --vnet-name VNET-1 `
  --subnet Subnet-1 `
  --instance-count 2 `
  --admin-username $adminUsername `
  --generate-ssh-keys

# Create Storage Account and File Share
$storageName = "bcdrstorage$timestamp"
Write-Host "Creating Storage Account: $storageName..."
az storage account create `
  --name $storageName `
  --resource-group $resourceGroup `
  --location $location `
  --sku Standard_LRS `
  --kind StorageV2

$key = az storage account keys list --account-name $storageName --resource-group $resourceGroup --query "[0].value" -o tsv

az storage share create `
  --name backupfileshare `
  --account-name $storageName `
  --account-key $key

# Create SQL Server and Database
$sqlServerName = "sqlserver$timestamp"
Write-Host "Deploying Azure SQL..."
az sql server create `
  --name $sqlServerName `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user "sqladmin" `
  --admin-password "SqlP@ssword1234"

az sql db create `
  --resource-group $resourceGroup `
  --server $sqlServerName `
  --name BCDRDb `
  --service-objective S0

# Output Completion
Write-Host "`n✅ Azure infrastructure deployed successfully!"
Write-Host "Next Steps:"
Write-Host "  - Deploy Veeam Backup for Azure from the Marketplace"
Write-Host "  - Configure backup policies for VMs, VMSS, SQL, and file share"
