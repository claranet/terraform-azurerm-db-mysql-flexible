locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  name_suffix = lower(var.name_suffix)

  mysql_flexible_server_name = coalesce(var.custom_server_name, lower(data.azurecaf_name.mysql_flexible_name.result))
}
