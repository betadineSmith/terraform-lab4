# ==================================================================
# VARIABLES DEL MÓDULO EFS (Elastic File System)
# ==================================================================
# Estas variables configuran la creación del sistema de archivos EFS.
# - Se definen parámetros como nombre, rendimiento y encriptación.
# - Se reciben los IDs de subnets y security groups desde el módulo principal.
# ==================================================================

# ------------------------------------------------------------
# CONFIGURACIÓN GENERAL DE EFS
# ------------------------------------------------------------

# Nombre del sistema de archivos EFS
variable "efs_name" {
  description = "Nombre del sistema de archivos EFS"
  type        = string
}

# Modo de rendimiento de EFS (generalPurpose o maxIO)
variable "efs_performance_mode" {
  description = "Modo de rendimiento del EFS"
  type        = string
  default     = "generalPurpose"
}

# Modo de rendimiento del EFS (bursting o provisioned)
variable "efs_throughput_mode" {
  description = "Modo de rendimiento del EFS"
  type        = string
  default     = "bursting"
}

# Activar o no la encriptación del sistema de archivos
variable "efs_encrypted" {
  description = "Habilitar encriptación en EFS (true/false)"
  type        = bool
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE RED
# ------------------------------------------------------------

# Lista de subnets privadas donde se montará el EFS
variable "efs_subnet_ids" {
  description = "Lista de subnets privadas donde se montará el EFS"
  type        = list(string)
}

# ID del Security Group que se asociará al EFS
variable "efs_security_group_id" {
  description = "ID del Security Group asociado al EFS"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE ETIQUETAS (TAGS)
# ------------------------------------------------------------

# Tags comunes para etiquetar los recursos creados
variable "tags" {
  description = "Etiquetas aplicadas a los recursos de EFS"
  type        = map(string)
}
