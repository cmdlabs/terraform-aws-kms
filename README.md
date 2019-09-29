<!-- vim: set ft=markdown: -->
![CMD Solutions|medium](https://s3-ap-southeast-2.amazonaws.com/cmd-website-images/CMDlogo.jpg)

# terraform-aws-kms

#### Table of contents

1. [Overview](#overview)
2. [AWS KMS Terraform](#aws-kms-terraform)
    * [Resources docs](#resources-docs)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
    * [Example](#example)
3. [License](#license)

## Overview

This module deploys a standard account KMS key for secrets encryption.

Terraform >= 0.12.0 is required for this module.

## AWS KMS Terraform

### Resources docs

AWS KMS automation includes use of the following core Terraform data sources:

- [`aws_kms_alias`](https://www.terraform.io/docs/providers/aws/r/kms_alias.html) - Provides an alias for a KMS customer master key. AWS Console enforces 1-to-1 mapping between aliases & keys, but API (hence Terraform too) allows you to create as many aliases as the [account limits](http://docs.aws.amazon.com/kms/latest/developerguide/limits.html) allow you.
- [`aws_kms_key`](https://www.terraform.io/docs/providers/aws/r/kms_key.html) - Provides a KMS customer master key.

### Inputs

The below outlines the current parameters and defaults.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
|client_name|Name of the organisation, used in generating IAM role names|string|""|Yes|

### Outputs

None.

### Example

A simple example:

```tf
module "source" {
  source      = "git@github.com:cmdlabs/terraform-aws-kms.git"
  client_name = "our_awesome_client"
}
```

To apply that:

```text
▶ terraform apply
```

## License

Apache 2.0.
