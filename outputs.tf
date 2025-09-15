# outputs.tf

# Affiche l'IP publique
output "public_ip" {
  description = "L'adresse IP publique de la VM"
  value       = azurerm_public_ip.main.ip_address
}

# Affiche le nom DNS complet
output "public_dns" {
  description = "Le FQDN (nom DNS) de la VM"
  value       = azurerm_public_ip.main.fqdn
}
