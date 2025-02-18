# ==================================================================
# VARIABLES DEL MÓDULO ROUTE 53
# ==================================================================
# - Se define la zona privada de Route 53 para resolución interna.
# - Se crean registros para los endpoints de RDS, Redis y EFS.
# ==================================================================

# Nombre del dominio de la zona privada
variable "private_zone_name" {
  description = "Nombre de la zona privada en Route 53 (ej. lab4.local)"
  type        = string
  default     = null
}

# ID de la VPC donde se asociará la zona privada
variable "vpc_id" {
  description = "ID de la VPC donde se asociará la zona privada"
  type        = string
}

# Endpoint de la base de datos RDS
variable "rds_endpoint" {
  description = "Endpoint de la base de datos RDS PostgreSQL"
  type        = string
}

# Endpoint principal de Redis (Lectura/Escritura)
variable "redis_primary_endpoint" {
  description = "Endpoint Primary del cluster Redis"
  type        = string
}

# Endpoint de solo lectura de Redis
variable "redis_reader_endpoint" {
  description = "Endpoint de solo lectura del cluster Redis"
  type        = string
}

# Endpoint del sistema de archivos EFS
variable "efs_dns_name" {
  description = "Endpoint del Elastic File System (EFS)"
  type        = string
}

# Tags generales
variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
}
