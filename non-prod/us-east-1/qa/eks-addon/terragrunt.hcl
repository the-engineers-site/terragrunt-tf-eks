include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "${include.global_common.locals.base_source_url}//modules/kubernetes-addons?ref=v4.21.0"
}


include "global_common" {
  path   = "${dirname(find_in_parent_folders())}/global-common/global-eks.hcl"
  expose = true
}

include "common" {
  path   = "${dirname(get_parent_terragrunt_dir())}/../../common/eks-addons.hcl"
  expose = true
}

inputs = merge(
  {eks_cluster_id = dependency.eks.outputs.eks_cluster_id},
  include.common.locals,
)