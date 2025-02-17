# ==========================================================================
# VARIABLES GLOBALES
# ==========================================================================
# Variables globales utilizadas en todos los módulos. 
# Se definen valores generales que se aplicarán a múltiples recursos.
# ==========================================================================

# NOTA: La variable de tags no se define aquí porque se genera en el `main.tf`
# usando `locals { tags = jsondecode(file("${path.root}/tags.json")) }`.


# ==========================================================================
# VARIABLES PARA NETWORKING (VPC y Subnets)
# ==========================================================================
# Definen la configuración de la red, incluyendo la VPC, subnets públicas 
# y privadas, y las Availability Zones donde se desplegarán los recursos.
# ==========================================================================

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
  description = "Lista de Availability Zones donde se despliegan los recursos"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

# ==========================================================================
# VARIABLES PARA RDS POSTGRESQL
# ==========================================================================
# Configuración de la base de datos RDS PostgreSQL.
# Se utiliza Multi-AZ para alta disponibilidad y backups automáticos.
# ==========================================================================

variable "db_engine" {
  description = "Motor de base de datos a utilizar"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "Clase de la instancia RDS (Tamaño de máquina)"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_storage" {
  description = "Capacidad de almacenamiento en GB para la base de datos"
  type        = number
  default     = 20
}

variable "db_backup_retention" {
  description = "Número de días que se retienen los backups automáticos"
  type        = number
  default     = 2
}

variable "db_identifier" {
  description = "Identificador único de la instancia RDS"
  type        = string
  default     = "lab4-postgre-db"
}

variable "db_subnet_group_name" {
  description = "Nombre del grupo de subnets donde se desplegará RDS"
  type        = string
  default     = "lab4-postgre-subnet-group"
}

variable "db_public_access" {
  description = "Definir si la RDS es pública (true) o privada (false)"
  type        = bool
  default     = false
}

variable "db_multi_az" {
  description = "Si se habilita Multi-AZ para alta disponibilidad"
  type        = bool
  default     = true
}

variable "db_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
  default     = "dbadmin"
}

# ==========================================================================
# VARIABLES PARA ELASTICACHE REDIS
# ==========================================================================
# Configuración de un cluster Redis en ElasticCache.
# Se usa para almacenamiento en memoria y caché distribuida.
# ==========================================================================

variable "redis_cluster_id" {
  description = "Identificador único del cluster de ElastiCache Redis"
  type        = string
  default     = "lab4-redis-cluster"
}

variable "redis_subnet_group_name" {
  description = "Nombre del grupo de subnets para Redis"
  type        = string
  default     = "lab4-redis-subnet-group"
}

variable "redis_instance_type" {
  description = "Tipo de instancia para Redis"
  type        = string
  default     = "cache.t4g.micro"
}

variable "redis_node_groups" {
  description = "Número de grupos de nodos (shards)"
  type        = number
  default     = 1 # 1 nodo principal
}

variable "redis_replicas_per_group" {
  description = "Número de réplicas por cada grupo de nodos"
  type        = number
  default     = 1 # 1 réplica en otra AZ
}

variable "redis_failover_enabled" {
  description = "Habilitar conmutación por error automática en Redis"
  type        = bool
  default     = true # Activado por defecto
}

# =====================================================================
# VARIABLES PARA EFS (Elastic File System)
# =====================================================================
# Definen los parámetros para la creación del sistema de archivos EFS
# =====================================================================

variable "efs_name" {
  description = "Nombre del sistema de archivos EFS"
  type        = string
  default     = "lab4-efs"
}

variable "efs_performance_mode" {
  description = "Modo de rendimiento del EFS (generalPurpose o maxIO)"
  type        = string
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  description = "Modo de rendimiento del EFS (bursting o provisioned)"
  type        = string
  default     = "bursting"
}

variable "efs_encrypted" {
  description = "Habilitar encriptación en EFS"
  type        = bool
  default     = false # Desactivamos la encriptación
}
