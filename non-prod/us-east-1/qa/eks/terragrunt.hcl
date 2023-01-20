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

generate "provider" {
  path      = "eks-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster" "eks_cluster_details" {
  name = module.aws_eks.cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = "${include.common.locals.cluster_name}"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster_details.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_details.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = module.aws_eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.aws_eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}

provider "kubectl" {
  host                   = module.aws_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.aws_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  load_config_file       = false
}

EOF
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