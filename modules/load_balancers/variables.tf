# ------------------------------------------------------------
# VARIABLES PARA EL LOAD BALANCER
# ------------------------------------------------------------

# Nombre del Load Balancer
variable "load_balancer_name" {
  description = "Nombre del Load Balancer"
  type        = string
}

# Indicar si el Load Balancer es interno o externo
variable "lb_visibility" {
  description = "Visibilidad del Load Balancer (public o internal)"
  type        = string
}

# Tipo de Load Balancer: Application Load Balancer (ALB) o Network Load Balancer (NLB)
variable "lb_type" {
  description = "Tipo de Load Balancer (application o network)"
  type        = string
}

# Security Group asociado al Load Balancer
variable "load_balancer_security_group" {
  description = "ID del Security Group para el Load Balancer"
  type        = string
}

# Subnets donde se desplegará el Load Balancer
variable "load_balancer_subnets" {
  description = "Lista de subnets para el Load Balancer"
  type        = list(string)
}

# Activar o no HTTPS
variable "enable_https" {
  description = "Define si el Load Balancer usará HTTPS con certificado SSL"
  type        = bool
}

# Lista de puertos en los que escuchará el Network Load Balancer (NLB)
variable "nlb_listener_ports" {
  description = "Lista de puertos en los que el NLB escuchará el tráfico"
  type        = list(number)
  default     = []
}

# Tags globales
variable "tags" {
  description = "Etiquetas globales para los recursos"
  type        = map(string)
}
