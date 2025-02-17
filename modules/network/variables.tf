# ============================================================
# VARIABLES DEL MÓDULO NETWORK
# ============================================================
# Este archivo define todas las variables necesarias para 
# inicializar el módulo de red en Terraform.
# La configuración incluye:
# - Creación de una VPC
# - Subnets públicas y privadas
# - Gateway de Internet (IGW)
# - NAT Gateway y ruteo privado
# - Etiquetas para todos los recursos
# ============================================================

# ------------------------------------------------------------
# CONFIGURACIÓN DE LA VPC
# ------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE SUBNETS
# ------------------------------------------------------------

# Lista de CIDRs para Subnets Públicas
variable "public_subnets" {
  description = "Lista de CIDRs para subnets públicas"
  type        = list(string)
}

# Lista de CIDRs para Subnets Privadas
variable "private_subnets" {
  description = "Lista de CIDRs para subnets privadas"
  type        = list(string)
}

# Lista de Availability Zones (AZs) donde se distribuirán las subnets
variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para las subnets"
  type        = list(string)
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE ETIQUETAS (TAGS)
# ------------------------------------------------------------

# Mapa de etiquetas comunes para todos los recursos de red
variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
}