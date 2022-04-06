generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "ismael-hubuc"
    key            = "hubuc.tfstate"
    region         = "${local.aws_region}"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

locals {
  secrets = yamldecode(sops_decrypt_file("secrets.yml"))
  aws_region = "us-east-1"
}

inputs = merge(
    local.secrets,
)