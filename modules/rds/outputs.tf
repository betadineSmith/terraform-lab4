# ------------------------------------------------------------
# OUTPUTS DEL MÓDULO
# ------------------------------------------------------------
# - Se exporta el endpoint de conexión a la base de datos.
# - Se expone el ARN del secreto generado en Secrets Manager.
# ------------------------------------------------------------

# Endpoint de la base de datos
output "rds_endpoint" {
  description = "Endpoint de la instancia RDS"
  value       = aws_db_instance.rds.endpoint
}

# ARN del secreto en Secrets Manager
output "rds_secret_arn" {
  description = "ARN del secreto de la RDS en Secrets Manager"
  value       = aws_db_instance.rds.master_user_secret[0].secret_arn
}
