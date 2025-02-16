# ID de la VPC
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

# Subnets Públicas (IDs)
output "public_subnet_ids" {
  description = "Lista de IDs de Subnets Públicas"
  value       = aws_subnet.public[*].id
}

# Subnets Privadas (IDs)
output "private_subnet_ids" {
  description = "Lista de IDs de Subnets Privadas"
  value       = aws_subnet.private[*].id
}