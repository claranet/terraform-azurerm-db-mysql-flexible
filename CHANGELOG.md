# v7.2.0 - 2023-10-13

Breaking
  * AZ-1153: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))

# v7.1.2 - 2023-01-13

Fixed
  * AZ-937: Roll back to original behavior for firewall rules as it prevents deployment from scratch

# v7.1.1 - 2022-12-14

Fixed
  * AZ-937: Fix Firewall Rules condition

# v7.1.0 - 2022-11-25

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `v1.3`

# v6.2.1 - 2022-08-05

Fixed
  * AZ-786: Upgrade azurecaf to `v1.2.18` to fix https://github.com/aztfmod/terraform-provider-azurecaf/issues/162

# v6.2.0 - 2022-07-01

Breaking
  * AZ-762: Externalize `mysql-users` as a separated module in a dedicated repo (to create admin users per database)

# v6.6.1 - 2022-07-01

Fixed
  * AZ-791: B is Burstable

# v6.1.0 - 2022-06-24

Changed
  * AZ-788: `ssl_enforce` parameter now also configure mysql server instance
  * AZ-788: don't try to create firewall rules if vnet integration

Fixed
  * AZ-788: documentation
  * AZ-788: remove `allowed_subnets`, this does not exist actually on flexible mysql

# v6.0.0 - 2022-06-17

Added
  * AZ-601: Init Azure Managed MySQL flexible database module
  * AZ-770: Add Terraform module info in output
