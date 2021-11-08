
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "common_tags" {
  description = "Tags to apply to all AWS resources"
  type        = map(string)
  default     = { "owner" = "mike-green", "managed_by" = "terraform", "deleteable" = "yes" }
}

variable "new-member-account" {
  type    = string
  default = "pnp-test-1"
}

# variable "pnp_main_vpc_id" {
#   type = string
# }

variable "root-vault-aws-access-key" {
  type    = string
  default = ""
}

variable "root-vault-aws-secret-key" {
  type    = string
  default = ""
}

variable "new-ns-vault-aws-access-key" {
  type    = string
  default = ""
}

variable "new-ns-vault-aws-secret-key" {
  type    = string
  default = ""
}
