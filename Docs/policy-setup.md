# 🛡 Veeam Backup for Azure – Backup Policy Configuration Guide

This guide walks through configuring **backup policies** in **Veeam Backup for Azure** to protect Azure Virtual Machines, VM Scale Sets, SQL databases, and Azure File Shares.

---

## 📍 Prerequisites

- Azure infrastructure deployed (via `deploy-infra.ps1`)
- Veeam Backup for Azure deployed from the [Azure Marketplace](https://portal.azure.com/#create/veeam.veeambackupazure)
- Web portal access to Veeam Backup appliance

---

## 🔐 Step 1: Login to Veeam Web Portal

1. Access the public IP of the deployed Veeam VM (port `443`).
2. Default login:  
   - **Username:** `admin`  
   - **Password:** Set during Azure deployment
3. Accept the EULA and complete initial setup wizard.

---

## 🔗 Step 2: Add Azure Account & Region

1. Navigate to **"Accounts"** > **"Add Account"**
2. Select **Azure Service Principal** (recommended)
3. Provide:
   - Tenant ID
   - Application ID
   - Secret
4. Grant necessary permissions (Contributor or Backup Operator role)
5. Add **"France Central"** as the target region.

---

## 📦 Step 3: Create Backup Repository

1. Go to **"Backup Repositories"** > **"Add Repository"**
2. Choose **Azure Blob Storage**
3. Select or create a storage account and container:
   - Use the storage account created in `deploy-infra.ps1` (e.g. `bcdrstorageXXXX`)
   - Container name: `veeam-backups`
4. Optionally enable:
   - Object Lock (for immutability)
   - Archive tier for cost optimization

---

## 🛠 Step 4: Define Backup Policy for VMs

1. Navigate to **"Policies"** > **"Add Policy"**
2. Name: `Backup-Policy-VMs`
3. Choose backup scope:
   - Resource Group: `BCDR-RG`
   - Filter: `JumpboxVM`
4. Set Schedule:
   - Daily at 02:00 AM
   - Retain backups for 14 days
5. Select repository (from Step 3)
6. Enable Application-Aware processing (Windows/Linux as needed)
7. Finish and **Run Job Now** for initial backup

---

## 🖥 Step 5: Policy for VM Scale Sets (Web Tier)

1. Create new policy: `Backup-Policy-VMSS`
2. Select Resource Type: **Virtual Machine Scale Sets**
3. Target: `WebVMSS`
4. Use custom tags for auto-discovery (optional):  
   e.g., `backup=true`
5. Schedule & retention similar to Step 4

---

## 💾 Step 6: Azure SQL Backup Strategy

**Note:** Veeam does not directly back up PaaS SQL DBs; use **SQL Export** + **Blob Backup** approach.

1. Use **Azure Automation Runbook** to export SQL DB daily to blob storage
2. Create a Veeam policy to back up the blob container with exported `.bacpac` files
3. Schedule SQL export before backup (e.g., export at 01:30 AM, Veeam backup at 02:00 AM)

---

## 🗂 Step 7: Azure File Share Backup

1. File Shares need to be backed up by mounting them in a Windows VM
2. Create a Windows utility VM or use the Jumpbox
3. Install **Veeam Agent for Windows** inside that VM
4. Mount File Share (`\\<storageaccount>.file.core.windows.net\backupfileshare`)
5. Create Veeam File-Level backup job via agent
6. Store backup in repository (same or separate container)

---

## 🛡 Optional: Enable Immutability

- In your backup repository (Blob with Object Lock), configure:
  - Retention Lock
  - Prevent deletion for X days
- This enhances ransomware protection and regulatory compliance

---

## 📊 Monitoring & Reporting

- Veeam Web UI Dashboard:
  - Job status
  - Failures and successes
  - Retention overview
- Enable Email Notifications:
  - SMTP setup in **Settings** > **Notifications**

---

## 💡 Tips for Optimization

| Tip | Description |
|-----|-------------|
| Use Tags | Tag Azure resources with `backup=true` to auto-include |
| Incremental | Use incremental backups to reduce cost |
| Archive Tier | Store long-term backups in Azure Archive Blob |
| Integration | Connect to Azure Monitor Logs for alerting |

---

## ✅ Final Outcome

You now have:
- Daily automated backup of all critical resources
- Secure, policy-driven retention for DR
- Veeam console for visibility and control
- Optional monitoring/dashboard for insights

---

## 📷 Screenshots (Include in GitHub)

- Veeam Dashboard with policies
- Backup Job Logs
- Email Alerts
- Retention Settings
