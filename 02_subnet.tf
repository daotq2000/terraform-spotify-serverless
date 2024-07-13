resource "aws_subnet" "public-subnet-1a" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.0.1.0/24" # example CIDR block
  availability_zone = "us-east-1a"  # use the availability zone in your region

  map_public_ip_on_launch = true # for the bastion host to be accessible from the internet
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
resource "aws_subnet" "private-subnet-1a" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.0.2.0/24" # example CIDR block
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a" # use the availability zone in your region
    tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
resource "aws_subnet" "private-subnet-1b" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.0.3.0/24" # example CIDR block
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b" # use a different availability zone
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
#Create subnets group for rds cluster
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1a.id,aws_subnet.private-subnet-1b.id ]
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
# Create subnets group for elastic cache
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1a.id,aws_subnet.private-subnet-1b.id]
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
