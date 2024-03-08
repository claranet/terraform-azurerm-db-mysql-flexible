locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  mysql_flexible_server_name = coalesce(var.custom_server_name, lower(data.azurecaf_name.mysql_flexible_name.result))
}
