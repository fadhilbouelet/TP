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

output "storage_account_name" {
  description = "Nom du Storage Account"
  value       = azurerm_storage_account.main.name
}

output "storage_container_name" {
  description = "Nom du Storage Container"
  value   

