provider "mysql" {
  alias = "users_mgmt"

  endpoint = format("%s:3306", azurerm_mysql_flexible_server.mysql_flexible_server.fqdn)
  username = local.administrator_login
  password = local.administrator_password

  tls = var.ssl_enforced
}
