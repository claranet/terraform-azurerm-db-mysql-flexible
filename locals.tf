locals {

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  administrator_login    = azurerm_mysql_flexible_server.mysql_flexible_server.administrator_login
  administrator_password = coalesce(var.administrator_password, random_password.mysql_administrator_password.result)

  tier_map = {
    "GeneralPurpose"  = "GP"
    "Burstable"       = "B"
    "MemoryOptimized" = "MO"
  }


  recommended_mysql_options = merge({
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
    transaction_isolation           = "READ-COMMITTED"
    }, var.mysql_version != "5.7" ? {
    sql_generate_invisible_primary_key = "OFF"
  } : {})

  mysql_options = merge(
    var.mysql_audit_logs_enabled ? {
      audit_log_enabled = "ON"
      audit_log_events  = "CONNECTION,ADMIN,CONNECTION_V2,DCL,DDL,DML,DML_NONSELECT,DML_SELECT,GENERAL,TABLE_ACCESS"
      } : {
      audit_log_enabled = "OFF"
    },
    var.mysql_recommended_options_enabled ? local.recommended_mysql_options : {},
    { require_secure_transport = var.ssl_enforced ? "ON" : "OFF" },
    var.mysql_options,
  )
}
