# =============================================================
# VARIABLES DEL MÓDULO ROUTE53_PUBLIC
# =============================================================

# -------------------------------------------------------------
# Nombre del dominio principal para la zona pública en Route 53
# Ejemplo: "jmbmcloud.com"
# -------------------------------------------------------------
variable "domain_name" {
  description = "Dominio principal de la zona pública"
  type        = string
}

# ---------------------------------------------------------------------
# Nombre DNS del Application Load Balancer (ALB)
# Este valor es necesario para crear los registros ALIAS en Route 53.
# Se obtiene desde el módulo de ALB.
# Ejemplo: "lab4-alb-external-1234567890.eu-west-3.elb.amazonaws.com"
# ----------------------------------------------------------------------
variable "alb_dns_name" {
  description = "Nombre DNS del Load Balancer"
  type        = string
}

# --------------------------------------------------------------------------
# ID de la zona de Route 53 para el Load Balancer (ALB)
# Se requiere para configurar correctamente los registros ALIAS en Route 53.
# Se obtiene desde el módulo de ALB.
# Ejemplo: "Z3Q77PNBQS71R4"
# ---------------------------------------------------------------------------
variable "alb_zone_id" {
  description = "ID de la zona del Load Balancer"
  type        = string
}

# -----------------------------------------------------------------------------
# Nombre DNS de la distribución de CloudFront
# Se utiliza para crear un registro CNAME en Route 53, apuntando a CloudFront.
# Ejemplo: "d6wjq57qzgib4.cloudfront.net"
# -----------------------------------------------------------------------------
variable "cloudfront_dns_name" {
  description = "Nombre DNS de la distribución de CloudFront"
  type        = string
}

# -------------------------------------------------------------
# Etiquetas (tags) comunes para los recursos creados en AWS.
# -------------------------------------------------------------
variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
}