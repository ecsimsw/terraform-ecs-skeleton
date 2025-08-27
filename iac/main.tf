terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  backend "s3" {
    bucket         = "cloud-1364-terraform-state"
    key            = "cloud/aws/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./vpc"
}

module "ecr" {
  source = "./ecr"
}

module "ecs" {
  source                  = "./ecs"
  internal_alb_sg_id      = module.lb.internal_alb_sg_id
  vpc_id                  = module.vpc.vpc_id
  alb_tg_7004_arn         = module.lb.internal_alb_tg_7004_arn
  alb_tg_7005_arn         = module.lb.internal_alb_tg_7005_arn
  alb_tg_7013_arn         = module.lb.internal_alb_tg_7013_arn
  private_subnet_ids      = module.vpc.private_subnet_ids
  cluster_id              = module.ecs.cluster_id
  ecr_url                 = module.ecr.ecr_url
  ecs_security_group_id   = module.ecs.ecs_security_group_id
  ecs_task_execution_role = module.ecs.ecs_task_execution_role
}

module "lb" {
  source             = "./lb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  internal_lb_cidr_block = ["0.0.0.0/0"]
}

module "ec2" {
  source             = "./ec2"
  vpc_id             = module.vpc.vpc_id
  subnet             = module.vpc.public_subnet_ids[0]
}