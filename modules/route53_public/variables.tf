# =============================================================

# =============================================================
variable "domain_name" {
  description = "Dominio principal de la zona pública"
  type        = string
  default     = null
}

variable "alb_dns_name" {
  description = "Nombre DNS del Load Balancer"
  type        = string
  default     = null
}

variable "alb_zone_id" {
  description = "ID de la zona del Load Balancer"
  type        = string
  default     = null
}

# Tags generales
variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
}