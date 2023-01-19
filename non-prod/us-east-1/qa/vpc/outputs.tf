resource "aws_ssm_parameter" "vpc-id" {
  name       = "/${var.environment_name}/network/vpc_id"
  type       = "String"
  value      = module.vpc.vpc_id
  depends_on = [module.vpc]
  tags       = var.tags
}

resource "aws_ssm_parameter" "private-subnets" {
  name       = "/${var.environment_name}/network/private_subnets"
  type       = "StringList"
  value      = join(",", module.vpc.private_subnets)
  depends_on = [module.vpc]
  tags       = var.tags
}

resource "aws_ssm_parameter" "public-subnets" {
  name       = "/${var.environment_name}/network/public_subnets"
  type       = "StringList"
  value      = join(",", module.vpc.public_subnets)
  depends_on = [module.vpc]
  tags       = var.tags
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
