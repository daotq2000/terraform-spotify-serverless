# ECS Cluster
resource "aws_ecs_cluster" "farget_cluster" {
  name = "farget-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "spotify-task" {
  family                   = "spotify-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name         = "music-app-container"
      image        = "846338211683.dkr.ecr.us-east-1.amazonaws.com/music-project:latest"
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "SERVER_PORT"
          value = "80"
        },
        {
          name  = "DATABASE_URL"
          value = "jdbc:mysql://${data.aws_rds_cluster.aurora_cluster.endpoint}:3306/spotify_123"
        },
        {
          name  = "DATABASE_USERNAME"
          value = "daotq_1"
        },
        {
          name  = "DATABASE_PASSWORD"
          value = "Boyalone123"
        },
        {
          name  = "REDIS_HOST"
          value = "${data.aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address}"
#           value = "localhost"
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        },
        {
          name  = "CLIENT_ID"
          value = "6379"
        },
        {
          name  = "CLIENT_SECRET"
          value = "6379"
        },
        {
          name  = "CLOUD_NAME"
          value = "6379"
        },
        {
          name  = "AWS_REGION"
          value = "us-east-1"
        },
        {
          name  = "AWS_ACCESS_KEY"
          value = "abc"
        },
        {
          name  = "AWS_ACCESS_KEY"
          value = "xyz"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = "/ecs/log-group"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  depends_on = [
  aws_elasticache_replication_group.redis,

  ]
}
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/log-group"
  retention_in_days = 1
}
# ECS Service
resource "aws_ecs_service" "spotify_service" {
  name            = "spotify-task"
  cluster         = aws_ecs_cluster.farget_cluster.id
  task_definition = aws_ecs_task_definition.spotify-task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public-subnet-1a.id,aws_subnet.private-subnet-1a.id]
    security_groups = [
      aws_security_group.ecs_tasks.id,
      aws_security_group.ecs_service.id
    ]
    assign_public_ip = false
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "music-app-container"
    container_port   = 80
  }
}
data "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id = aws_elasticache_replication_group.redis.id
}
output "redis_primary_endpoint" {
  value = data.aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address
}
data "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = aws_rds_cluster.aurora-mysql-cluster.id
}

output "aurora_primary_endpoint" {
  value = data.aws_rds_cluster.aurora_cluster.endpoint
}