terraform {
  required_version = ">= 1.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    mysql = {
      source  = "Paynetworx/mysql"
      version = "~> 1.12"
    }
  }
}

provider "azurerm" {
  features {}
}
