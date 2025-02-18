
# ===============================================================================
# MÓDULO DE ROUTE 53 - ZONA PÚBLICA
# ===============================================================================
# Este módulo crea una zona pública en AWS Route 53 y configura registros ALIAS
# para apuntar al Load Balancer (ALB).
# Se deben actualizar los nameservers en IONOS después de aplicar Terraform.
# ===============================================================================

# ====================================================
# CREACIÓN DE LA ZONA PÚBLICA EN ROUTE 53
# ====================================================
resource "aws_route53_zone" "public_zone" {
  name = var.domain_name # Dominio principal

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

# ====================================================
# REGISTROS DNS - ALIAS PARA EL LOAD BALANCER
# ====================================================

# Registro A para el dominio raíz (jmbmcloud.com -> ALB)
resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = var.domain_name # Dominio principal
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Registro A para www (www.jmbmcloud.com -> ALB)
resource "aws_route53_record" "www_alias" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "www.${var.domain_name}" # www.jmbmcloud.com
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# ====================================================
# REGISTRO DNS - DISTRIBUCION CLOUDFRONT
# ====================================================

# Registro CNAME para CloudFront (cdn.jmbmcloud.com -> CloudFront)
resource "aws_route53_record" "cdn_cname" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "cdn.${var.domain_name}" # cdn.jmbmcloud.com
  type    = "CNAME"
  ttl     = 300
  records = [var.cloudfront_dns_name]
}