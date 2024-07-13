# Create SG for RDS Cluster
resource "aws_security_group" "postgres_aurora_sg" {
  name   = "security_rds_cluster"
  vpc_id = aws_vpc.vpc-main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.vpc-main.cidr_block, aws_subnet.private-subnet-1a.cidr_block, aws_subnet.public-subnet-1a.cidr_block
    ]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 stands for all
    cidr_blocks = [var.vpc_cidr_block]  # This implies all IP addresses
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-main.cidr_block,aws_subnet.private-subnet-1a.cidr_block,  aws_subnet.public-subnet-1a.cidr_block]
  }
  tags = {
    name        = "terraform project"
    description = "managed by terraform provisioning"
  }
}
resource "aws_security_group" "redis_sg" {
  name   = "redis_sg"
  vpc_id = aws_vpc.vpc-main.id
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = [aws_vpc.vpc-main.cidr_block,aws_subnet.public-subnet-1a.cidr_block,
      aws_subnet.private-subnet-1a.cidr_block]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 stands for all
    cidr_blocks = [var.vpc_cidr_block]  # This implies all IP addresses
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 stands for all
    cidr_blocks = [var.vpc_cidr_block]  # This implies all IP addresses
  }
  tags = {
    name        = "terraform project"
    description = "managed by terraform provisioning"
  }
}
#Create SG for Application Load Banlancer
resource "aws_security_group" "alb_sg" {
  name   = "application_loadbalancer_sg"
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    name        = "terraform project"
    description = "managed by terraform provisioning"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0",aws_vpc.vpc-main.cidr_block,aws_subnet.public-subnet-1a.cidr_block,
      aws_subnet.private-subnet-1a.cidr_block,]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0",aws_vpc.vpc-main.cidr_block,aws_subnet.public-subnet-1a.cidr_block,
      aws_subnet.private-subnet-1a.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private-subnet-1a.cidr_block, aws_subnet.public-subnet-1a.cidr_block]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 stands for all
    cidr_blocks = [var.vpc_cidr_block]  # This implies all IP addresses
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 stands for all
    cidr_blocks = [var.vpc_cidr_block]  # This implies all IP addresses
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  vpc_id = aws_vpc.vpc-main.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0",var.vpc_cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ecs_service" {
  vpc_id = aws_vpc.vpc-main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0",var.vpc_cidr_block]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
