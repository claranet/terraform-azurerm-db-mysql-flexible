## 8.2.0 (2025-07-18)

### Features

* **AZ-1587:** add public_network_access_enabled variable d940a8e

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.10.3 61f0205

## 8.1.0 (2025-07-15)

### Features

* **AZ-1580:** ✨ add MySQL backup policy resource 16f00fe

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review 4047cde
* 🗑️ remove old commitlint configuration files 12344f4
* **AZ-1580:** 🔧 update `AZURERM_PROVIDER_MIN_VERSION` to `4.9` 239506a
* **AZ-1580:** 🔧 update `azurerm` provider version to `~> 4.9` d940910
* **AZ-1580:** apply suggestion 960576c
* **AZ-1580:** apply suggestion 7931404
* **deps:** update dependency opentofu to v1.10.0 7bf5953
* **deps:** update dependency opentofu to v1.10.1 716ecc1
* **deps:** update dependency opentofu to v1.9.1 222854b
* **deps:** update dependency pre-commit to v4.2.0 5eff6e8
* **deps:** update dependency terraform-docs to v0.20.0 c378529
* **deps:** update dependency tflint to v0.57.0 1055d1c
* **deps:** update dependency tflint to v0.58.0 aa9d455
* **deps:** update dependency tflint to v0.58.1 2337f71
* **deps:** update dependency trivy to v0.60.0 b637307
* **deps:** update dependency trivy to v0.61.1 0a8b8de
* **deps:** update dependency trivy to v0.62.0 2ba4c57
* **deps:** update dependency trivy to v0.62.1 e17569c
* **deps:** update dependency trivy to v0.63.0 d23f802
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 04544cf
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 193ae9e
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 abcc014
* **deps:** update tools d336565
* **deps:** update tools 0e50999

## 8.0.1 (2025-02-21)

### Documentation

* update example 23f0dc3

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.6 ee534e3
* **deps:** update dependency opentofu to v1.8.8 485e931
* **deps:** update dependency opentofu to v1.9.0 e054b9e
* **deps:** update dependency pre-commit to v4.1.0 e2a05aa
* **deps:** update dependency tflint to v0.55.0 3618220
* **deps:** update dependency trivy to v0.58.1 4d8e35a
* **deps:** update dependency trivy to v0.58.2 be16b5d
* **deps:** update dependency trivy to v0.59.1 d588e4e
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 62b2a44
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 e286da1
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 d698440
* **deps:** update tools f58c76c
* **deps:** update tools a965fcf
* update Github templates f3202ae
* update tflint config for v0.55.0 914a007

## 8.0.0 (2024-11-21)

### ⚠ BREAKING CHANGES

* **AZ-1088:** module v8 structure and updates

### Features

* **AZ-1088:** apply suggestions 368e83c
* **AZ-1088:** module v8 structure and updates 1117d23
* **AZ-1088:** revamping and variable updates b3e7b57

### Bug Fixes

* **AZ-1088:** `transaction_isolation` option not working in mysql 5.7 96e4224

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 7620515
* **deps:** update dependency opentofu to v1.8.3 ee1d3f9
* **deps:** update dependency opentofu to v1.8.4 b7f99e3
* **deps:** update dependency pre-commit to v4 98a7a96
* **deps:** update dependency pre-commit to v4.0.1 571bb75
* **deps:** update dependency tflint to v0.54.0 0e11ca6
* **deps:** update dependency trivy to v0.56.0 43051e2
* **deps:** update dependency trivy to v0.56.1 6b1af1a
* **deps:** update dependency trivy to v0.56.2 18bc066
* **deps:** update dependency trivy to v0.57.1 531bb1c
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 4d4bccb
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 89d5ddc
* **deps:** update tools 6f5148d
* prepare for new examples structure f02e35f
* update examples structure cd10df7

## 7.7.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider abb971c

### Documentation

* update README badge to use OpenTofu registry cad8ad6
* update README with `terraform-docs` v0.19.0 4622418

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.0 0fddaff
* **deps:** update dependency opentofu to v1.8.1 89ce8a0
* **deps:** update dependency opentofu to v1.8.2 2930330
* **deps:** update dependency pre-commit to v3.8.0 269f21f
* **deps:** update dependency terraform-docs to v0.19.0 7230c25
* **deps:** update dependency tflint to v0.53.0 c641f9f
* **deps:** update dependency trivy to v0.54.1 baf45c5
* **deps:** update dependency trivy to v0.55.0 33d69b7
* **deps:** update dependency trivy to v0.55.1 e097718
* **deps:** update dependency trivy to v0.55.2 582bbea
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 9d1a310
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 fcbe9e0
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 3949b97
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 e010cdc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 1ef6052
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 0e6a9af
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 f3f4501
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 e5888dd
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 8b0321c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 a5e1236
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 9008bcc
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 3d585f3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 7702875

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
