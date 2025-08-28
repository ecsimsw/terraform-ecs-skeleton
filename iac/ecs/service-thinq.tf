locals {
  thinq_service_name = "goqual-thinq"
  thinq_service_version = "2.0.6"
  thinq_application_profile = "prod,remote-db,fusion, remote-redis"
  thinq_container_port = 7040
  thinq_lb_target_arn = var.alb_tg_7040_arn
}

# ECS_TASK

resource "aws_ecs_task_definition" "ecs_task_thinq" {
  family             = "task-${local.thinq_service_name}"
  execution_role_arn = var.ecs_task_execution_role
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = 512
  memory             = 1024

  container_definitions = jsonencode([
    {
      name   = local.thinq_service_name
      image  = "${var.ecr_url}:${local.thinq_service_name}-${local.thinq_service_version}"
      cpu    = 512
      memory = 1024
      essential = true # If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped
      portMappings = [
        {
          containerPort = local.thinq_container_port
          hostPort      = local.thinq_container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group_thinq.name
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "${local.thinq_service_name}-${local.thinq_service_version}"
        }
      }

      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "${local.thinq_application_profile}-${local.thinq_service_version}"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# LOG_GROUP

resource "aws_cloudwatch_log_group" "log_group_thinq" {
  name              = "/cloud/${local.thinq_service_name}"
  retention_in_days = 1
}

# ECS_SG

resource "aws_security_group" "ecs_thinq_sg" {
  name   = "sp-ecs-${local.thinq_service_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = local.thinq_container_port
    to_port         = local.thinq_container_port
    protocol        = "tcp"
    security_groups = [var.internal_alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS_SERVICE

resource "aws_ecs_service" "ecs_service_thinq" {
  name            = local.thinq_service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_thinq.arn
  desired_count   = 1
  launch_type     = null
  health_check_grace_period_seconds = 120
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups = [
      var.ecs_security_group_id,
      aws_security_group.ecs_thinq_sg.id
    ]
    assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = local.thinq_lb_target_arn
    container_name   = local.thinq_service_name
    container_port   = local.thinq_container_port
  }

  depends_on = [
    local.thinq_lb_target_arn
  ]
}
