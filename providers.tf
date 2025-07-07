terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

# Configure the Kubernetes provider using outputs from the deployed AKS cluster
provider "kubernetes" {
  host                   = module.aks_cluster.kube_config.0.host
  client_certificate     = base64decode(module.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(module.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks_cluster.kube_config.0.cluster_ca_certificate)
}