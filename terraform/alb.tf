#1 Creating the load Balancer
resource "aws_lb" "main" {
  name = "node-app-deployment-alb"
  internal = false
  subnets = [ aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id ]
  security_groups = [ aws_security_group.alb_sg.id ]
  load_balancer_type = "application"

  tags = {
    Name = "node-deployment-alb"
  }
}

#2 Creating the target group
resource "aws_lb_target_group" "main" {
  vpc_id = aws_vpc.main.id
  port = 3000
  target_type = "ip"
  protocol = "HTTP"

  health_check {
    enabled = true
    unhealthy_threshold = 3
    healthy_threshold = 3
    matcher = "200"
    path = "/health"
    interval = 60 # check every 60s
  }
}

#3 Creating lb listener
resource "aws_lb_listener" "main" {
  protocol = "HTTP"
  port = 80
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}