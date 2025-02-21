# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DEL ALB (Application Load Balancer)
# ==============================================================================

# PERMITIR HTTP (80) DESDE CUALQUIER LUGAR
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Permitir acceso desde cualquier IP
  security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR HTTPS (443) DESDE CUALQUIER LUGAR
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Permitir acceso desde cualquier IP
  security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR TODO EL TRÁFICO DE SALIDA DESDE EL ALB
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Permitir todo tipo de tráfico
  cidr_blocks       = ["0.0.0.0/0"] # Habilitar tráfico de salida a cualquier destino
  security_group_id = aws_security_group.alb_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP EC2 Instance
# ==============================================================================

# PERMITIR HTTP (80) DESDE EL ALB
resource "aws_security_group_rule" "ec2_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = aws_security_group.ec2_sg.id

  source_security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR HTTPS (443) DESDE DESDE EL ALB
resource "aws_security_group_rule" "ec2_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = aws_security_group.ec2_sg.id

  source_security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR TODO EL TRÁFICO DE SALIDA DESDE EC2
resource "aws_security_group_rule" "ec2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Permitir todo tipo de tráfico
  cidr_blocks       = ["0.0.0.0/0"] # Habilitar tráfico de salida a cualquier destino
  security_group_id = aws_security_group.ec2_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DEL RDS (PostgreSQL)
# ==============================================================================
# Este SG protege la base de datos RDS PostgreSQL.
# Solo permite conexiones desde dentro de la VPC en el puerto 5432.
resource "aws_security_group_rule" "rds_ingress_ec2" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id = aws_security_group.rds_sg.id

  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "rds_ingress_ecs_drupal" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id = aws_security_group.rds_sg.id

  source_security_group_id = aws_security_group.ecs_drupal_sg.id
}


# Permitir a la base de datos enviar tráfico a cualquier destino (necesario para actualizaciones, logs, etc.).
resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE REDIS (ElastiCache)
# ==============================================================================
# Este SG protege Redis.
# Permite conexiones dentro de la VPC en el puerto 6379.
resource "aws_security_group_rule" "redis_ingress_ec2" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  security_group_id = aws_security_group.redis_sg.id

  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "redis_ingress_ecs_drupal" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  security_group_id = aws_security_group.redis_sg.id

  source_security_group_id = aws_security_group.ecs_drupal_sg.id
}

# Permitir salida de Redis a cualquier destino.
resource "aws_security_group_rule" "redis_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE LOS MICROSERVICIOS (ECS) DRUPAL
# ==============================================================================
# Este SG protege los microservicios desplegados en ECS.
# Permite conexiones en el puerto 8080 dentro de la VPC.
resource "aws_security_group_rule" "ecs_drupal_ingress" {
  type      = "ingress"
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"

  security_group_id = aws_security_group.ecs_drupal_sg.id

  source_security_group_id = aws_security_group.alb_sg.id
}

# Permitir a los microservicios en ECS realizar llamadas de salida (a bases de datos, APIs, etc.).
resource "aws_security_group_rule" "ecs_drupal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_drupal_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE EFS (Elastic File System)
# ==============================================================================
# Este SG protege el almacenamiento en red EFS.
# Permite conexiones en el puerto 2049 NFS (Network File System) dentro de la VPC.
resource "aws_security_group_rule" "efs_ingress_ec2" {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"

  security_group_id = aws_security_group.efs_sg.id

  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "efs_ingress_ecs_drupal" {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"

  security_group_id = aws_security_group.efs_sg.id

  source_security_group_id = aws_security_group.ecs_drupal_sg.id
}

# Permitir a EFS comunicarse con cualquier destino (útil para backups, logs, etc.).
resource "aws_security_group_rule" "efs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE LOS MICROSERVICIOS (ECS)
#     Memcached 11211
# ==============================================================================
# Este SG protege los microservicios desplegados en ECS Memcached.
# Permite conexiones en el puerto 11211 dentro de la VPC.
resource "aws_security_group_rule" "ecs_mem_ingress_ec2" {
  type      = "ingress"
  from_port = 11211
  to_port   = 11211
  protocol  = "tcp"

  security_group_id = aws_security_group.ecs_mem_sg.id

  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ecs_mem_ingress_ecs_drupal" {
  type      = "ingress"
  from_port = 11211
  to_port   = 11211
  protocol  = "tcp"

  security_group_id = aws_security_group.ecs_mem_sg.id

  source_security_group_id = aws_security_group.ecs_drupal_sg.id
}

# Permitir a los microservicios en ECS realizar llamadas de salida (a bases de datos, APIs, etc.).
resource "aws_security_group_rule" "ecs_mem_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_mem_sg.id
}
