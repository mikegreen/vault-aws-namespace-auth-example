# main.tf

resource "aws_organizations_account" "account" {
  provider = aws.pnp-master
  name     = var.new-member-account
  email    = "foo@hashicorp.com"
  tags     = var.common_tags
}

data "aws_caller_identity" "source" {
  provider = aws.pnp-master
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.destination
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root",
      "arn:aws:iam::756612345239:user/ec2-terraform"]
    }
  }
}

data "aws_iam_policy" "ec2" {
  provider = aws.destination
  name     = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "iam" {
  provider = aws.destination
  name     = "IAMFullAccess"
}

data "aws_iam_policy" "iam" {
  provider = aws.destination
  name     = "IAMFullAccess"
}

resource "aws_iam_role" "assume_role" {
  provider             = aws.destination
  name                 = "assume_role"
  max_session_duration = 3600
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns  = [data.aws_iam_policy.ec2.arn, data.aws_iam_policy.iam.arn]
}

# Create AWS member account within master
# create IAM role in member

# configure vault for master in root namespace
# resource "vault_mount" "aws-root" {
#   path                      = "aws"
#   type                      = "aws"
#   default_lease_ttl_seconds = 3600
#   max_lease_ttl_seconds     = 86400
# }

resource "vault_aws_secret_backend" "aws" {
  provider                  = vault.vault-root
  path                      = "aws-pnp-master"
  access_key                = var.root-vault-aws-access-key
  secret_key                = var.root-vault-aws-secret-key
  default_lease_ttl_seconds = 600
  max_lease_ttl_seconds     = 3600
}

resource "vault_aws_secret_backend_role" "deploy" {
  provider        = vault.vault-root
  backend         = vault_aws_secret_backend.aws.path
  name            = "deploy"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    }
  ]
}
EOT
}

resource "vault_aws_secret_backend_role" "assume-member" {
  provider        = vault.vault-root
  backend         = vault_aws_secret_backend.aws.path
  name            = "assume-member"
  credential_type = "assumed_role"
  role_arns       = [aws_iam_role.assume_role.arn]
}


# # create namespace for member
# resource "vault_namespace" "new-namespace" {
#   provider = vault.vault-root
#   path     = var.new-member-account
# }

# resource "vault_aws_secret_backend" "aws-new" {
#   provider = vault.vault-new
#   path     = "aws"
#   # access_key                = var.new-ns-vault-aws-access-key
#   # secret_key                = var.new-ns-vault-aws-secret-key
#   default_lease_ttl_seconds = 600
#   max_lease_ttl_seconds     = 3600
# }

# resource "vault_aws_secret_backend_role" "role" {
#   provider        = vault.vault-new
#   backend         = vault_aws_secret_backend.aws-new.path
#   name            = "deploy"
#   credential_type = "assumed_role"

#   policy_document = <<EOT
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "iam:*",
#       "Resource": "*"
#     }
#   ]
# }
# EOT
# }

# provider "vault" {
#   namespace = 
#   # token   = var.vault_token
# }
