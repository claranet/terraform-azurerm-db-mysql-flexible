locals {
  tier_map = {
    "GeneralPurpose"  = "GP"
    "Burstable"       = "B"
    "MemoryOptimized" = "MO"
  }

  administrator_password = coalesce(var.administrator_password, one(random_password.administrator_password[*].result))

  recommended_options = merge(
    {
      slow_query_log                  = "ON"
      long_query_time                 = "5"
      interactive_timeout             = "28800"
      wait_timeout                    = "28800"
      innodb_change_buffering         = "all"
      innodb_change_buffer_max_size   = "50"
      innodb_print_all_deadlocks      = "ON"
      max_allowed_packet              = "1073741824" # 1GB
      explicit_defaults_for_timestamp = "OFF"
      sql_mode                        = "ERROR_FOR_DIVISION_BY_ZERO,STRICT_TRANS_TABLES"
    },
    var.mysql_version != "5.7" ? {
      sql_generate_invisible_primary_key = "OFF"
      transaction_isolation              = "READ-COMMITTED"
    } : {},
  )

  options = merge(
    var.audit_logs_enabled ? {
      audit_log_enabled = "ON"
      audit_log_events  = "CONNECTION,ADMIN,CONNECTION_V2,DCL,DDL,DML,DML_NONSELECT,DML_SELECT,GENERAL,TABLE_ACCESS"
    } :
    {
      audit_log_enabled = "OFF"
    },
    var.recommended_options_enabled ? local.recommended_options : {},
    {
      require_secure_transport = var.ssl_enforced ? "ON" : "OFF"
    },
    var.options,
  )
}
