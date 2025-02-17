# ============================================================
# MÓDULO REDIS - IMPLEMENTACIÓN DE ELASTICACHE
# ============================================================
# Este módulo despliega un clúster de ElastiCache Redis con:
# - Un grupo de subnets para alojar la caché en redes privadas.
# - Un clúster Redis con un nodo primario y una réplica en 
#   una zona de disponibilidad diferente (Multi-AZ).
# - Integración con Security Groups para controlar el acceso.
# ============================================================

# CREAR EL GRUPO DE SUBNETS PARA ELASTICACHE
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.redis_subnet_group_name
  subnet_ids = var.private_subnet_ids # Asociamos las subnets privadas

  tags = merge(var.tags, {
    Name = var.redis_subnet_group_name
  })
}

# CREAR EL CLUSTER REDIS CON PRIMARY Y REPLICA
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = var.redis_cluster_id
  description                = "Cluster Redis con Primary y Replica"
  node_type                  = var.redis_instance_type
  engine                     = "redis"
  num_node_groups            = var.redis_node_groups
  replicas_per_node_group    = var.redis_replicas_per_group
  automatic_failover_enabled = var.redis_failover_enabled

  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [var.redis_security_group_id]

  tags = merge(var.tags, {
    Name = var.redis_cluster_id
  })
}
