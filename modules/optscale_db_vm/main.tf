resource "azurerm_network_interface" "db_vm_nic" {
  name                = "${var.db_vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.db_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "db_vm" {
  name                = var.db_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.db_vm_size
  admin_username      = var.db_admin_login
  admin_password      = var.db_admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.db_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "install_postgres" {
  name                 = "install-postgres"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = azurerm_linux_virtual_machine.db_vm.id
  settings = jsonencode({
    commandToExecute = <<-EOF
      sudo apt-get update
      sudo apt-get install -y postgresql postgresql-contrib
      sudo -u postgres psql -c "CREATE USER ${var.db_admin_login} WITH PASSWORD '${var.db_admin_password}';"
      sudo -u postgres psql -c "CREATE DATABASE optscale OWNER ${var.db_admin_login};"
      sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf
      echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
      sudo systemctl restart postgresql
    EOF
  })
  tags = var.tags
}
