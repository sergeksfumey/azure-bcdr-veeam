# ☁️ Azure Cloud Business Continuity with Veeam Backup Integration

![Azure](https://img.shields.io/badge/Azure-Cloud-blue.svg)
![Veeam](https://img.shields.io/badge/Veeam-Backup%20Integration-green)
![PowerShell](https://img.shields.io/badge/Built%20With-PowerShell-blue)

This project demonstrates a **cloud-native Business Continuity and Disaster Recovery (BCDR)** solution on **Microsoft Azure**, integrated with **Veeam Backup for Azure**. The environment simulates a production-grade multi-tier infrastructure deployed in **France Central** and uses automated PowerShell scripts for reproducibility.

> ✅ Perfect for showcasing hybrid cloud infrastructure, automation, and BCDR capabilities on your portfolio.

---

## 🧱 Project Overview

| Component       | Description                                          |
|----------------|------------------------------------------------------|
| Region          | France Central                                       |
| Network Design  | 3 VNETs (Hub, Web, DB) with subnet segmentation      |
| Compute         | Windows Jumpbox VM, Ubuntu VMSS Web Tier            |
| Storage         | Azure File Share via Storage Account                |
| Database        | Azure SQL Database                                   |
| Backup Engine   | Veeam Backup for Azure (Marketplace deployment)     |
| Automation      | PowerShell deployment script + REST API integration |

---

## 🚀 Features

- 🔁 **Automated Infrastructure Provisioning** via PowerShell + Azure CLI
- 🔒 **Multi-tier VNET Architecture** for secure resource isolation
- 🧠 **BCDR Policies with Veeam** for VM, VMSS, SQL, and File Shares
- 💡 **Portfolio-Ready Design** with monitoring and RPO/RTO best practices

---

## 🧰 Technologies Used

- **Azure CLI + PowerShell** (Infrastructure as Code)
- **Azure VNETs, VMSS, VMs, Storage, SQL**
- **Veeam Backup for Azure**
- **Azure Blob Backup Repositories**
- **Azure Monitor + Power BI (optional RPO/RTO dashboards)**

---

## 🛠 Deployment Guide

### 1️⃣ Prerequisites

- Azure Subscription
- PowerShell 7+
- Azure CLI installed
- Git installed
- [Veeam Backup for Azure](https://portal.azure.com/#create/veeam.veeambackupazure)

### 2️⃣ Clone the Repo

```bash
git clone https://github.com/<your-username>/azure-bcdr-veeam.git
cd azure-bcdr-veeam
```

### 3️⃣ Run Infrastructure Script

cd PowerShell
.\deploy-infra.ps1
