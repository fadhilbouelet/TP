
resource "azurerm_storage_account" "main" {
  name                     = "monvmstorageacct"       
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
   min_tls_version          = "TLS1_2"             # forcer HTTPS

  network_rules {
    default_action = "Allow"   # autorise tout le trafic (ou "Deny" + IPs autorisées)
  }

  blob_properties {
    delete_retention_policy {
      days = 7                 # exemple : retention de 7 jours
    }
  }
}


resource "azurerm_storage_container" "main" {
  name                  = "moncontainer"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"   # accès via clé ou SAS
}
