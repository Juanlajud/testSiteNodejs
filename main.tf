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

resource "azurerm_application_insights" "appinsights" {
  name                = "appinsights"
  location            = azurerm_resource_group.JWA.location
  resource_group_name = azurerm_resource_group.JWA.name
  application_type    = "web"

}

resource "azurerm_servicebus_namespace" "jumbolajudapp" {
  name                = "jumbolajudapp"
  location            = azurerm_resource_group.JWA.location
  resource_group_name = azurerm_resource_group.JWA.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "lajudtestqueue" {
  name                = "lajudtestqueue"
  resource_group_name = azurerm_resource_group.JWA.name
  namespace_name      = azurerm_servicebus_namespace.jumbolajudapp.name

  enable_partitioning = true
}

resource "azurerm_servicebus_queue_authorization_rule" "sendtest" {
  name                = "sendtest"
  namespace_name      = azurerm_servicebus_namespace.jumbolajudapp.name
  queue_name          = azurerm_servicebus_queue.lajudtestqueue.name
  resource_group_name = azurerm_resource_group.JWA.name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_servicebus_queue_authorization_rule" "listentest" {
  name                = "listentest"
  namespace_name      = azurerm_servicebus_namespace.jumbolajudapp.name
  queue_name          = azurerm_servicebus_queue.lajudtestqueue.name
  resource_group_name = azurerm_resource_group.JWA.name

  listen = true
  send   = false
  manage = false
}