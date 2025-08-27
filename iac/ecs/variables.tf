variable "vpc_id" {
  type = string
}

variable "internal_alb_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecr_url" {
  type = string
}

variable "ecs_task_execution_role" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "alb_tg_7005_arn" {
  type = string
}

variable "alb_tg_7013_arn" {
  type = string
}

variable "alb_tg_8080_arn" {
  type = string
}


variable "alb_listener_8080_arn" {
  type = string
}

variable "alb_listener_7013_arn" {
  type = string
}
