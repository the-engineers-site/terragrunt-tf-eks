include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path  = "../vpc"
  mock_outputs = {
    vpc_id          = "temporary-dummy-id"
    private_subnets = ["private-subnets"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
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
  {
    managed_node_groups = {
      default = {
        node_group_name = "default-ng"
        instance_types  = ["t2.small"]
        min_size        = 1
        desired_size    = 2
        max_size        = 10
        subnet_ids      = dependency.vpc.outputs.private_subnets
      }
    }
  },
  include.common.locals,
)