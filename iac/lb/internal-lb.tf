resource "aws_security_group" "internal_alb_sg" {
  name        = "main-internal-alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 7002
    to_port     = 7002
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

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
    from_port   = 7006
    to_port     = 7006
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  ingress {
    from_port   = 7012
    to_port     = 7012
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
    from_port   = 7040
    to_port     = 7040
    protocol    = "tcp"
    cidr_blocks = var.internal_lb_cidr_block
  }

  ingress {
    from_port   = 8006
    to_port     = 8006
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

## 7002

resource "aws_lb_target_group" "alb_tg_7002" {
  name        = "cloud-7002-${substr(uuid(), 0, 3)}"
  port        = 7002
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/genie/actuator"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7002" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7002
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7002.arn
  }
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
    interval            = 10
    timeout             = 5
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
    interval            = 10
    timeout             = 5
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

## 7006

resource "aws_lb_target_group" "alb_tg_7006" {
  name        = "cloud-7006-${substr(uuid(), 0, 3)}"
  port        = 7006
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/openapi/actuator/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7006" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7006
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7006.arn
  }
}

## 7012

resource "aws_lb_target_group" "alb_tg_7012" {
  name        = "cloud-7012-${substr(uuid(), 0, 3)}"
  port        = 7012
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/smartthings/actuator/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7012" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7012
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7012.arn
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
    interval            = 10
    timeout             = 5
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

## 7040

resource "aws_lb_target_group" "alb_tg_7040" {
  name        = "cloud-7040-${substr(uuid(), 0, 3)}"
  port        = 7040
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/thinq/actuator/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_7040" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 7040
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_7040.arn
  }
}

## 8006

resource "aws_lb_target_group" "alb_tg_8006" {
  name        = "cloud-8006-${substr(uuid(), 0, 3)}"
  port        = 8006
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    path                = "/openapi/actuator"
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "internal_alb_listener_8006" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 8006
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_8006.arn
  }
}
