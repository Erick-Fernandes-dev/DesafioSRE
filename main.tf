terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile

}

# 1. Rede
module "vpc" {
  source               = "./modules/vpc"
  desafio_sre          = var.desafio_sre"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

}

# # 2. Segurança
module "security" {
  source   = "./modules/security"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

# # 3. Banco de Dados
module "rds" {
  source          = "./modules/rds"
  desafio_sre     = var.desafio_sre
  db_password     = var.db_password
  private_subnets = module.vpc.private_subnets
  sg_rds          = module.security.sg_rds_id
}

# # 4. Cache
module "elasticache" {
  source          = "./modules/elasticache"
  desafio_sre     = var.desafio_sre
  private_subnets = module.vpc.private_subnets
  sg_elasticache  = module.security.sg_elasticache_id
}

# # 5. Armazenamento Compartilhado
module "efs" {
  source          = "./modules/efs"
  desafio_sre     = var.desafio_sre
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  sg_efs          = module.security.sg_efs_id
}

# # 6. Load Balancer
module "alb" {
  source         = "./modules/alb"
  desafio_sre    = var.desafio_sre
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  sg_alb         = module.security.sg_alb_id
}

# # 7. Aplicação WordPress (Auto Scaling)
module "wordpress_asg" {
  source           = "./modules/wordpress_asg"
  desafio_sre      = var.desafio_sre
  ec2_key_name     = var.ec2_key_name
  private_subnets  = module.vpc.private_subnets
  sg_wordpress_ec2 = module.security.sg_wordpress_id
  target_group_arn = module.alb.target_group_arn
}

# # 8. Servidor VPN (Zona B)
module "pritunl" {
  source        = "./modules/pritunl"
  desafio_sre   = var.desafio_sre
  ec2_key_name  = var.ec2_key_name
  public_subnet = module.vpc.public_subnets[1]
  sg_pritunl    = module.security.sg_pritunl_id
}

# # 9. Servidor Docker Privado (Zona B)
module "private_docker" {
  source            = "./modules/private_docker"
  desafio_sre       = var.desafio_sre
  ec2_key_name      = var.ec2_key_name
  private_subnet    = module.vpc.private_subnets[1]
  sg_private_docker = module.security.sg_private_docker_id
}