locals {
  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

inputs = {
  amazon_eks_coredns_config = {
    most_recent        = true
    kubernetes_version = local.environment_vars.eks.version.eks
    resolve_conflicts  = "OVERWRITE"
  },

  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  enable_metrics_server          = true
  enable_cluster_autoscaler      = true
  cluster_autoscaler_helm_config = {
    set = [
      {
        name  = "podLabels.prometheus\\.io/scrape",
        value = "true",
        type  = "string",
      }
    ]
  }
  enable_cert_manager      = true
  cert_manager_helm_config = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--enable-certificate-owner-ref=false"
      },
    ]
  }
  enable_aws_load_balancer_controller = true
}