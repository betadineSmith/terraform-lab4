# ==================================================================
# OUTPUTS DEL MÓDULO REDIS (CACHE)
# ==================================================================
# - Devuelve la URL de conexión del cluster Redis.
# - Devuelve el ARN del grupo de replicación.
# ==================================================================
# Endpoint de conexión a Redis (Primary - Read/Write)
output "redis_primary_endpoint" {
  description = "Primary Endpoint del cluster Redis (Read/Write)"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

# Endpoint de conexión a Redis (Reader - Solo Lectura)
output "redis_reader_endpoint" {
  description = "Reader Endpoint del cluster Redis (Read Only)"
  value       = aws_elasticache_replication_group.redis.reader_endpoint_address
}
