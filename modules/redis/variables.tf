# ============================================================
# VARIABLES DEL MÓDULO REDIS
# ============================================================
# Este módulo configura un clúster de ElastiCache Redis.
# Se despliega en subnets privadas con una configuración 
# de Primary-Replica en diferentes Availability Zones.
# ============================================================

# ------------------------------------------------------------
# CONFIGURACIÓN GENERAL REDIS
# ------------------------------------------------------------

# Identificador del clúster de Redis
variable "redis_cluster_id" {
  description = "Identificador único del cluster de ElastiCache Redis"
  type        = string
}

# Tipo de instancia para Redis
variable "redis_instance_type" {
  description = "Tipo de instancia para Redis"
  type        = string
}

# Número de grupos de nodos (shards)
variable "redis_node_groups" {
  description = "Número de grupos de nodos (shards)"
  type        = number
}

# Número de réplicas por cada grupo de nodos
variable "redis_replicas_per_group" {
  description = "Número de réplicas por cada grupo de nodos"
  type        = number
}

# Habilitar conmutación por error automática en Redis
variable "redis_failover_enabled" {
  description = "Habilitar conmutación por error automática en Redis"
  type        = bool
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE RED
# ------------------------------------------------------------

# Lista de IDs de subnets privadas donde se desplegará Redis
variable "private_subnet_ids" {
  description = "Lista de IDs de subnets privadas donde se desplegará Redis"
  type        = list(string)
}

# Nombre del grupo de subnets para Redis
variable "redis_subnet_group_name" {
  description = "Nombre del grupo de subnets para Redis"
  type        = string
}

# ID del Security Group para Redis
variable "redis_security_group_id" {
  description = "ID del Security Group para Redis"
  type        = string
}

# ------------------------------------------------------------
# CONFIGURACIÓN DE ETIQUETAS (TAGS)
# ------------------------------------------------------------

# Etiquetas para los recursos
variable "tags" {
  description = "Tags aplicados a todos los recursos creados"
  type        = map(string)
}