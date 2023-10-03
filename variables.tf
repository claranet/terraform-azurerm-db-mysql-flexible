variable "location" {
  description = "Azure location"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "administrator_login" {
  description = "MySQL administrator login. Required when create_mode is Default."
  type        = string
  default     = null
}

variable "administrator_password" {
  description = "MySQL administrator password. If not set, randomly generated"
  type        = string
  default     = null
}

variable "allowed_cidrs" {
  description = "Map of authorized CIDRs"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Map of custom tags"
  type        = map(string)
  default     = {}
}

variable "mysql_version" {
  description = "MySQL server version. Valid values are `5.7` and `8.0.21`"
  type        = string
  default     = "8.0.21"
}

variable "mysql_options" {
  description = "Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters."
  type        = map(string)
  default     = {}
}

variable "geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. Not available for the Burstable tier."
  type        = bool
  default     = true
}

variable "create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers."
  type        = string
  default     = "Default"
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between `7` and `35` days."
  type        = number
  default     = 10
}

variable "databases" {
  description = "Map of databases with default collation and charset."
  type        = map(map(string))
  default     = {}
}

variable "tier" {
  description = "Tier for MySQL flexible server SKU. Possible values are: `GeneralPurpose`, `Burstable`, `MemoryOptimized`."
  type        = string
  default     = "GeneralPurpose"
}

variable "size" {
  description = "The size for the MySQL Flexible Server."
  type        = string
  default     = "Standard_D2ds_v4"
}

variable "delegated_subnet_id" {
  description = "The ID of the virtual network subnet to create the MySQL Flexible Server."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private dns zone to create the MySQL Flexible Server."
  type        = string
  default     = null
}

variable "source_server_id" {
  description = "The resource ID of the source MySQL Flexible Server to be restored."
  type        = string
  default     = null
}

variable "high_availability" {
  description = "Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability"
  type = object({
    mode                      = string
    standby_availability_zone = optional(number)
  })
  default = {
    mode                      = "SameZone"
    standby_availability_zone = 1
  }
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance"
  type        = map(number)
  default     = null
}

variable "storage" {
  description = "Map of the storage configuration"
  type = object({
    auto_grow_enabled = optional(bool)
    iops              = optional(number)
    size_gb           = optional(number)
  })
  default = null
}

variable "ssl_enforced" {
  description = "Enforce SSL connection on MySQL provider and set require_secure_transport on MySQL Server"
  type        = bool
  default     = true
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3"
  type        = number
  default     = 1
}

variable "identity_ids" {
  description = "A list of User Assigned Managed Identity IDs to be assigned to this MySQL Flexible Server."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "entra_authentication" {
  description = "Azure Entra authentication configuration block for this Azure MySQL Flexible Server. You have to assign `Directory Readers` Azure Entra role to the User Assigned Identity, see [documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin). See dedicated [example](examples/entra-auth/modules.tf)."
  type = object({
    user_assigned_identity_id = optional(string, null)
    login                     = optional(string, null)
    object_id                 = optional(string, null)
  })
  default = {}
}

variable "point_in_time_restore_time_in_utc" {
  description = "The point in time to restore from creation_source_server_id when create_mode is PointInTimeRestore. Changing this forces a new MySQL Flexible Server to be created."
  type        = string
  default     = null
}
