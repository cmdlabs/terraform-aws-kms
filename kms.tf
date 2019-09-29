data "aws_caller_identity" "current" {}

resource "aws_kms_alias" "kms" {
  name          = "alias/secrets"
  target_key_id = aws_kms_key.main.key_id
}

# KMS requires that the creator has access to the key so you don't lock yourself out
locals {
  my_role_name = split("/", data.aws_caller_identity.current.arn)[1]
  my_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.my_role_name}"
}

resource "aws_kms_key" "main" {
  description = "KMS Key Deploy Secrets"
  policy      = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {
  statement {
    sid    = "Allow administration of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass",
        local.my_role_arn,
      ]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ADMINS"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass"
      ]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "GRANTOR"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass",
      ]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "kms:GrantOperations"
      values   = ["Decrypt", "Encrypt", "GenerateDataKey*", "DescribeKey"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ENCRYPTOR"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "DECRYPTOR"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.client_name}-role-console-breakglass"
      ]
    }
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowExternalAccountAccess"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKeys",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowExternalAccountsToAttachPersistentResources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
    resources = ["*"]
  }
}
