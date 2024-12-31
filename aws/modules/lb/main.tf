# SG

resource "aws_security_group" "alb_sg_base" {
  name        = "alb-sg-base"
  vpc_id      = var.vpc_id

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
}

# ALB

resource "aws_lb" "alb_base" {
  name               = "alb-base"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg_base.id]
  subnets            = var.public_subnet_ids
}
