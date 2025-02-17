# --------------------------------------------------------------------
# OUTPUTS DEL MÓDULO EFS
# --------------------------------------------------------------------
# - Se exporta el nombre DNS del sistema de archivos EFS.
# - Este endpoint es utilizado para montar el EFS en instancias EC2,
#   tareas de ECS Fargate o cualquier servicio compatible con NFS.
# --------------------------------------------------------------------

# Endpoint DNS del sistema de archivos (para montaje NFS)
output "efs_dns_name" {
  description = "Nombre DNS para montar el EFS"
  value       = aws_efs_file_system.efs.dns_name
}