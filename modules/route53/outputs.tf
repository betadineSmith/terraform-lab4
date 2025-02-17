# =============================================================
# OUTPUTS DEL MÓDULO ROUTE 53 (ZONA PRIVADA Y REGISTROS DNS)
# =============================================================
# - Se expone el ID de la zona privada creada en Route 53.
# - Se exponen los nombres DNS simplificados para:
#     - RDS PostgreSQL (sin puerto)
#     - ElasticCache Redis (Primary y Read Replica)
#     - Elastic File System (EFS)
# =============================================================

# ID de la zona privada Route 53
output "route53_zone_id" {
  description = "ID de la zona privada en Route 53"
  value       = aws_route53_zone.private_zone.zone_id
}

# Nombre DNS simplificado para RDS PostgreSQL
output "rds_dns" {
  description = "Nombre DNS simplificado para RDS PostgreSQL"
  value       = aws_route53_record.rds.name
}

# Nombre DNS simplificado para ElasticCache Redis (Primary)
output "redis_primary_dns" {
  description = "Nombre DNS simplificado para ElasticCache Redis (Primary)"
  value       = aws_route53_record.redis-primary.name
}

# Nombre DNS simplificado para ElasticCache Redis (Read Replica)
output "redis_reader_dns" {
  description = "Nombre DNS simplificado para ElasticCache Redis (Read Replica)"
  value       = aws_route53_record.redis-ro.name
}

# Nombre DNS simplificado para Elastic File System (EFS)
output "efs_dns" {
  description = "Nombre DNS simplificado para Elastic File System (EFS)"
  value       = aws_route53_record.efs.name
}
