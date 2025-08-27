resource "aws_lb" "external_nlb" {
  name               = "main-external-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "external_nlb_tg_8080" {
  name        = "nlb-to-alb-tg-8080"
  target_type = "alb"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "external_nlb_tg_7013" {
  name        = "nlb-to-alb-tg-7013"
  target_type = "alb"
  port        = 7013
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "external_nlb_listener_8080" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_nlb_tg_8080.arn
  }
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

resource "aws_lb_target_group_attachment" "attach_alb_8080" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_8080.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 8080
}

resource "aws_lb_target_group_attachment" "attach_alb_7013" {
  target_group_arn = aws_lb_target_group.external_nlb_tg_7013.arn
  target_id        = aws_lb.internal_alb.arn
  port             = 7013
}