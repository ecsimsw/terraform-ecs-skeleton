output "internal_alb_arn" {
  value = aws_lb.internal_alb.arn
}

output "internal_alb_sg_id" {
  value = aws_security_group.internal_alb_sg.id
}

output "internal_alb_tg_7002_arn" {
  value = aws_lb_target_group.alb_tg_7002.arn
}

output "internal_alb_tg_7004_arn" {
  value = aws_lb_target_group.alb_tg_7004.arn
}

output "internal_alb_tg_7005_arn" {
  value = aws_lb_target_group.alb_tg_7005.arn
}

output "internal_alb_tg_7006_arn" {
  value = aws_lb_target_group.alb_tg_7006.arn
}

output "internal_alb_tg_7012_arn" {
  value = aws_lb_target_group.alb_tg_7012.arn
}

output "internal_alb_tg_7013_arn" {
  value = aws_lb_target_group.alb_tg_7013.arn
}

output "internal_alb_tg_7040_arn" {
  value = aws_lb_target_group.alb_tg_7040.arn
}

output "internal_alb_tg_8006_arn" {
  value = aws_lb_target_group.alb_tg_8006.arn
}