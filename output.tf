output "sendconnectionstring" {
  value = azurerm_servicebus_queue_authorization_rule.sendtest.primary_connection_string
  sensitive = true
}

output "listenconnectionstring" {
  value = azurerm_servicebus_queue_authorization_rule.listentest.primary_connection_string
  sensitive = true
}