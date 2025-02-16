output "vpc_cidr" {
  description = "CIDR de la VPC"
  value       = module.network.vpc_cidr
}

output "public_subnets" {
  description = "Lista de CIDRs de Subnets Públicas"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "Lista de CIDRs de Subnets Privadas"
  value       = module.network.private_subnets
}

output "availability_zones" {
  description = "Lista de Availability Zones"
  value       = module.network.availability_zones
}

output "network_tags" {
  description = "Tags usados en la red"
  value       = module.network.tags
}
