resource "aws_ecs_cluster" "main" {
  name = "node-app-deployment-ecs-cluster"

  tags = {
    Name = "node-app-deployment-ecs-cluster"
  }
}


# 2. ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "project-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "node-app-deployment-container"
      image     = "${aws_ecr_repository.main.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.main.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}


#ECS Service
resource "aws_ecs_service" "main" {
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 2
  launch_type = "FARGATE"
  name = "node-app-deployment-ecs-service"

  network_configuration {
    assign_public_ip = false
    security_groups = [ aws_security_group.ecs-sg.id ]
    subnets = [ aws_subnet.priv_sub1.id, aws_subnet.priv_sub2.id ]
  }

  load_balancer {
    container_port = 3000
    container_name = "node-app-deployment-container"
    target_group_arn = aws_lb_target_group.main.arn
  }

  depends_on = [ aws_cloudwatch_log_group.main, aws_lb_listener.main, aws_iam_role_policy_attachment.ecs_task_execution_policy ]
}