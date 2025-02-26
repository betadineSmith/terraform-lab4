# ========================================================================
# Terraform - AWS Lab 4: Infraestructura en AWS
# ========================================================================
# Este archivo `main.tf` es el punto de entrada principal para la 
# infraestructura de AWS en este proyecto. Define la configuración clear
# del proveedor, el backend para almacenar el estado y los módulos 
# de Terraform que gestionan todos los recursos.
#
# Componentes incluidos:
# - Configuración del backend en S3 y bloqueo con DynamoDB.
# - Creación de la infraestructura de red (VPC, Subnets, NAT, IGW).
# - Definición de Security Groups para los diferentes servicios.
# - Implementación de una base de datos RDS PostgreSQL con backups 
#   y credenciales gestionadas por AWS Secrets Manager.
# - Uso de `outputs` para exponer los recursos clave.
#
# Este archivo se encarga de orquestar todos los módulos, asegurando 
# que los recursos sean desplegados en la región `eu-west-3` de AWS.
# =========================================================================


# ==================================================================
# CONFIGURACIÓN DEL PROVEEDOR Y BACKEND
# ==================================================================

# Configura AWS como proveedor de Terraform
provider "aws" {
  region = "eu-west-3" # Región de París
}

# Configura el backend en S3 para almacenar el estado de Terraform
terraform {
  backend "s3" {
    bucket         = "lab4-terraform-state-backend"
    key            = "lab4/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "lab4-terraform-state"
  }
}

# ==================================================================
# CARGA DE VARIABLES GLOBALES
# ==================================================================

variable "ami" {
  description = "AMI preexistente en la región de París (eu-west-3)"
  type        = string
  default     = "ami-0091da954fd26a2bc" # lab4-AMI-Drupal-inicial
}


# Carga las etiquetas desde el archivo tags.json
locals {
  tags = { for tag in jsondecode(file("${path.root}/tags.json")) : tag.Key => tag.Value }
}

# ==================================================================
# MÓDULO DE RED - CREACIÓN DE LA INFRAESTRUCTURA DE RED
# ==================================================================

# ==============
# VPC
# ==============
module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones

  tags = local.tags
}
# ==============
# VPC Backup
# ==============
module "network_backup" {
  source = "./modules/network_backup"

  vpc_cidr           = var.vpc_cidr_backup
  public_subnets     = var.public_subnets_backup
  private_subnets    = var.private_subnets_backup
  availability_zones = var.availability_zones

  tags = local.tags
}

# ======================
# VPC Peerig Conection
# ======================
module "vpc_peering" {
  source = "./modules/vpc_peering"

  vpc_id               = module.network.vpc_id
  peer_vpc_id          = module.network_backup.vpc_id
  vpc_cidr             = var.vpc_cidr
  peer_vpc_cidr        = var.vpc_cidr_backup
  route_table_ids_main = module.network.private_route_table_ids
  route_table_ids_peer = module.network_backup.private_route_table_ids

  tags = local.tags
}

# ==================================================================
# MÓDULO DE SECURITY GROUPS - REGLAS DE SEGURIDAD
# ==================================================================

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id

  tags = local.tags
}

# ==================================================================
# MÓDULO DE BASE DE DATOS RDS - POSTGRESQL
# ==================================================================

module "rds" {
  source = "./modules/rds"

  db_engine            = var.db_engine
  db_instance_class    = var.db_instance_class
  db_storage           = var.db_storage
  db_backup_retention  = var.db_backup_retention
  db_identifier        = var.db_identifier
  db_subnet_group_name = var.db_subnet_group_name
  db_public_access     = var.db_public_access
  db_security_group_id = module.security.rds_sg_id
  db_multi_az          = var.db_multi_az
  private_subnet_ids   = module.network.private_subnet_ids
  db_username          = var.db_username

  tags = local.tags
}

# ==================================================================
# MÓDULO PARA ELASTICACHE REDIS
# ==================================================================

module "redis" {
  source = "./modules/redis"

  redis_cluster_id         = var.redis_cluster_id
  redis_subnet_group_name  = var.redis_subnet_group_name
  redis_instance_type      = var.redis_instance_type
  redis_node_groups        = var.redis_node_groups
  redis_replicas_per_group = var.redis_replicas_per_group
  redis_security_group_id  = module.security.redis_sg_id
  private_subnet_ids       = module.network.private_subnet_ids
  redis_failover_enabled   = var.redis_failover_enabled

  tags = local.tags
}

# ==================================================================
# MÓDULO PARA CREAR EFS (Elastic File System)
# ==================================================================

module "efs" {
  source = "./modules/efs"

  efs_name             = var.efs_name
  efs_performance_mode = var.efs_performance_mode
  efs_throughput_mode  = var.efs_throughput_mode
  efs_encrypted        = var.efs_encrypted

  efs_security_group_id = module.security.efs_sg_id
  efs_subnet_ids        = module.network.private_subnet_ids

  tags = local.tags
}

# ============================================================================
# MÓDULO S3 + CLOUDFRONT
# ============================================================================
# - Se crea un bucket S3 privado para almacenar imágenes.
# - Se configura una distribución CloudFront para servirlas con mejor rendimiento.
# - Se aplica Origin Access Control (OAC) para restringir el acceso.
# ============================================================================

module "s3_cloudfront" {
  source = "./modules/s3_cloudfront"

  # Parámetros del bucket S3
  s3_bucket_name       = var.s3_bucket_name
  enable_s3_versioning = var.enable_s3_versioning
  enable_s3_encryption = var.enable_s3_encryption
  force_destroy_s3     = var.force_destroy_s3

  # Parámetros de CloudFront
  cloudfront_price_class     = var.cloudfront_price_class
  cloudfront_allowed_methods = var.cloudfront_allowed_methods

  # Tags globales
  tags = local.tags
}

# ==================================================================
# MÓDULO PARA CREAR Rourte53 - zona privada
# ==================================================================

module "route53" {
  source = "./modules/route53"

  private_zone_name      = "lab4.local" # Dominio interno
  vpc_id                 = module.network.vpc_id
  rds_endpoint           = module.rds.rds_endpoint
  redis_primary_endpoint = module.redis.redis_primary_endpoint
  redis_reader_endpoint  = module.redis.redis_reader_endpoint
  efs_dns_name           = module.efs.efs_dns_name
  s3_dns_name            = module.s3_cloudfront.s3_bucket_url

  tags = local.tags
}


# =======================================================
# MÓDULO LOAD BALANCER ALB Application Load Balancer
# =======================================================
module "alb_external" {
  source = "./modules/load_balancers"

  load_balancer_name           = "lab4-alb-external"
  load_balancer_subnets        = var.lb_visibility == "public" ? module.network.public_subnet_ids : module.network.private_subnet_ids
  load_balancer_security_group = module.security.alb_sg_id
  lb_visibility                = "public"
  lb_type                      = "application"
  enable_https                 = true

  tags = local.tags
}

# ==================================================================
# MÓDULO PARA CREAR Rourte53 - zona publica
# ==================================================================

module "route53_public" {
  source              = "./modules/route53_public"
  domain_name         = "jmbmcloud.com"
  alb_dns_name        = module.alb_external.load_balancer_dns_name
  alb_zone_id         = module.alb_external.load_balancer_zone_id
  cloudfront_dns_name = module.s3_cloudfront.cloudfront_url

  tags = local.tags
}

# ==================================================================
# MÓDULO PARA CREAR Cluster Fargate
# ==================================================================

module "ecs_fargate" {
  source = "./modules/ecs_fargate"

  ecs_cluster_name               = "lab4-ECS-Fargate"
  ecs_execution_role_arn         = module.iam_roles.ecs_execution_role_arn
  ecs_task_role_arn              = module.iam_roles.ecs_task_role_arn
  ecs_subnets                    = module.network.private_subnet_ids
  service_discovery_namespace_id = module.service_discovery.namespace_id

  services = {
    "memcached" = {
      cpu               = 256
      memory            = 512
      image             = "memcached:latest"
      min_tasks         = 2
      security_group_id = module.security.ecs_mem_sg_id
    } /*,
    "app_backend" = {
      cpu               = 512
      memory            = 1024
      image             = "my-app-backend:latest"
      min_tasks         = 2
      security_group_id = module.security.ecs_sg_id
    }*/
  }
}

module "iam_roles" {
  source = "./modules/iam_roles"
  tags   = local.tags
}

module "service_discovery" {
  source    = "./modules/service_discovery"
  namespace = "fargate.local"
  vpc_id    = module.network.vpc_id
  tags      = local.tags
}


module "asg" {
  source = "./modules/asg"

  asg_name           = "lab4-asg"
  ami_id             = var.ami
  instance_type      = "t3.medium"
  min_size           = 2
  desired_capacity   = 2
  max_size           = 4
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.security.ec2_sg_id]
  alb_listener_arn   = module.alb_external.https_listener_arn

  tags = local.tags
}

module "secrets" {
  source = "./modules/secrets"
  tags = local.tags
}

