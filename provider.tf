# provider.tf

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  alias   = "pnp-master"
  profile = "pilotsnpaws"
  region  = "us-east-2"
}

provider "aws" {
  alias   = "destination"
  profile = "pnp-test-1"
  region  = "us-east-2"
}

provider "vault" {
  alias = "vault-root"
  # address = var.vault_addr
  # token   = var.vault_token
}

provider "vault" {
  alias     = "vault-new"
  namespace = var.new-member-account
  # address = var.vault_addr
  # token   = var.vault_token
}
