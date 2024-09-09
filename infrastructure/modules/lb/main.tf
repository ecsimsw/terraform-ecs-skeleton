# security group

resource "aws_security_group" "alb_sg" {
  name        = "ecsimsw-dev-alb-sg"
  description = "ecsimsw-dev"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecsimsw-dev-alb-sg"
  }
}

# alb

resource "aws_lb" "alb" {
  name               = "ecsimsw-dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "ecsimsw-dev",
    Team = "Server",
    Service = "ecsimsw-starter",
    CreatedBy = "jinhwanKim",
    CreatedAt = "20240903",
  }
}