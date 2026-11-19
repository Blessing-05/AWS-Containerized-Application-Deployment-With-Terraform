#1 Creating the sg for alb
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id
  name = "alb-sg"
  description = "Allow http traffic to alb"

  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

#2 Creating ECS sg
resource "aws_security_group" "ecs-sg" {
  vpc_id = aws_vpc.main.id
  name = "ecs-sg"
  description = "Allow inbound traffic from alb"

  ingress {
    from_port = 3000 #this is the container port
    to_port = 3000
    protocol = "tcp"
    security_groups = [ aws_security_group.alb_sg.id ]
    description = "allow inbound traffic from alb"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all outbound traffic"
  }
}