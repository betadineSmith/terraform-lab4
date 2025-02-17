# ======================================================================
# MÓDULO RDS - CREACIÓN DE BASE DE DATOS POSTGRESQL
# ======================================================================
# Este módulo crea una base de datos PostgreSQL en AWS RDS.
# Características principales:
# - Se implementa en subnets privadas con Multi-AZ habilitado.
# - Se gestiona la contraseña automáticamente con AWS Secrets Manager.
# - Se usa un grupo de subnets específico para la base de datos.
# - Se asocia con un Security Group exclusivo para RDS.
# ======================================================================

# -----------------------------------------------------------------------
# CREACIÓN DEL GRUPO DE SUBNETS PARA RDS
# -----------------------------------------------------------------------
# RDS necesita un grupo de subnets para operar en múltiples AZs.
# Se usan las subnets privadas proporcionadas por el módulo de red.
# -----------------------------------------------------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = var.db_subnet_group_name
  })
}



# -----------------------------------------------------------------------
# CREACIÓN DE LA INSTANCIA RDS POSTGRESQL
# -----------------------------------------------------------------------
# Se crea la base de datos PostgreSQL con las siguientes opciones:
# - `multi_az`: Alta disponibilidad con standby en otra AZ.
# - `backup_retention_period`: Número de días de retención de backups.
# - `publicly_accessible`: Controla si la instancia tiene IP pública (FALSO en este caso).
# - `db_subnet_group_name`: Asigna el grupo de subnets creado anteriormente.
# - `vpc_security_group_ids`: Asigna el Security Group de RDS.
# -----------------------------------------------------------------------

resource "aws_db_instance" "rds" {
  identifier              = var.db_identifier
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_storage
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention
  publicly_accessible     = var.db_public_access

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]

  # Usuario admin de la base de datos
  username = var.db_username

  # AWS gestionará automáticamente el usuario y la contraseña en Secrets Manager.
  manage_master_user_password = true

  tags = merge(var.tags, {
    Name = var.db_identifier
  })
}
