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

Terraform >= 0.12.7 is required for this module.

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

|Name|Description|
|------------|---------------------|
|key_id|The globally unique identifier for the key|
|key_arn|The Amazon Resource Name (ARN) of the key|
|key_alias_arn|The Amazon Resource Name (ARN) of the key alias|

### Example

A simple example:

```tf
locals {
  client_name = "our_awesome_client"
  role_name   = "${local.client_name}-role-console-breakglass"
}

resource "aws_iam_role" "our_awesome_client" {
  name = local.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

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
