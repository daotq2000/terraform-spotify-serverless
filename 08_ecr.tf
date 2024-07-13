resource "aws_ecr_repository" "ecr_repository" {
  name = "music-project"
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }
}
# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach ECR read-only policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_ecr" {
  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}