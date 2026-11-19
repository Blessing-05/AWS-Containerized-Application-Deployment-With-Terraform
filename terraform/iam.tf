#Creating the task-execution-role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "node-app-deployment-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = "sts:AssumeRole"
            Sid = "EcsTaskExecution"
            Principal = {
                Service = "ecs-tasks.amazonaws.com"
            }
        }
    ]
  })
}

#attaching an existing aws policy to the new role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}