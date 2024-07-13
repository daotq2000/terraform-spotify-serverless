
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}