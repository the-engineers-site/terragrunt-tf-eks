locals {
  base_source_url = "github.com/aws-ia/terraform-aws-eks-blueprints"
}

terraform {
  source = "${local.base_source_url}?ref=v4.21.0"
}