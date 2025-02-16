# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC"
  value       = module.network.vpc_id
}

# Subnets Públicas (IDs)
output "public_subnet_ids" {
  description = "Lista de IDs de Subnets Públicas"
  value       = module.network.public_subnet_ids
}

# Subnets Privadas (IDs)
output "private_subnet_ids" {
  description = "Lista de IDs de Subnets Privadas"
  value       = module.network.private_subnet_ids
}