resource "aws_rds_cluster" "aurora-mysql-cluster" {
  cluster_identifier = "aurora-postgresql-cluster"
  engine             = "aurora-mysql"
  engine_mode        = "provisioned"
  engine_version     = "8.0.mysql_aurora.3.03.0"
  database_name      = "spotify_123"
  master_username    = "daotq_1"
  master_password    = "Boyalone123"
  vpc_security_group_ids = [aws_security_group.postgres_aurora_sg.id] # Replace with your security group IDs
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  storage_encrypted  = true
  skip_final_snapshot = true
  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "aurora-postgresql-cluster" {
  identifier = "aurora-mysql-serverless"
  cluster_identifier = aws_rds_cluster.aurora-mysql-cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora-mysql-cluster.engine
  engine_version     = aws_rds_cluster.aurora-mysql-cluster.engine_version
  availability_zone = "us-east-1a"
}

