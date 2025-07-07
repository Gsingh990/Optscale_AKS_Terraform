# OptScale Deployment on Azure Kubernetes Service (AKS)

This project provides a Terraform solution for deploying a complete Azure Kubernetes Service (AKS) cluster and then deploying the core components of the OptScale platform onto that newly created AKS cluster. OptScale is an open-source FinOps and MLOps platform for cloud cost management and optimization.

## Architecture Overview

This solution deploys the following Azure resources:

*   **Resource Group:** A dedicated resource group for all OptScale and AKS components.
*   **Azure Kubernetes Service (AKS) Cluster:** A highly available, secure, and scalable AKS cluster, including its Virtual Network, subnets, NSGs, system node pool, and user node pools with auto-scaling.
*   **PostgreSQL on a Virtual Machine:** Due to potential Azure subscription policy restrictions on Azure Database for PostgreSQL Flexible Server, this solution deploys a dedicated Linux Virtual Machine and installs PostgreSQL on it. This VM is placed within the same virtual network as the AKS cluster and is not exposed to the public internet.
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
*   **Terraform:** Installed (https://www.terraform.io/downloads.html).
*   **Permissions:** Sufficient permissions in your Azure subscription to create resource groups, AKS clusters, Virtual Machines, Redis Caches, Storage Accounts, and to deploy applications to Kubernetes.
*   **Azure Subscription Policy Considerations:** Be aware that some Azure subscriptions may have policies restricting the creation of certain services (e.g., Azure Database for PostgreSQL Flexible Server) in specific regions or altogether. If you encounter "LocationIsOfferRestricted" errors, you may need to request a quota increase from Azure support or use alternative deployment methods (like the VM-based PostgreSQL solution implemented here).
*   **Network Connectivity for Private AKS:** If `private_cluster_enabled` is true (which is the default and recommended for security), the machine running Terraform must have network connectivity to the private AKS API server. This can be achieved by:
    *   Running Terraform from a **jumpbox VM** located within the same Azure Virtual Network as your AKS cluster.
    *   Establishing a **VPN connection** from your local machine to the Azure Virtual Network.
    *   Using **Azure Bastion** to connect to a jumpbox VM and execute Terraform commands from there.

## Deployment Steps

The deployment is broken down into two main phases to handle the private AKS cluster setup and Kubernetes application deployment.

### Phase 1: Deploy Core Infrastructure (AKS, Networking, DB VM, Cache, Storage)

In this phase, we deploy the foundational Azure resources. The Kubernetes application deployment module (`optscale_kubernetes_app`) is initially commented out to allow the AKS cluster to be fully provisioned and accessible before attempting to deploy applications to it.

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
    *   The `optscale_kubernetes_app` module is initially commented out in `main.tf`. Do NOT uncomment it yet.

3.  **Initialize Terraform:**
    ```bash
    terraform init -upgrade
    ```

4.  **Review the Plan:**
    ```bash
    terraform plan
    ```

5.  **Apply the Changes (Core Infrastructure):**
    ```bash
    terraform apply -auto-approve
    ```
    This step will deploy the Resource Group, Virtual Network, Subnets, Network Security Groups, AKS Cluster, PostgreSQL VM, Redis Cache, and Storage Account.

6.  **Obtain Kubeconfig for Private AKS Cluster:**
    Once the core infrastructure deployment is complete, you need to obtain the `kubeconfig` for your private AKS cluster. **This command must be run from a machine that has network connectivity to the private AKS endpoint** (e.g., a jumpbox VM within the same VNet, or via Azure Bastion/VPN).

    ```bash
    az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster-name> --file ~/.kube/config --overwrite-existing
    ```
    Replace `<your-resource-group>` and `<your-aks-cluster-name>` with your actual values.

### Phase 2: Deploy Kubernetes Applications

After successfully deploying the core infrastructure and obtaining `kubeconfig` for your private AKS cluster, you can proceed with deploying the OptScale Kubernetes applications.

1.  **Uncomment the Kubernetes Application Module:**
    Open `main.tf` and uncomment the `module "optscale_kubernetes_app"` block.

2.  **Initialize Terraform (again):**
    ```bash
    terraform init -upgrade
    ```

3.  **Review the Plan (Kubernetes Apps):**
    ```bash
    terraform plan
    ```

4.  **Apply the Changes (Kubernetes Apps):
    ```bash
    terraform apply -auto-approve
    ```
    This step will deploy the Kubernetes Namespace, Secrets, Deployments (RabbitMQ, OptScale Backend, OptScale Frontend), and Services onto your AKS cluster.

5.  **Verify Deployment:**
    After the deployment completes, verify the created Azure resources in the Azure portal and the Kubernetes deployments within your AKS cluster using `kubectl get all -n optscale`.

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
    *   `private_cluster_enabled`: Enable/disable private cluster (default: `true`).
    *   `azure_policy_enabled`: Enable/disable Azure Policy Add-on.
    *   `admin_group_object_ids`: Azure AD Group Object IDs for AKS admin access.
*   **OptScale Specific Variables:**
    *   `db_admin_login`, `db_admin_password`: PostgreSQL VM administrator login and password.
    *   `db_vm_size`: The VM size for the PostgreSQL VM (e.g., `Standard_B1s`, `Standard_D2s_v3`).
    *   `db_subnet_name`, `db_subnet_address_prefixes`: Subnet configuration for the PostgreSQL VM.
    *   `redis_cache_name`, `redis_cache_sku`: Azure Cache for Redis configuration.
    *   `storage_account_name`: Azure Storage Account configuration.
    *   `optscale_version`: The version of OptScale to deploy.

## Module Breakdown

*   **`modules/aks_networking/`**: Deploys the Virtual Network, Subnets (for AKS and DB VM), and Network Security Groups for the AKS environment.
*   **`modules/aks_cluster/`**: Deploys the AKS cluster itself, including system and user node pools with scale sets, and integrates with networking.
*   **`modules/optscale_db_vm/`**: Deploys a Linux Virtual Machine and installs PostgreSQL on it using a Custom Script Extension.
*   **`modules/optscale_cache/`**: Deploys an Azure Cache for Redis.
*   **`modules/optscale_storage/`**: Deploys an Azure Storage Account (Blob Storage).
*   **`modules/optscale_kubernetes_app/`**: Deploys OptScale components (backend, frontend, RabbitMQ) as Kubernetes Deployments, Services, ConfigMaps, and Secrets onto the AKS cluster.

## Troubleshooting Common Issues

*   **`LocationIsOfferRestricted` for PostgreSQL Flexible Server:**
    This error indicates that your Azure subscription has a policy restricting the creation of PostgreSQL Flexible Servers in the chosen region. The current solution uses a VM-based PostgreSQL to bypass this. If you wish to use the Flexible Server, you must contact Azure support to request a quota increase or policy exception for your subscription.

*   **`Resource already exists` or `Cannot import non-existent remote object`:**
    These errors occur when Terraform's state is out of sync with the actual resources in Azure. This can happen if a previous `terraform apply` failed partway through, or if resources were created/deleted manually.
    *   **Solution:** If the resource truly exists in Azure, you can import it into your Terraform state using `terraform import <terraform_resource_address> <azure_resource_id>`.
    *   If the resource does *not* exist in Azure, but Terraform thinks it does, you can remove it from the state using `terraform state rm <terraform_resource_address>`.
    *   **Important:** Always run `terraform plan` after any state manipulation to ensure Terraform's understanding of the infrastructure is correct.

*   **`dial tcp: lookup ... no such host` (for private AKS cluster):**
    This error means the machine running Terraform cannot resolve or reach the private API endpoint of your AKS cluster. This is expected for private clusters.
    *   **Solution:** You must run Terraform from a machine that has network connectivity to the private AKS API server. This typically involves using a jumpbox VM within the same VNet, a VPN connection, or Azure Bastion.

*   **`remote-exec provisioner error` or `Invalid expression` in `modules/optscale_db_vm/main.tf`:**
    These errors indicate issues with the `remote-exec` provisioner attempting to run commands on the PostgreSQL VM. This is often due to network connectivity issues or syntax errors in the script.
    *   **Solution:** The current solution uses `azurerm_virtual_machine_extension` (Custom Script Extension) to install PostgreSQL, which is a more reliable method for running scripts on Azure VMs. Ensure the script within the `commandToExecute` block is syntactically correct for the VM's operating system.

## Important Notes

*   **Kubernetes Version:** Always ensure the `kubernetes_version` specified in `terraform.tfvars` is a currently supported GA version in your chosen Azure region. You can check supported versions using `az aks get-versions --location <your-location> --output table`.
*   **AKS Private Cluster:** If `private_cluster_enabled` is true, remember the network connectivity requirements for managing the cluster and deploying applications.
*   **OptScale Configuration:** The `optscale_kubernetes_app` module provides a basic deployment. You may need to further customize OptScale's configuration (e.g., environment variables, scaling, ingress) based on your specific needs and the official OptScale documentation.
*   **OptScale Data Initialization:** Initializing OptScale's database and running migrations might be a separate step after deployment, as per OptScale's official documentation.
