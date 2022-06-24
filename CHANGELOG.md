# Unreleased

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
