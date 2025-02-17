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

# Endpoint de conexión a Redis (Primary - Read/Write)
output "redis_primary_endpoint" {
  description = "Primary Endpoint del cluster Redis (Read/Write)"
  value       = module.redis.redis_primary_endpoint
}

# Endpoint de conexión a Redis (Reader - Solo Lectura)
output "redis_reader_endpoint" {
  description = "Reader Endpoint del cluster Redis (Read Only)"
  value       = module.redis.redis_reader_endpoint
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

# ==================================================================
# OUTPUTS DEL MÓDULO ROUTE 53 (ZONA PRIVADA Y REGISTROS DNS)
# ==================================================================
# - Devuelve el ID de la zona privada creada en Route 53.
# - Devuelve los nombres DNS simplificados para:
#     - RDS PostgreSQL (sin puerto)
#     - ElasticCache Redis (Primary y Read Replica)
#     - Elastic File System (EFS)
# ==================================================================

# ID de la zona privada en Route 53
output "route53_zone_id" {
  description = "ID de la zona privada en Route 53"
  value       = module.route53.route53_zone_id
}

# Nombre DNS simplificado para RDS PostgreSQL
output "rds_dns" {
  description = "Nombre DNS simplificado para RDS PostgreSQL"
  value       = module.route53.rds_dns
}

# Nombre DNS simplificado para ElasticCache Redis (Primary)
output "redis_primary_dns" {
  description = "Nombre DNS simplificado para ElasticCache Redis (Primary)"
  value       = module.route53.redis_primary_dns
}

# Nombre DNS simplificado para ElasticCache Redis (Read Replica)
output "redis_reader_dns" {
  description = "Nombre DNS simplificado para ElasticCache Redis (Read Replica)"
  value       = module.route53.redis_reader_dns
}

output "efs_dns" {
  description = "Nombre DNS simplificado para Elastic File System (EFS)"
  value       = module.route53.efs_dns
}
