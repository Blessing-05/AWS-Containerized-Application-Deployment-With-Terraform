output "s3_bucket" {
  value = aws_s3_bucket.main.id
  description = "s3 bucket"
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
  description = "alb_dns_url"
}

output "alb_dns_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "ecr_repository_url" {
  description = "URL of the Amazon ECR repository for pushing Docker images"
  value       = aws_ecr_repository.main.repository_url
}
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS Fargate service"
  value       = aws_ecs_service.main.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group name for ECS container logs"
  value       = aws_cloudwatch_log_group.main.name
}