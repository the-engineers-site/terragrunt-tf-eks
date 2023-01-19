locals {
  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env              = local.environment_vars.environment_name
  cluster_name     = "${local.env}-${local.environment_vars.eks.cluster_name_suffix}"

}


inputs = {
  cluster_name              = "${local.cluster_name}"
  cluster_version           = "${local.environment_vars.eks.version.eks}"
  cluster_enabled_log_types = ["api"]
  cluster_service_ipv4_cidr = "${local.environment_vars.eks.eks_service_cidr}"
  platform_teams = {
    admin = {
      users = [local.account_vars.locals.eks_admin_arn]
    }
  }
  map_roles = [
    {
      rolearn  = local.account_vars.locals.eks_admin_arn
      username = local.account_vars.locals.eks_admin_role_name
      groups   = ["system:masters"]
    },
  ]
  tags = local.environment_vars.tags
}