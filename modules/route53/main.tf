# =======================================================================
# MÓDULO ROUTE 53 - CREACIÓN DE ZONA PRIVADA Y REGISTROS DNS
# =======================================================================
# - Se crea una zona privada en Route 53 dentro de la VPC.
# - Se configuran registros CNAME para:
#     - RDS PostgreSQL (quitando el puerto)
#     - ElasticCache Redis (Primary y Read Replica)
#     - Elastic File System (EFS)
# - Esta zona se utilizará para el descubrimiento de servicios en ECS.
# =======================================================================

# CREAR LA ZONA PRIVADA EN ROUTE 53
resource "aws_route53_zone" "private_zone" {
  name = var.private_zone_name
  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.tags, {
    Name = var.private_zone_name
  })
}

# =============================================================
# REGISTROS DNS PARA SERVICIOS AWS
# =============================================================

# CNAME para RDS PostgreSQL (sin puerto)
resource "aws_route53_record" "rds" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "rds.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [regex("^(.+):[0-9]+$", var.rds_endpoint)[0]]
}

# CNAME para ElasticCache Redis (Primary Endpoint)
resource "aws_route53_record" "redis-primary" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "redis.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.redis_primary_endpoint]
}

# CNAME para ElasticCache Redis (Read Replica)
resource "aws_route53_record" "redis-ro" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "redis-ro.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.redis_reader_endpoint]
}

# CNAME para Elastic File System (EFS)
resource "aws_route53_record" "efs" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "efs.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.efs_dns_name]
}

# CNAME Bucket S3
resource "aws_route53_record" "s3" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "s3.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.s3_dns_name]
}
