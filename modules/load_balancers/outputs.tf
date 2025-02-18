# ==================================================================
# OUTPUTS DEL MÓDULO - EXPORTAR DATOS PARA OTROS MÓDULOS
# ==================================================================

# ARN del Load Balancer creado (ALB o NLB)
output "load_balancer_arn" {
  description = "ARN del Load Balancer creado (ALB o NLB), necesario para asociar Target Groups y Listeners."
  value       = aws_lb.load_balancer.arn
}

# ARN del Listener HTTP (80) si es ALB
output "http_listener_arn" {
  description = "ARN del Listener HTTP (puerto 80) en el Application Load Balancer (ALB)."
  value       = var.lb_type == "application" ? aws_lb_listener.http[0].arn : null
}

# ARN del Listener HTTPS (443) si es ALB y HTTPS está habilitado
output "https_listener_arn" {
  description = "ARN del Listener HTTPS (puerto 443) en el Application Load Balancer (ALB), con SSL habilitado."
  value       = var.lb_type == "application" && var.enable_https ? aws_lb_listener.https[0].arn : null
}

# Lista de ARNs de los Listeners NLB (TCP)
output "nlb_listeners_arns" {
  description = "Lista de ARNs de los Listeners TCP creados en el Network Load Balancer (NLB), uno por cada puerto en 'lb_listener_ports'."
  value       = var.lb_type == "network" ? aws_lb_listener.nlb[*].arn : []
}

output "load_balancer_dns_name" {
  value       = aws_lb.load_balancer.dns_name
  description = "Nombre DNS del Load Balancer"
}

output "load_balancer_zone_id" {
  value       = aws_lb.load_balancer.zone_id
  description = "ID de la zona del Load Balancer"
}