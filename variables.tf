# Azure Subscription ID needed for authentication
variable "az-subscription-id" {
  type        = string
  description = "Azure Subscription ID"
}

# Azure Tenant ID needed for authentication
variable "az-tenant-id" {
  type        = string
  description = "Azure Tenant ID"
}

# Specifies the Azure region where the resource group will be created
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "us central"
}

# Publisher of the Debian 12 virtual machine image
variable "linux_vm_image_publisher_debian_12" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "Debian"
}

# Offer name for the Debian 12 virtual machine image
variable "linux_vm_image_offer_debian_12" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "debian-12"
}

# SKU version for the latest Debian 12 image
variable "debian_12_sku" {
  type        = string
  description = "SKU for latest Debian 12"
  default     = "12"
}

# Defines the size (SKU) of the virtual machine
variable "linux_vm_size" {
  type        = string
  description = "Size (SKU) of the virtual machine to create"
}

# Admin username for the virtual machine
variable "linux_admin_username" {
  type        = string
  description = "Username for Virtual Machine administrator account"
  default     = ""
}

# Admin password for the virtual machine
variable "linux_admin_password" {
  type        = string
  description = "Password for Virtual Machine administrator account"
  default     = ""
}

# Name of the WordPress database
variable "wordpress_db_name" {
  description = "WordPress DB Name"
  type        = string
  default     = "wordpress"
}

# Hostname for the WordPress database
variable "db_host_name" {
  description = "WordPress DB hostname"
  type        = string
  default     = "localhost"
}

# CIDR block for the Virtual Network (VNET)
variable "net-vnet-cidr" {
  type        = string
  description = "The CIDR of the network VNET"
}

# CIDR block for the subnet inside the Virtual Network
variable "net-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}