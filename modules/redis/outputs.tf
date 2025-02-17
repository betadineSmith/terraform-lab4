# ==================================================================
# OUTPUTS DEL MÓDULO REDIS (CACHE)
# ==================================================================
# - Devuelve la URL de conexión del cluster Redis.
# - Devuelve el ARN del grupo de replicación.
# ==================================================================

# Endpoint de conexión a Redis (Primary Endpoint)
output "redis_endpoint" {
  description = "Primary Endpoint del cluster Redis"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

# ARN del grupo de replicación Redis
output "redis_arn" {
  description = "ARN del grupo de replicación Redis"
  value       = aws_elasticache_replication_group.redis.arn
}
