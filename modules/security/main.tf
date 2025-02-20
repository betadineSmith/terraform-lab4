# ======================================================================
# MÓDULO SECURITY - CREACIÓN DE SECURITY GROUPS
# ======================================================================
# Este módulo gestiona la creación de Security Groups en AWS.
# Inicialmente, se crean sin reglas y se irán definiendo 
# según las necesidades de los servicios desplegados.
#
# Security Groups creados:
# - RDS PostgreSQL (lab4-rds-sg)
# - ElasticCache Redis (lab4-redis-sg)
# - ECS Microservicios (lab4-ecs-sg)
# - Application Load Balancer (lab4-alb-sg)
# - Network Load Balancer Interno (lab4-nlb-sg)
# - Elastic File System (EFS) (lab4-efs-sg)
#
# Se requieren dos variables de entrada:
# - vpc_id: Identificador de la VPC en la que se crean los SGs.
# - tags: Etiquetas comunes para los recursos.
#
# Se generan como outputs los IDs de los SGs para ser utilizados
# en otros módulos como RDS, Redis, ECS, ALB y EFS.
# ======================================================================

# Security Group para RDS PostgreSQL
resource "aws_security_group" "rds_sg" {
  name        = "lab4-rds-sg"
  description = "Security Group para RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-rds-sg"
  })
}

# Security Group para ElasticCache Redis
resource "aws_security_group" "redis_sg" {
  name        = "lab4-redis-sg"
  description = "Security Group para ElasticCache Redis"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-redis-sg"
  })
}

# Security Group para los Microservicios en ECS
resource "aws_security_group" "ecs_sg" {
  name        = "lab4-ecs-sg"
  description = "Security Group para los Microservicios en ECS"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-ecs-sg"
  })
}

# Security Group para los Microservicios en ECS en ECS Memcached
resource "aws_security_group" "ecs_mem_sg" {
  name        = "lab4-ecs-memcached-sg"
  description = "Security Group para los Microservicios en ECS Memcached"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-ecs-memcached-sg"
  })
}

# Security Group para el ALB (Application Load Balancer)
resource "aws_security_group" "alb_sg" {
  name        = "lab4-alb-sg"
  description = "Security Group para el Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-alb-sg"
  })
}

# Security Group para el Network Load Balancer (NLB - Interno)
resource "aws_security_group" "nlb_sg" {
  name        = "lab4-nlb-sg"
  description = "Security Group para el Network Load Balancer interno"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-nlb-sg"
  })
}

# Security Group para Elastic File System (EFS)
resource "aws_security_group" "efs_sg" {
  name        = "lab4-efs-sg"
  description = "Security Group para Elastic File System (EFS)"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "lab4-efs-sg"
  })
}