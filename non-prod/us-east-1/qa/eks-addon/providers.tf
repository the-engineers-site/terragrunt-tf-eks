data "aws_eks_cluster" "eks_cluster_details" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.eks_cluster_id
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster_details.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_details.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster_details.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_details.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}