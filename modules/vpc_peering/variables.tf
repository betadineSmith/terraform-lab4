# ========================================
# VARIABLES DEL MÓDULO VPC PEERING
# ========================================

# ID de la VPC principal que hará el peering
variable "vpc_id" {
  description = "ID de la VPC principal"
  type        = string
}

# ID de la VPC de backup o secundaria con la que se realizará el peering
variable "peer_vpc_id" {
  description = "ID de la VPC secundaria (backup)"
  type        = string
}

# CIDR de la VPC principal
variable "vpc_cidr" {
  description = "CIDR de la VPC principal"
  type        = string
}

# CIDR de la VPC de backup
variable "peer_vpc_cidr" {
  description = "CIDR de la VPC secundaria (backup)"
  type        = string
}

# Lista de IDs de las tablas de rutas de la VPC principal
variable "route_table_ids_main" {
  description = "Lista de IDs de tablas de rutas de la VPC principal"
  type        = list(string)
}

# Lista de IDs de las tablas de rutas de la VPC de backup
variable "route_table_ids_peer" {
  description = "Lista de IDs de tablas de rutas de la VPC de backup"
  type        = list(string)
}

# Configuración para aceptar automáticamente la conexión de peering
variable "auto_accept" {
  description = "Aceptar automáticamente el peering"
  type        = bool
  default     = true
}

# Etiquetas aplicadas a los recursos creados por el módulo
variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}
