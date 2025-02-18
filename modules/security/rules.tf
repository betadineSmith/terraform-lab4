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
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DEL RDS (PostgreSQL)
# ==============================================================================
# Este SG protege la base de datos RDS PostgreSQL.
# Solo permite conexiones desde dentro de la VPC en el puerto 5432.
resource "aws_security_group_rule" "rds_ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"] # Permitir acceso dentro de la VPC
  security_group_id = aws_security_group.rds_sg.id

  # Alternativa futura para encadenar con el SG de los microservicios:
  # source_security_group_id = aws_security_group.ecs_sg.id
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
resource "aws_security_group_rule" "redis_ingress" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.redis_sg.id

  # Alternativa futura para encadenar con el SG de ECS:
  # source_security_group_id = aws_security_group.ecs_sg.id
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
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE LOS MICROSERVICIOS (ECS)
# ==============================================================================
# Este SG protege los microservicios desplegados en ECS.
# Permite conexiones en el puerto 8080 dentro de la VPC.
resource "aws_security_group_rule" "ecs_ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.ecs_sg.id

  # Alternativa futura para encadenar con el SG del ALB:
  # source_security_group_id = aws_security_group.alb_sg.id
}

# Permitir a los microservicios en ECS realizar llamadas de salida (a bases de datos, APIs, etc.).
resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}

# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DE EFS (Elastic File System)
# ==============================================================================
# Este SG protege el almacenamiento en red EFS.
# Permite conexiones en el puerto 2049 NFS (Network File System) dentro de la VPC.
resource "aws_security_group_rule" "efs_ingress" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.efs_sg.id

  # Alternativa futura para encadenar con el SG de ECS:
  # source_security_group_id = aws_security_group.ecs_sg.id
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
