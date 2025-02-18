# ==================================================================
# MÓDULO DE LOAD BALANCERS (ALB/NLB)
# ==================================================================
# - Se puede usar tanto para ALB público como privado.
# - Configura Listeners HTTP (80) y HTTPS (443) si el LB es ALB.
# - Redirige tráfico HTTP a HTTPS automáticamente si HTTPS está habilitado.
# - Usa un certificado SSL para conexiones seguras en HTTPS.
# - Si el LB es un NLB, crea Listeners TCP en múltiples puertos.
# ==================================================================

# ----------------------------------------------------------------------------
# CREACIÓN DEL LOAD BALANCER (ALB o NLB)
# ----------------------------------------------------------------------------
resource "aws_lb" "load_balancer" {
  name                       = var.load_balancer_name
  internal                   = var.lb_visibility == "internal" ? true : false
  load_balancer_type         = var.lb_type
  security_groups            = [var.load_balancer_security_group]
  subnets                    = var.load_balancer_subnets
  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = var.load_balancer_name
  })
}

# ----------------------------------------------------------------------------
# LISTENER PARA ALB - PUERTO 80 (HTTP)
# ----------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  count             = var.lb_type == "application" ? 1 : 0 # Solo si es ALB
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.enable_https ? "redirect" : "fixed-response"

    # Si HTTPS está habilitado, redirigir HTTP -> HTTPS
    dynamic "redirect" {
      for_each = var.enable_https ? [1] : []
      content {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # Si HTTPS no está habilitado, devolver mensaje "Service Unavailable: No Target Group Associated"
    dynamic "fixed_response" {
      for_each = var.enable_https ? [] : [1]
      content {
        content_type = "text/plain"
        message_body = "Service Unavailable: No Target Group Associated"
        status_code  = "503"
      }
    }
  }
}

##################################################################################
#  OJO !!!! Este recurso se crea por fuera de Terraform 
##################################################################################
# Buscar el certificado ACM con el nombre de dominio
data "aws_acm_certificate" "ssl_cert" {
  domain      = "*.jmbmcloud.com" # Filtra por el nombre del dominio
  most_recent = true              # Si hay varios certificados, usa el más reciente
}


# ----------------------------------------------------------------------------
# LISTENER PARA ALB - PUERTO 443 (HTTPS)
# ----------------------------------------------------------------------------
resource "aws_lb_listener" "https" {
  count             = var.lb_type == "application" && var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.ssl_cert.arn # Usa el ARN detectado
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable: No Target Group Associated"
      status_code  = "503"
    }
  }
}

# ----------------------------------------------------------------------------
# LISTENERS PARA NLB - PUERTOS PERSONALIZADOS
# ----------------------------------------------------------------------------
resource "aws_lb_listener" "nlb" {
  count             = var.lb_type == "network" ? length(var.nlb_listener_ports) : 0
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.nlb_listener_ports[count.index]
  protocol          = "TCP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable: No Target Group Associated"
      status_code  = "503"
    }
  }
}
