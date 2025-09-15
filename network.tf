# network.tf

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.resource_group_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH-From-My-IP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"  # Autorise uniquement cette IP
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.main.id  # Interface réseau de la VM
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}



