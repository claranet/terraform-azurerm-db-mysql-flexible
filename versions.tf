terraform {
  required_version = ">= 0.14"
  experiments      = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
    }
    mysql = {
      source  = "winebarrel/mysql"
      version = ">=1.10.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.6"
    }
  }
}
