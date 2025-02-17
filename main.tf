# ========================================================================
# Terraform - AWS Lab 4: Infraestructura en AWS
# ========================================================================
# Este archivo `main.tf` es el punto de entrada principal para la 
# infraestructura de AWS en este proyecto. Define la configuración 
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

# Carga las etiquetas desde el archivo tags.json
locals {
  tags = { for tag in jsondecode(file("${path.root}/tags.json")) : tag.Key => tag.Value }
}

# ==================================================================
# MÓDULO DE RED - CREACIÓN DE LA INFRAESTRUCTURA DE RED
# ==================================================================

module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = local.tags
}

# ==================================================================
# MÓDULO DE SECURITY GROUPS - REGLAS DE SEGURIDAD
# ==================================================================

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
  tags   = local.tags
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
