# =====================================================================
# MÓDULO EFS - CREACIÓN DE UN SISTEMA DE ARCHIVOS ELASTIC FILE SYSTEM
# =====================================================================
# Este módulo crea un sistema de archivos EFS en AWS.
# - Se define con un modo de rendimiento y throughput configurables.
# - Se asocia a subnets privadas y a un Security Group.
# - Se pueden aplicar etiquetas (tags) a los recursos.
# =====================================================================

# CREAR EL SISTEMA DE ARCHIVOS EFS
resource "aws_efs_file_system" "efs" {
  creation_token   = var.efs_name
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode
  encrypted        = var.efs_encrypted # Está puesto a false inicialmente

  tags = merge(var.tags, {
    Name = var.efs_name
  })
}

# CREAR PUNTOS DE MONTAJE EN LAS SUBNETS PRIVADAS
resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.efs_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_subnet_ids[count.index]
  security_groups = [var.efs_security_group_id]
}
