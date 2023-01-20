include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path  = "../eks"
  mock_outputs = {
    eks_cluster_id = "eks_cluster_id"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}

terraform {
  source = "."
}

include "global_common" {
  path   = "${dirname(find_in_parent_folders())}/global-common/global-eks.hcl"
  expose = true
}

include "common" {
  path   = "${dirname(get_parent_terragrunt_dir())}/../../common/eks-addons.hcl"
  expose = true
}

include "eks_common" {
  path   = "${dirname(get_parent_terragrunt_dir())}/../../common/eks.hcl"
  expose = true
}

inputs = merge(
  { eks_cluster_id = dependency.eks.outputs.eks_cluster_id },
  include.common.locals,
)