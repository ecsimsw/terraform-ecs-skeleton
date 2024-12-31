# ECR

resource "aws_ecr_repository" "ecr_base" {
  name = "base-service"
}

# IAM

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS_CLUSTER

resource "aws_ecs_cluster" "ecs_cluster_base" {
  name = "base-cluster"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# TARGET_SERVICE

resource "aws_lb_target_group" "aws_lb_tg_base" {
  name        = "ecsimsw-base-${substr(uuid(), 0, 5)}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/up"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lb_listener" "alb_listener_base" {
  load_balancer_arn = var.alb_arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_tg_base.arn
  }

  depends_on = [
    aws_lb_listener.alb_listener_base
  ]
}

# CLOUD_WATCH

resource "aws_cloudwatch_log_group" "log_group_base" {
  name              = "/base"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "log_stream_base" {
  name           = "log-stream-base"
  log_group_name = aws_cloudwatch_log_group.log_group_base.name
}

# ECS_TASK

resource "aws_ecs_task_definition" "ecs_task_base" {
  family             = "task-base"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = 256
  memory             = 512

  container_definitions = jsonencode([
    {
      name   = "base-svc"
      image  = "${aws_ecr_repository.ecr_base.repository_url}:0.0.1"
      cpu    = 256
      memory = 512
      essential = true # If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group_base.name
          "awslogs-stream-prefix" = "base"
          "awslogs-region"        = "ap-northeast-2"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# ECS_SERVICE

resource "aws_ecs_service" "ecs_service_base" {
  name            = "service-base"
  cluster         = aws_ecs_cluster.ecs_cluster_base.id
  task_definition = aws_ecs_task_definition.ecs_task_base.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 120
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_lb_tg_base.arn
    container_name   = "base-svc"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.alb_listener_base
  ]
}

# AUTO_SCALE

resource "aws_appautoscaling_target" "ecs_scaling_target_base" {
  max_capacity       = 3
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster_base.name}/${aws_ecs_service.ecs_service_base.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_out_policy_base" {
  name              = "scale-out-policy-base-${substr(uuid(), 0, 5)}"
  policy_type       = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 60.0
    scale_out_cooldown = 120
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster_base.name}/${aws_ecs_service.ecs_service_base.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on = [
    aws_appautoscaling_target.ecs_scaling_target_base
  ]
}

resource "aws_appautoscaling_policy" "scale_in_policy_base" {
  name              = "scale-out-policy-base-${substr(uuid(), 0, 5)}"
  policy_type       = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 10.0
    scale_in_cooldown  = 120
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster_base.name}/${aws_ecs_service.ecs_service_base.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on = [
    aws_appautoscaling_target.ecs_scaling_target_base
  ]
}
