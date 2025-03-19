# Create a resource group for all resources
resource "azurerm_resource_group" "net-rg" {
  name     = "linux-wordpress-rg"
  location = var.location
}

# Create a virtual network with a defined address space
resource "azurerm_virtual_network" "net-vnet" {
  name                = "linux-wordpress-vnet"
  address_space       = [var.net-vnet-cidr]
  resource_group_name = azurerm_resource_group.net-rg.name
  location            = azurerm_resource_group.net-rg.location
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "net-subnet" {
  name                 = "linux-wordpress-subnet"
  address_prefixes     = [var.net-subnet-cidr]
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  resource_group_name  = azurerm_resource_group.net-rg.name
}

# Generate a random string for the Linux VM name
resource "random_string" "linux-vm-name" {
  length  = 8
  upper   = false
  number  = false
  lower   = true
  special = false
}

# Create a network security group with rules for HTTP and SSH access
resource "azurerm_network_security_group" "linux-vm-nsg" {
  depends_on=[azurerm_resource_group.net-rg]

  name                = "linux-wordpress-nsg"
  location            = azurerm_resource_group.net-rg.location
  resource_group_name = azurerm_resource_group.net-rg.name

  security_rule {
    name                       = "HTTP"
    description                = "Allow HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    description                = "Allow SSH"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# Associate the network security group with the subnet
resource "azurerm_subnet_network_security_group_association" "linux-vm-nsg-association" {
  depends_on=[azurerm_resource_group.net-rg]

  subnet_id                 = azurerm_subnet.net-subnet.id
  network_security_group_id = azurerm_network_security_group.linux-vm-nsg.id
}

# Create a static public IP for the Linux VM
resource "azurerm_public_ip" "linux-vm-ip" {
  depends_on=[azurerm_resource_group.net-rg]

  name                = "linux-${random_string.linux-vm-name.result}-ip"
  location            = azurerm_resource_group.net-rg.location
  resource_group_name = azurerm_resource_group.net-rg.name
  allocation_method   = "Static"
}

# Create a network interface for the Linux VM
resource "azurerm_network_interface" "linux-vm-nic" {
  depends_on=[azurerm_resource_group.net-rg]

  name                = "linux-${random_string.linux-vm-name.result}-nic"
  location            = azurerm_resource_group.net-rg.location
  resource_group_name = azurerm_resource_group.net-rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.net-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip.id
  }
}

# Generate a random password for the database
resource "random_string" "random_password" {
 length    = 24
 special   = false
 min_upper = 5
 min_lower = 5
}

# Create a Linux virtual machine with Debian 12
resource "azurerm_linux_virtual_machine" "linux-vm" {
  depends_on=[azurerm_network_interface.linux-vm-nic]

  location              = azurerm_resource_group.net-rg.location
  resource_group_name   = azurerm_resource_group.net-rg.name
  name                  = "linux-${random_string.linux-vm-name.result}-vm"
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
  size                  = var.linux_vm_size

  source_image_reference {
    offer     = var.linux_vm_image_offer_debian_12
    publisher = var.linux_vm_image_publisher_debian_12
    sku       = var.debian_12_sku
    version   = "latest"
  }

  os_disk {
    name                 = "linux-${random_string.linux-vm-name.result}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = "linux-${random_string.linux-vm-name.result}-vm"
  admin_username = var.linux_admin_username
  admin_password = var.linux_admin_password
  custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  disable_password_authentication = false
}

# Define cloud-init data to configure the VM during provisioning
data "template_file" "linux-vm-cloud-init" {
    template = file("${path.module}/installmaria.sh")
    vars = {
      DB_USERNAME       = random_string.random_password.result
      DB_HOST           = var.db_host_name
      WORDPRESS_DB_NAME = var.wordpress_db_name
      WORDPRESS_DB_USER = random_string.random_password.result
      DB_USER_PASSWORD  = random_string.random_password.result
      DB_ROOT_PASSWORD  = random_string.random_password.result    
    }
}