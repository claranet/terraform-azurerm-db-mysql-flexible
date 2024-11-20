# Azure Database for MySQL Flexible Server

Azure Managed DB - MySQL Flexible

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/db-mysql-flexible/azurerm/)

This Terraform module creates an [Azure MySQL Flexible Server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server)
with [databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database)
and associated admin users, along with enabled logging and
[firewall rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule).

Following MySQL configuration options are set by default and can be overridden with the `options` variable or
fully disabled by setting the variable `recommended_options_enabled` to `false`:

```
slow_query_log: ON
long_query_time: 5
interactive_timeout: 28800
wait_timeout: 28800
innodb_change_buffering: all
innodb_change_buffer_max_size: 50
innodb_print_all_deadlocks: ON
max_allowed_packet: 1073741824 # 1GB
explicit_defaults_for_timestamp: OFF
sql_mode: ERROR_FOR_DIVISION_BY_ZERO,STRICT_TRANS_TABLES
sql_generate_invisible_primary_key: OFF # MySQL 8 only
transaction_isolation: READ-COMMITTED
```

MySQL options for SSL and audit logs can be respectively enabled with the `ssl_enforced` and `audit_logs_enabled` variables.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "mysql_flexible" {
  source  = "claranet/db-mysql-flexible/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  tier          = "GeneralPurpose"
  mysql_version = "8.0.21"

  allowed_cidrs = {
    "peered-vnet"     = "10.0.0.0/24"
    "customer-office" = "12.34.56.78/32"
  }

  backup_retention_days        = 10
  geo_redundant_backup_enabled = true

  administrator_login = "azureadmin"

  databases = {
    "documents" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }

  options = {
    interactive_timeout = "600"
    wait_timeout        = "260"
  }

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "mysql" {
  endpoint = "${module.mysql_flexible.fqdn}:3306"
  username = module.mysql_flexible.administrator_login
  password = module.mysql_flexible.administrator_password

  tls = true
}

module "mysql_users" {
  source  = "claranet/users/mysql"
  version = "x.x.x"

  for_each = module.mysql_flexible.databases_names

  user     = each.key
  database = each.key

  user_suffix_enabled = true
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.28 |
| azurerm | ~> 4.0 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_flexible_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_active_directory_administrator.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_active_directory_administrator) | resource |
| [azurerm_mysql_flexible_server_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [random_password.administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurecaf_name.mysql_flexible_databases](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.mysql_flexible_server](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_client_config.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | MySQL administrator login. Required when `create_mode = "Default"`. | `string` | `null` | no |
| administrator\_password | MySQL administrator password. If not set, password is randomly generated. | `string` | `null` | no |
| allowed\_cidrs | Map of allowed CIDRs. | `map(string)` | `{}` | no |
| audit\_logs\_enabled | Whether MySQL audit logs are enabled. Categories `CONNECTION`, `ADMIN`, `CONNECTION_V2`, `DCL`, `DDL`, `DML`, `DML_NONSELECT`, `DML_SELECT`, `GENERAL` and `TABLE_ACCESS` are set by default when enabled<br/>  and can be overridden with `options` variable. See https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-audit-logs#configure-audit-logging." | `bool` | `false` | no |
| backup\_retention\_days | Backup retention days for the MySQL Flexible Server. Supported values are between 7 and 35 days. | `number` | `10` | no |
| caf\_naming\_for\_databases\_enabled | Use the Azure CAF naming provider to generate databases name. | `bool` | `false` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| create\_mode | The creation mode which can be used to restore or replicate existing servers. | `string` | `"Default"` | no |
| custom\_name | Custom server name. | `string` | `""` | no |
| databases | Map of databases with default collation and charset. | <pre>map(object({<br/>    charset   = optional(string, "utf8")<br/>    collation = optional(string, "utf8_general_ci")<br/>  }))</pre> | `{}` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| delegated\_subnet\_id | The ID of the Virtual Network Subnet to create the MySQL Flexible Server. | `string` | `null` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| entra\_authentication | Azure Entra authentication configuration block for this Azure MySQL Flexible Server. You have to assign the `Directory Readers` Azure Entra role to the User Assigned Identity, see [documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin). See dedicated [example](examples/entra-auth/modules.tf). | <pre>object({<br/>    user_assigned_identity_id = optional(string)<br/>    login                     = optional(string)<br/>    object_id                 = optional(string)<br/>  })</pre> | `{}` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Map of custom tags. | `map(string)` | `{}` | no |
| geo\_redundant\_backup\_enabled | Enable or disable geo-redundant server backups. Not available for the burstable tier. | `bool` | `true` | no |
| high\_availability | Object of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability. | <pre>object({<br/>    mode                      = optional(string, "SameZone")<br/>    standby_availability_zone = optional(number, 1)<br/>  })</pre> | `{}` | no |
| identity\_ids | A list of User Assigned Managed Identity IDs to be assigned to this MySQL Flexible Server. | `list(string)` | `[]` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| maintenance\_window | Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance. | <pre>object({<br/>    day_of_week  = optional(number, 0)<br/>    start_hour   = optional(number, 0)<br/>    start_minute = optional(number, 0)<br/>  })</pre> | `null` | no |
| mysql\_version | MySQL server version. Valid values are `5.7` and `8.0.21`. | `string` | `"8.0.21"` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| options | Map of MySQL configuration options: https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html. See README for default values. | `map(string)` | `{}` | no |
| point\_in\_time\_restore\_time\_in\_utc | The point in time to restore from `creation_source_server_id` when `create_mode = "PointInTimeRestore"`. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| private\_dns\_zone\_id | The ID of the Private DNS Zone to create the MySQL Flexible Server. | `string` | `null` | no |
| recommended\_options\_enabled | Whether or not to use recommended options. | `bool` | `true` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| size | The size for the MySQL Flexible Server. | `string` | `"Standard_D2ds_v4"` | no |
| source\_server\_id | The resource ID of the source MySQL Flexible Server to be restored. | `string` | `null` | no |
| ssl\_enforced | Enforce SSL connection on MySQL provider. This sets the `require_secure_transport` option on the MySQL Flexible Server. | `bool` | `true` | no |
| stack | Project stack name. | `string` | n/a | yes |
| storage | Object of storage configuration. | <pre>object({<br/>    auto_grow_enabled  = optional(bool, true)<br/>    size_gb            = optional(number)<br/>    io_scaling_enabled = optional(bool, false)<br/>    iops               = optional(number)<br/>  })</pre> | `{}` | no |
| tier | Tier for MySQL Flexible Server SKU. Possible values are: `GeneralPurpose`, `Burstable` and `MemoryOptimized`. | `string` | `"GeneralPurpose"` | no |
| zone | Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are `1`, `2` and `3`. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| administrator\_login | Administrator login for MySQL Flexible Server. |
| administrator\_password | Administrator password for MySQL Flexible Server. |
| databases\_ids | Map of databases IDs. |
| databases\_names | Map of databases names. |
| firewall\_rules\_ids | Map of firewall rules IDs. |
| fqdn | FQDN of the MySQL Flexible Server. |
| id | ID of the Azure MySQL Flexible Server. |
| module\_diagnostics | Diagnostics settings module outputs. |
| name | Name of the Azure MySQL Flexible Server. |
| options | MySQL server configuration options. |
| public\_network\_access\_enabled | Is the public network access enabled? |
| replica\_capacity | The maximum number of replicas that a primary MySQL Flexible Server can have. |
| resource | Azure MySQL server resource object. |
| resource\_configuration | Azure MySQL configuration resource object. |
| resource\_database | Azure MySQL database resource object. |
| resource\_firewall\_rule | Azure MySQL server firewall rule resource object. |
| terraform\_module | Information about this Terraform module. |
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Azure documentation: [docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview](https://docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview)
- Microsoft Azure Entra authentication documentation: [learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin)
