variable "logs_destinations_ids" {
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging"
  type        = list(string)
}

variable "logs_categories" {
  description = "Log categories to send to destinations"
  type        = list(string)
  default     = null
}

variable "logs_metrics_categories" {
  description = "Metrics categories to send to destinations"
  type        = list(string)
  default     = null
}

variable "logs_retention_days" {
  description = "Number of days to keep logs on storage account"
  type        = number
  default     = 30
}

variable "custom_diagnostic_settings_name" {
  description = "Custom name of the diagnostics settings, name will be 'default' if not set."
  type        = string
  default     = "default"
}
