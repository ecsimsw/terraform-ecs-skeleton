# ecr

resource "aws_ecr_repository" "ecr-repo" {
  name = "ecsimsw-dev-ecr"
}

# iam

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
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ecs cluster

resource "aws_ecs_cluster" "main_cluster" {
  name = "ecsimsw-dev-ecs"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecsimsw-dev-ecs-sg"
  }
}

# target services

## app1

resource "aws_lb_listener" "alb_listener_app1" {
  load_balancer_arn = var.alb_arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_tg_app1.arn
  }
}

resource "aws_lb_target_group" "aws_lb_tg_app1" {
  name     = "ecsimsw-dev-app1-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/up"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_ecs_task_definition" "ecs_task_app1" {
  family                   = "ecsimsw-dev-app1"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "ecsimsw-dev-app1"
      image     = "ecsimsw-dev:0.0.1"
      cpu       = 1024
      memory    = 2048
      essential = true  # If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration: {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/app1"
          "awslogs-region": "ap-northeast-2"
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "ecs_service_app1" {
  name            = "ecsimsw-plaform-dev-app1"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_app1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_lb_tg_app1.arn
    container_name   = "ecsimsw-plaform-dev-app1"
    container_port   = 8080
  }

  tags = {
    Name = "ecsimsw-dev",
    Team = "Server",
    Service = "ecsimsw-dev-app1",
    CreatedBy = "jinhwanKim",
    CreatedAt = "20240903",
  }

  depends_on = [
    aws_lb_listener.alb_listener_app1
  ]
}