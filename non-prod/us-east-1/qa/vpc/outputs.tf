resource "aws_ssm_parameter" "vpc-id" {
  name       = "/${var.environment_name}/network/vpc_id"
  type       = "String"
  value      = module.vpc.vpc_id
  depends_on = [module.vpc]
  tags       = var.tags
}
