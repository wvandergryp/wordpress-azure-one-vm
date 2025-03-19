# Def Terraform provider
terraform {
  required_version = "~> 1.0"
}

# Config the Azure provider
provider "azurerm" { 
  features {}  
  environment     = "public"
  subscription_id = var.az-subscription-id
  tenant_id       = var.az-tenant-id
}
