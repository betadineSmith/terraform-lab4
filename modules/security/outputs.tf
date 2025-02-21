# ============================================================
# OUTPUTS DEL MÓDULO SECURITY
# ============================================================
# Devuelve los IDs de los Security Groups creados para que 
# puedan ser referenciados en otros módulos.
# ============================================================

# ID del Security Group para EC2 Instance
output "ec2_sg_id" {
  description = "ID del Security Group para EC2 Instance"
  value       = aws_security_group.ec2_sg.id
}

# ID del Security Group para RDS PostgreSQL
output "rds_sg_id" {
  description = "ID del Security Group para RDS"
  value       = aws_security_group.rds_sg.id
}

# ID del Security Group para ElasticCache Redis
output "redis_sg_id" {
  description = "ID del Security Group para Redis"
  value       = aws_security_group.redis_sg.id
}


# ID del Security Group para los Microservicios en ECS Drupal
output "ecs_drupal_sg_id" {
  description = "ID del Security Group para ECS Drupal"
  value       = aws_security_group.ecs_drupal_sg.id
}

# ID del Security Group para los Microservicios en ECS Memcached
output "ecs_mem_sg_id" {
  description = "ID del Security Group para ECS Memcached"
  value       = aws_security_group.ecs_mem_sg.id
}

# ID del Security Group para el ALB (Application Load Balancer)
output "alb_sg_id" {
  description = "ID del Security Group para el ALB"
  value       = aws_security_group.alb_sg.id
}

# ID del Security Group para el Network Load Balancer (Interno)
output "nlb_sg_id" {
  description = "ID del Security Group para el Network Load Balancer"
  value       = aws_security_group.nlb_sg.id
}

# ID del Security Group para Elastic File System (EFS)
output "efs_sg_id" {
  description = "ID del Security Group para Elastic File System (EFS)"
  value       = aws_security_group.efs_sg.id
}

