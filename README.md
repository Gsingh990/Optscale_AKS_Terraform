# OptScale AKS Deployment

This project deploys a complete OptScale environment on Azure Kubernetes Service (AKS).

## Prerequisites

- Azure CLI
- Terraform
- An Azure subscription

## Setup

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd optscale-aks-deployment
    ```

2.  **Log in to Azure:**

    ```bash
    az login
    ```

3.  **Configure Terraform variables (Environment Variables Recommended):**

    For sensitive variables like `tenant_id`, `agent_object_id`, `db_admin_password`, and `bastion_admin_password`, it is highly recommended to set them as environment variables rather than directly in `terraform.tfvars`.

    ```bash
    export TF_VAR_tenant_id="<your-tenant-id>"
    export TF_VAR_agent_object_id="<your-agent-object-id>"
    export TF_VAR_db_admin_password="<YourSecureDbPassword!123>"
    export TF_VAR_bastion_admin_password="<YourBastionPassword!123>"
    ```

    For other variables, you can create a `terraform.tfvars` file and populate it with the required values. You can use the `terraform.tfvars.example` file as a template.

4.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

5.  **Apply the Terraform configuration:**

    ```bash
    terraform apply
    ```

## Architecture

This project provisions the following resources:

-   An Azure Resource Group
-   An Azure Virtual Network with subnets for AKS, database, and Azure Bastion
-   An Azure Kubernetes Service (AKS) cluster (private endpoint enabled)
-   A PostgreSQL database running on a virtual machine
-   An Azure Cache for Redis
-   An Azure Storage Account
-   An Azure Key Vault for storing secrets
-   An Azure Bastion Service for secure access to VMs within the VNet
-   A Bastion Host VM (for demonstration/alternative access, though Azure Bastion Service is preferred)

## Security

-   The database password is automatically generated and stored in Azure Key Vault.
-   The AKS cluster is configured with a private endpoint, meaning its API server is not accessible from the public internet. This enhances security by limiting exposure.
-   Azure Policy is enforced to prevent public IPs on network interfaces, ensuring a secure network posture.
-   Azure Bastion Service provides secure and seamless RDP/SSH connectivity to your virtual machines directly from the Azure portal over SSL, without exposing them to the public internet.

## Deploying Kubernetes Applications

Due to the private AKS cluster, direct `kubectl` access from outside the Azure Virtual Network is not possible. To deploy Kubernetes applications (like the `optscale_kubernetes_app` module), you need to do so from within the virtual network.

1.  **Connect to a VM via Azure Bastion:**

    You can use the Azure Bastion Service to securely connect to any VM within your virtual network (e.g., the `optscale-db-vm` or any other jumpbox/bastion VM you provision).

    *   Navigate to the Azure portal.
    *   Go to the Virtual Machine you wish to connect to.
    *   Click on the "Connect" button and select "Bastion".
    *   Provide your `admin_username` and `admin_password` (or SSH private key) to establish the connection.

2.  **Configure `kubectl` on the connected VM:**

    Once connected to a VM within the VNet, you can configure `kubectl` to interact with your private AKS cluster. Run the following Azure CLI command on the VM:

    ```bash
    az aks get-credentials --resource-group <your-resource-group-name> --name <your-aks-cluster-name> --overwrite-existing
    ```

3.  **Apply Kubernetes manifests:**

    From the connected VM, you can now apply your Kubernetes manifests or run Terraform to deploy the `optscale_kubernetes_app` module:

    ```bash
    # If using Terraform for Kubernetes deployments
    cd /path/to/your/optscale_aks_deployment
    terraform init
    terraform apply
    ```

    Alternatively, if you have raw Kubernetes YAML files:

    ```bash
    kubectl apply -f your-app-manifests.yaml
    ```
