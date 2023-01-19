include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "${include.global_common.locals.base_source_url}?ref=v4.21.0"
}


include "global_common" {
  path   = "${dirname(find_in_parent_folders())}/global-common/global-eks.hcl"
  expose = true
}

include "common" {
  path   = "${dirname(get_parent_terragrunt_dir())}/../../common/eks.hcl"
  expose = true
}

inputs = merge(
  { vpc_id = dependency.vpc.outputs.vpc_id },
  { private_subnet_ids = dependency.vpc.outputs.private_subnets },
  include.common.locals,
)