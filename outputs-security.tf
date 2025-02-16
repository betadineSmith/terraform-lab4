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
