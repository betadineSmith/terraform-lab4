# ==================================================================
# OUTPUTS DEL MÓDULO NETWORK (RED)
# ==================================================================
# - Devuelve el ID de la VPC creada.
# - Devuelve las listas de IDs de las subnets públicas y privadas.
# ==================================================================

# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC"
  value       = module.network.vpc_id
}

# Subnets Públicas (IDs)
output "public_subnet_ids" {
  description = "Lista de IDs de Subnets Públicas"
  value       = module.network.public_subnet_ids
}

# Subnets Privadas (IDs)
output "private_subnet_ids" {
  description = "Lista de IDs de Subnets Privadas"
  value       = module.network.private_subnet_ids
}

# ==================================================================
# OUTPUTS DEL MÓDULO SECURITY GROUPS
# ==================================================================
# - Devuelve los IDs de los Security Groups creados 
#   para los diferentes servicios:
#   - RDS PostgreSQL
#   - ElasticCache Redis
#   - ECS (Microservicios)
#   - Application Load Balancer (ALB)
#   - Network Load Balancer (NLB)
#   - EFS (Elastic File System)
# ==================================================================

# ID del Security Group para RDS PostgreSQL
output "rds_sg_id" {
  description = "ID del Security Group para RDS PostgreSQL"
  value       = module.security.rds_sg_id
}

# ID del Security Group para ElasticCache Redis
output "redis_sg_id" {
  description = "ID del Security Group para ElasticCache Redis"
  value       = module.security.redis_sg_id
}

# ID del Security Group para los Microservicios en ECS
output "ecs_sg_id" {
  description = "ID del Security Group para los Microservicios en ECS"
  value       = module.security.ecs_sg_id
}

# ID del Security Group para el ALB (Application Load Balancer)
output "alb_sg_id" {
  description = "ID del Security Group para el Application Load Balancer"
  value       = module.security.alb_sg_id
}

# ID del Security Group para el Network Load Balancer (Interno)
output "nlb_sg_id" {
  description = "ID del Security Group para el Network Load Balancer"
  value       = module.security.nlb_sg_id
}

# ID del Security Group para Elastic File System (EFS)
output "efs_sg_id" {
  description = "ID del Security Group para Elastic File System (EFS)"
  value       = module.security.efs_sg_id
}

# ==================================================================
# OUTPUTS DEL MÓDULO RDS (BASE DE DATOS)
# ==================================================================
# - Devuelve el endpoint de conexión a la base de datos.
# - Devuelve el ARN del secreto almacenado en Secrets Manager.
# ==================================================================

# Endpoint de la base de datos
output "rds_endpoint" {
  description = "Endpoint de la base de datos PostgreSQL"
  value       = module.rds.rds_endpoint
}

# ARN del secreto de la RDS
output "rds_secret_arn" {
  description = "ARN del secreto de la RDS en Secrets Manager"
  value       = module.rds.rds_secret_arn
}

# ==================================================================
# OUTPUTS DEL MÓDULO REDIS (CACHE)
# ==================================================================
# - Devuelve la URL de conexión del cluster Redis.
# - Devuelve el ARN del grupo de replicación.
# ==================================================================

# Endpoint de conexión a Redis (Primary Endpoint)
output "redis_endpoint" {
  description = "Primary Endpoint del cluster Redis"
  value       = module.redis.redis_endpoint
}

# ARN del grupo de replicación Redis
output "redis_arn" {
  description = "ARN del grupo de replicación Redis"
  value       = module.redis.redis_arn
}

# ==================================================================
# OUTPUTS DEL MÓDULO EFS (Elastic File System)
# ==================================================================
# - Se exporta el nombre DNS del sistema de archivos EFS.
# - Este endpoint es utilizado para montar el EFS en instancias EC2,
#   tareas de ECS Fargate o cualquier servicio compatible con NFS.
# ==================================================================

# Endpoint DNS del sistema de archivos (para montaje NFS)
output "efs_dns_name" {
  description = "Nombre DNS para montar el EFS"
  value       = module.efs.efs_dns_name
}

