
# ============================================================
# VARIABLES DEL MÓDULO RDS
# ============================================================
# Este archivo define todas las variables necesarias para 
# inicializar el módulo de RDS en Terraform.
# ============================================================

# ------------------------------------------------------------
# CONFIGURACIÓN GENERAL DE RDS
# ------------------------------------------------------------

# Motor de la base de datos
variable "db_engine" {
  description = "Motor de la base de datos (postgres, mysql, etc.)"
  type        = string
}

# Clase de la instancia RDS
variable "db_instance_class" {
  description = "Clase de la instancia RDS (tamaño de la máquina)"
  type        = string
}

# Capacidad de almacenamiento en GB
variable "db_storage" {
  description = "Capacidad de almacenamiento de la base de datos en GB"
  type        = number
}

# Desplegar RDS en modo Multi-AZ
variable "db_multi_az" {
  description = "Indica si la instancia RDS se desplegará en Multi-AZ"
  type        = bool
}

# Días de retención de backups automáticos
variable "db_backup_retention" {
  description = "Días de retención de backups automáticos"
  type        = number
}

# Nombre único para la base de datos
variable "db_identifier" {
  description = "Identificador único de la instancia RDS"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE RED
# ------------------------------------------------------------

# Lista de IDs de las subnets privadas donde se desplegará RDS
variable "private_subnet_ids" {
  description = "Lista de IDs de las subnets privadas donde se alojará la base de datos"
  type        = list(string)
}

# Nombre del DB Subnet Group
variable "db_subnet_group_name" {
  description = "Nombre del grupo de subnets donde se creará la base de datos"
  type        = string
}

# Security Group asociado a la base de datos
variable "db_security_group_id" {
  description = "ID del Security Group asociado a la instancia RDS"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE ACCESO Y SECRETS MANAGER
# ------------------------------------------------------------

# Si la base de datos es pública o privada
variable "db_public_access" {
  description = "Indica si la base de datos será accesible desde Internet"
  type        = bool
}

# Nombre del usuario administrador de la base de datos
variable "db_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE ETIQUETAS (TAGS)
# ------------------------------------------------------------

# Etiquetas para los recursos
variable "tags" {
  description = "Tags aplicados a todos los recursos creados"
  type        = map(string)
}
