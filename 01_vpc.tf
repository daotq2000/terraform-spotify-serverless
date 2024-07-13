resource "aws_vpc" "vpc-main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}