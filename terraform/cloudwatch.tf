resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/node-app-deployment-log-group"
  retention_in_days = 7

  tags = {
    Name = "node-app-deployment-log-group"
  }
}