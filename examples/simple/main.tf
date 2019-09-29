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
  source      = "../../"
  client_name = "our_awesome_client"
}
