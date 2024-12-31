provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block    = "10.0.0.0/16"
  private_subnet_2a_cidr_block = "10.0.1.0/24"
  public_subnet_2a_cidr_block = "10.0.2.0/24"
  private_subnet_2c_cidr_block = "10.0.3.0/24"
  public_subnet_2c_cidr_block = "10.0.4.0/24"
}

module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "services" {
  source = "./modules/services"
  vpc_id = module.vpc.vpc_id
  alb_arn = module.lb.alb_arn
  alb_sg_id = module.lb.alb_sg_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "events" {
  source = "./modules/events"
}
