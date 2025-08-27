# LOG_GROUP

resource "aws_cloudwatch_log_group" "log_group_eureka" {
  name              = "/cloud/eureka-svc"
  retention_in_days = 1
}

# ECS_TASK

resource "aws_ecs_task_definition" "ecs_task_eureka" {
  family             = "task-eureka"
  execution_role_arn = var.ecs_task_execution_role
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = 512
  memory             = 1024

  container_definitions = jsonencode([
    {
      name   = "cloud-eureka-svc"
      image  = "${var.ecr_url}:goqual-eureka-latest"
      cpu    = 512
      memory = 1024
      essential = true # If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped
      portMappings = [
        {
          containerPort = 7013
          hostPort      = 7013
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group_eureka.name
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "eureka"
        }
      }

      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "prod"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# ECS_SG

resource "aws_security_group" "ecs_eureka_sg" {
  name   = "sp-ecs-eureka-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 7013
    to_port         = 7013
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

resource "aws_ecs_service" "ecs_service_eureka" {
  name            = "cloud-eureka"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_eureka.arn
  desired_count   = 1
  launch_type     = null
  health_check_grace_period_seconds = 120
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups = [
      var.ecs_security_group_id,
      aws_security_group.ecs_eureka_sg.id
    ]
    assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = var.alb_tg_7013_arn
    container_name   = "cloud-eureka-svc"  # make sure that set same as container name
    container_port   = 7013
  }

  depends_on = [
    var.alb_tg_7013_arn
  ]
}
