resource "aws_security_group" "internal_alb_sg" {
  name        = "main-internal-alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 7004
    to_port     = 7004
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  ingress {
    from_port   = 7005
    to_port     = 7005
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  ingress {
    from_port   = 7013
    to_port     = 7013
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "internal_alb" {
  name               = "main-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb_sg.id]
  subnets            = var.private_subnet_ids
  idle_timeout       = 3600
}

## 7004

resource "aws_lb_target_group" "alb_tg_7004" {
  name        = "cloud-7004-${substr(uuid(), 0, 3)}"
  port        = 7004
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/kakao/actuator/health"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7004" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7004
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7004.arn
  }
}

## 7005

resource "aws_lb_target_group" "alb_tg_7005" {
  name        = "cloud-7005-${substr(uuid(), 0, 3)}"
  port        = 7005
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/clova/actuator/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7005" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7005
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7005.arn
  }
}

## 7013

resource "aws_lb_target_group" "alb_tg_7013" {
  name        = "cloud-7013-${substr(uuid(), 0, 3)}"
  port        = 7013
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/actuator/health"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7013" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7013
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7013.arn
  }
}
