variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}

variable "administrator_login" {
  description = "MySQL administrator login. Required when `create_mode = \"Default\"`."
  type        = string
  default     = null
}

variable "administrator_password" {
  description = "MySQL administrator password. If not set, password is randomly generated."
  type        = string
  default     = null
}

variable "tier" {
  description = "Tier for MySQL Flexible server SKU. Possible values are: `GeneralPurpose`, `Burstable` and `MemoryOptimized`."
  type        = string
  default     = "GeneralPurpose"
}

variable "size" {
  description = "The size for the MySQL Flexible server."
  type        = string
  default     = "Standard_D2ds_v4"
}

variable "mysql_version" {
  description = "MySQL server version. Valid values are `5.7` and `8.0.21`."
  type        = string
  default     = "8.0.21"
}

variable "delegated_subnet_id" {
  description = "The ID of the Virtual Network Subnet to create the MySQL Flexible server."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone to create the MySQL Flexible server."
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Backup retention days for the MySQL Flexible server. Supported values are between 7 and 35 days."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable or disable geo-redundant server backups. Not available for the burstable tier."
  type        = bool
  default     = true
}

variable "create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers."
  type        = string
  default     = "Default"
}

variable "source_server_id" {
  description = "The resource ID of the source MySQL Flexible server to be restored."
  type        = string
  default     = null
}

variable "point_in_time_restore_time_in_utc" {
  description = "The point in time to restore from `creation_source_server_id` when `create_mode = \"PointInTimeRestore\"`. Changing this forces a new MySQL Flexible server to be created."
  type        = string
  default     = null
}

variable "high_availability" {
  description = "Object of high availability configuration. See [documentation](https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability). `null` to disable high availability."
  type = object({
    mode                      = optional(string, "SameZone")
    standby_availability_zone = optional(number, 1)
  })
  default = {}
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration. See [documentation](https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance)."
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  default = null
}

variable "storage" {
  description = "Object of storage configuration."
  type = object({
    auto_grow_enabled  = optional(bool, true)
    size_gb            = optional(number)
    io_scaling_enabled = optional(bool, false)
    iops               = optional(number)
  })
  default = {}
}

variable "identity_ids" {
  description = "A list of User Assigned Managed Identity IDs to be assigned to this MySQL Flexible server."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible server should be located. Possible values are `1`, `2` and `3`."
  type        = number
  default     = null
}

variable "databases" {
  description = "Map of databases with default collation and charset."
  type = map(object({
    charset   = optional(string, "utf8")
    collation = optional(string, "utf8_general_ci")
  }))
  default = {}
}

variable "allowed_cidrs" {
  description = "Map of allowed CIDRs."
  type        = map(string)
  default     = {}
}

variable "options" {
  description = "Map of MySQL configuration options. See [documentation](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html). See README for default values."
  type        = map(string)
  default     = {}
}

variable "audit_logs_enabled" {
  description = <<EOD
  Whether MySQL audit logs are enabled. Categories `CONNECTION`, `ADMIN`, `CONNECTION_V2`, `DCL`, `DDL`, `DML`, `DML_NONSELECT`, `DML_SELECT`, `GENERAL` and `TABLE_ACCESS` are set by default when enabled
  and can be overridden with `options` variable. See [documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-audit-logs#configure-audit-logging)."
EOD
  type        = bool
  default     = false
  nullable    = false
}

variable "recommended_options_enabled" {
  description = "Whether or not to use recommended options."
  type        = bool
  nullable    = false
  default     = true
}

variable "ssl_enforced" {
  description = "Enforce SSL connection on MySQL provider. This sets the `require_secure_transport` option on the MySQL Flexible server."
  type        = bool
  default     = true
}

variable "entra_authentication" {
  description = "Azure Entra authentication configuration block for this Azure MySQL Flexible server. You have to assign the `Directory Readers` Azure Entra role to the User Assigned Identity, see [documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin). See dedicated [example](examples/entra-auth/modules.tf)."
  type = object({
    user_assigned_identity_id = optional(string)
    login                     = optional(string)
    object_id                 = optional(string)
  })
  default = {}
}

variable "backup_vault_policy" {
  description = "Backup vault policy configuration to use for MySQL Flexible Long term retention backups."
  type = object(
    {
      policy_id       = string,
      backup_vault_id = string
    }

  )
  default = null
}
