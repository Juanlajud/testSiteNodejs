// declaring provider. Azure
  provider "azurerm" {
    features {}
  }

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.71.0"
    } 
  }
}

terraform {
  backend "azurerm" {
        resource_group_name  = "tfstate_blob"
        storage_account_name = "tfstatebloblajud"
        container_name       = "tfstateblob"
        key                  = "terraform.tfstate"
    }
  }


// creating variables.tf file in order to make changes easier. using this global variables can be overriden using .tfvars file

resource "azurerm_resource_group" "JWA" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_container_group" "jwacontainer" {
  name                = "jwacontainergroup"
  location            = azurerm_resource_group.JWA.location
  resource_group_name = azurerm_resource_group.JWA.name

  ip_address_type = "Public"
  dns_name_label = "jwacontainerlajud"
  os_type = "Linux"

  container {
    name = "jumbodemoapp"
    image = "juanlajud/jumbodemoapp:1.1"
    cpu = "1"
    memory = "1"

    ports {
      port = 8080
      protocol = "TCP"
    }
  }

}