terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
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
