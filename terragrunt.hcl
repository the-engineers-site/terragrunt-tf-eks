locals {
  dabahn_prefix = "dabahn"
  account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name  = local.account_vars.locals.account_name
  account_id    = local.account_vars.locals.aws_account_id
  env_type      = local.account_vars.locals.env_type

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region

  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
  environment_name = local.environment_vars.environment_name
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = "${local.dabahn_prefix}-state-${local.env_type}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.environment_name}-terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars,
)
