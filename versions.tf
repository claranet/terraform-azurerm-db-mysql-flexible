terraform {
  required_version = ">= 1.1.0"
  experiments      = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    mysql = {
      source  = "winebarrel/mysql"
      version = ">= 1.10.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.12"
    }
  }
}
