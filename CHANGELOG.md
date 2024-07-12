## 7.6.0 (2024-07-12)


### Features

* **AZ-1431:** default production configuration options 0cdd762


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 1517d5f
* **deps:** update dependency tflint to v0.52.0 e878b0a

## 7.5.0 (2024-07-05)


### Features

* **AZ-1433:** fix zone parameter default value c48e608


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.2 f1192cb
* **deps:** update dependency tflint to v0.51.2 4d9cf93
* **deps:** update dependency trivy to v0.52.0 3da846d
* **deps:** update dependency trivy to v0.52.1 35a57c3
* **deps:** update dependency trivy to v0.52.2 4f78700
* **deps:** update dependency trivy to v0.53.0 25f0ca2
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 06937f8

## 7.4.0 (2024-05-31)


### Features

* **AZ-1412:** ignore changes on zone parameters + add io_scaling_enabled parameter 0c75810


### Miscellaneous Chores

* **deps:** update dependency terraform-docs to v0.18.0 254ae30
* **deps:** update dependency trivy to v0.51.2 b532861
* **deps:** update dependency trivy to v0.51.4 1d7f32c

## 7.3.0 (2024-05-17)


### Features

* **AZ-1196:** add `point_in_time_restore_time_in_utc` 49761fe
* **AZ-1410:** manage entra authentication f75db2e


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.0 31642ef
* **deps:** update dependency opentofu to v1.7.1 5beaca0
* **deps:** update dependency pre-commit to v3.7.1 036bc65
* **deps:** update dependency tflint to v0.51.0 e847232
* **deps:** update dependency tflint to v0.51.1 11472e2
* **deps:** update dependency trivy to v0.51.0 6cc54f9
* **deps:** update dependency trivy to v0.51.1 f2e82eb

## 7.2.3 (2024-04-26)


### Styles

* **output:** remove unused version from outputs-module 39a711a


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 8a1ed0a
* **AZ-1391:** update semantic-release config [skip ci] 89a8f95


### Miscellaneous Chores

* **deps:** add renovate.json 70b6561
* **deps:** enable automerge on renovate b76e799
* **deps:** update dependency trivy to v0.50.2 99a1ef2
* **deps:** update dependency trivy to v0.50.4 ba9b3b2
* **deps:** update renovate.json 2b8856d
* **pre-commit:** update commitlint hook 80c49f2
* **release:** remove legacy `VERSION` file f905be8

# v7.2.2 - 2024-03-08

Fixed
  * AZ-1356: Fix name_prefix in naming

# v7.2.1 - 2023-11-10

Fixed
  * AZ-1243: Fix documentation about `tier` variable

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
