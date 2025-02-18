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

# ===========================================================================================
# VARIABLES DEL MÓDULO S3 + CLOUDFRONT
# ===========================================================================================
# - Se define un bucket S3 privado para almacenar imágenes estáticas.
# - Se crea una distribución CloudFront para servir las imágenes de forma rápida y segura.
# - Se usa Origin Access Control (OAC) para restringir el acceso a S3.
# ===========================================================================================

# ------------------------------------
# VARIABLES PARA S3 (ALMACENAMIENTO)
# ------------------------------------

# Nombre del bucket S3 (debe ser único en AWS)
variable "s3_bucket_name" {
  description = "Nombre del bucket S3 donde se almacenarán las imágenes"
  type        = string
  default     = "lab4-s3-images"
}

# Activar o desactivar el versionado del bucket (false por defecto)
variable "enable_s3_versioning" {
  description = "Habilita o deshabilita el versionado en el bucket S3"
  type        = bool
  default     = false
}

# Activar o desactivar el cifrado de objetos en el bucket
variable "enable_s3_encryption" {
  description = "Activa el cifrado de los objetos almacenados en el bucket S3"
  type        = bool
  default     = true
}

# Permite decidir si el bucket puede ser eliminado con contenido dentro.
variable "force_destroy_s3" {
  description = "Permitir eliminación del bucket aunque tenga objetos dentro"
  type        = bool
  default     = false # No elimina por defecto
}

# ----------------------------------
# VARIABLES PARA CLOUDFRONT (CDN)
# ----------------------------------

# Clase de precio para la distribución de CloudFront (define regiones accesibles)
variable "cloudfront_price_class" {
  description = "Clase de precios de CloudFront para limitar regiones"
  type        = string
  default     = "PriceClass_100"
}

# Métodos HTTP permitidos en CloudFront
variable "cloudfront_allowed_methods" {
  description = "Métodos HTTP permitidos en la caché de CloudFront"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

# ===========================================================================================
# VARIABLES DEL MÓDULO LOAD BALANCER
# ===========================================================================================
# ===========================================================================================

# Indicar si el Load Balancer es interno o externo
variable "lb_visibility" {
  description = "Visibilidad del Load Balancer (public o internal)"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "internal"], var.lb_visibility)
    error_message = "El valor de 'lb_visibility' debe ser 'public' o 'internal'."
  }
}

# Tipo de Load Balancer: Application Load Balancer (ALB) o Network Load Balancer (NLB)
variable "lb_type" {
  description = "Tipo de Load Balancer (application o network)"
  type        = string
  default     = "application"

  validation {
    condition     = contains(["application", "network"], var.lb_type)
    error_message = "El valor de 'lb_type' debe ser 'application' o 'network'."
  }
}

# Activar o no HTTPS
variable "enable_https" {
  description = "Define si el Load Balancer usará HTTPS con certificado SSL"
  type        = bool
  default     = false
}

# Lista de puertos para Network Load Balancer (NLB)
variable "nlb_listener_ports" {
  description = "Lista de puertos en los que escuchará el Network Load Balancer (NLB)"
  type        = list(number)
  default     = [5432, 6379] # Por defecto PostgreSQL y Redis.
}