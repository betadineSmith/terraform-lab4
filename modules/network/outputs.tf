# CIDR de la VPC
output "vpc_cidr" {
  description = "CIDR de la VPC"
  value       = var.vpc_cidr
}

# CIDRs de Subnets Públicas
output "public_subnets" {
  description = "Lista de CIDRs de las Subnets Públicas"
  value       = var.public_subnets
}

# CIDRs de Subnets Privadas
output "private_subnets" {
  description = "Lista de CIDRs de las Subnets Privadas"
  value       = var.private_subnets
}

# Availability Zones
output "availability_zones" {
  description = "Lista de Zonas de Disponibilidad"
  value       = var.availability_zones
}

# Tags usados en la red
output "tags" {
  description = "Etiquetas usadas en la red"
  value       = var.tags
}