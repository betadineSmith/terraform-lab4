#-----------------------------
# Variables para Networking
#-----------------------------
variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Lista de CIDRs para Subnets Públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Lista de CIDRs para Subnets Privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Lista de Availability Zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

#----------------------------------------
# Variables para RDS
#----------------------------------------
variable "db_engine" {
  description = "Motor de base de datos"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Versión del motor de base de datos"
  type        = string
  default     = "15.4"
}

variable "db_instance_class" {
  description = "Clase de la instancia RDS"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_storage" {
  description = "Capacidad de almacenamiento en GB"
  type        = number
  default     = 20
}

variable "db_backup_retention" {
  description = "Días de retención de backups"
  type        = number
  default     = 7
}
