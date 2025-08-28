resource "aws_lb" "external_nlb" {
  name               = "main-external-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
}

## 7002

resource "aws_lb_target_group" "external_nlb_tg_7002" {
  name        = "nlb-to-alb-tg-7002"
  target_type = "alb"
  port        = 7002
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7002" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7002
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7002.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7002" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7002.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7002
}

## 7004

resource "aws_lb_target_group" "external_nlb_tg_7004" {
  name        = "nlb-to-alb-tg-7004"
  target_type = "alb"
  port        = 7004
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7004" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7004
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7004.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7004" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7004.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7004
}

## 7005

resource "aws_lb_target_group" "external_nlb_tg_7005" {
  name        = "nlb-to-alb-tg-7005"
  target_type = "alb"
  port        = 7005
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7005" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7005
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7005.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7005" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7005.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7005
}

## 7006

resource "aws_lb_target_group" "external_nlb_tg_7006" {
  name        = "nlb-to-alb-tg-7006"
  target_type = "alb"
  port        = 7006
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7006" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7006
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7006.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7006" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7006.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7006
}

## 7012

resource "aws_lb_target_group" "external_nlb_tg_7012" {
  name        = "nlb-to-alb-tg-7012"
  target_type = "alb"
  port        = 7012
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7012" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7012
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7012.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7012" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7012.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7012
}

## 7013

resource "aws_lb_target_group" "external_nlb_tg_7013" {
  name        = "nlb-to-alb-tg-7013"
  target_type = "alb"
  port        = 7013
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7013" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7013
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7013.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7013" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7013.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7013
}

## 7040

resource "aws_lb_target_group" "external_nlb_tg_7040" {
  name        = "nlb-to-alb-tg-7040"
  target_type = "alb"
  port        = 7040
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_7040" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 7040
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_7040.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_alb_7040" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7040.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7040
}
