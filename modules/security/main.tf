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