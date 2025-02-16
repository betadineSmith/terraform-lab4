variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de CIDRs para subnets públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDRs para subnets privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para las subnets"
  type        = list(string)
}

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
}