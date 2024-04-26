output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "db-mysql-flexible"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
