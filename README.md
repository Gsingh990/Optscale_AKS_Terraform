# OptScale Deployment on Azure Kubernetes Service (AKS)

This project provides a Terraform solution for deploying a complete Azure Kubernetes Service (AKS) cluster and then deploying the core components of the OptScale platform onto that newly created AKS cluster. OptScale is an open-source FinOps and MLOps platform for cloud cost management and optimization.

## Architecture Overview

This solution deploys the following Azure resources:

*   **Resource Group:** A dedicated resource group for all OptScale and AKS components.
*   **Azure Kubernetes Service (AKS) Cluster:** A highly available, secure, and scalable AKS cluster, including its Virtual Network, subnets, NSGs, system node pool, and user node pools with auto-scaling.
*   **Azure Database for PostgreSQL Flexible Server:** The primary database for OptScale.
*   **Azure Cache for Redis:** Used by OptScale for caching and session management.
*   **Azure Storage Account (Blob Storage):** For OptScale's object storage needs.
*   **Kubernetes Deployments (on AKS):**
    *   OptScale Backend (API, Workers)
    *   OptScale Frontend (UI)
    *   RabbitMQ (as a message queue)
    *   Kubernetes Services, ConfigMaps, and Secrets to configure and expose these components.

## Prerequisites

Before deploying this solution, ensure you have the following:

*   **Azure Subscription:** An active Azure subscription.
*   **Azure CLI:** Installed and configured (`az login`).
*   **Terraform:** Installed ([https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)).
*   **Permissions:** Sufficient permissions in your Azure subscription to create resource groups, AKS clusters, PostgreSQL Flexible Servers, Redis Caches, Storage Accounts, and to deploy applications to Kubernetes.

## Deployment Steps

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd optscale_aks_deployment
    ```

2.  **Review and Customize Variables:**
    Open the `variables.tf` and `terraform.tfvars` files in the root directory. Customize the values as needed for your deployment.

    **Important:**
    *   Provide strong, secure passwords for `db_admin_password` in `terraform.tfvars`.
    *   If you enable Azure AD RBAC for AKS, provide `admin_group_object_ids` in `terraform.tfvars`.

3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

4.  **Review the Plan:**
    ```bash
    terraform plan
    ```

5.  **Apply the Changes:**
    ```bash
    terraform apply
    ```

6.  **Verify Deployment:**
    After the deployment completes, verify the created Azure resources in the Azure portal and the Kubernetes deployments within your AKS cluster.

## Configuration

The `variables.tf` and `terraform.tfvars` files are the primary places to customize your deployment. Key variables include:

*   `resource_group_name`: The name of the Azure Resource Group for OptScale.
*   `location`: The Azure region for resource deployment.
*   `tags`: Global tags to apply to all resources.
*   **AKS Cluster Configuration:**
    *   `vnet_name`, `vnet_address_space`, `aks_subnet_name`, `aks_subnet_address_prefixes`: Networking configuration for AKS.
    *   `aks_cluster_name`, `kubernetes_version`, `dns_prefix`: AKS cluster basic configuration.
    *   `system_node_pool_vm_size`, `system_node_pool_node_count`: System node pool configuration.
    *   `user_node_pools`: A map defining multiple user node pools with auto-scaling settings.
    *   `private_cluster_enabled`: Enable/disable private cluster.
    *   `azure_policy_enabled`: Enable/disable Azure Policy Add-on.
    *   `admin_group_object_ids`: Azure AD Group Object IDs for AKS admin access.
*   **OptScale Specific Variables:**
    *   `db_server_name`, `db_admin_login`, `db_admin_password`: PostgreSQL database configuration.
    *   `redis_cache_name`, `redis_cache_sku`: Azure Cache for Redis configuration.
    *   `storage_account_name`: Azure Storage Account configuration.
    *   `optscale_version`: The version of OptScale to deploy.

## Module Breakdown

*   **`modules/aks_networking/`**: Deploys the Virtual Network, Subnets, and Network Security Groups for the AKS environment.
*   **`modules/aks_cluster/`**: Deploys the AKS cluster itself, including system and user node pools with scale sets, and integrates with networking.
*   **`modules/optscale_db/`**: Deploys an Azure Database for PostgreSQL Flexible Server.
*   **`modules/optscale_cache/`**: Deploys an Azure Cache for Redis.
*   **`modules/optscale_storage/`**: Deploys an Azure Storage Account (Blob Storage).
*   **`modules/optscale_kubernetes_app/`**: Deploys OptScale components (backend, frontend, RabbitMQ) as Kubernetes Deployments, Services, ConfigMaps, and Secrets onto the AKS cluster.

## Important Notes

*   **Kubernetes Version:** Ensure the `kubernetes_version` specified is a currently supported GA version in your chosen Azure region.
*   **AKS Private Cluster:** If `private_cluster_enabled` is true, ensure your DNS resolution is correctly configured for the private endpoint of the AKS API server.
*   **OptScale Configuration:** The `optscale_kubernetes_app` module will create Kubernetes resources with basic configurations. You may need to further customize OptScale's configuration (e.g., environment variables, scaling, ingress) based on your specific needs and the OptScale documentation.
*   **OptScale Data Initialization:** Initializing OptScale's database and running migrations might be a separate step after deployment, as per OptScale's official documentation.