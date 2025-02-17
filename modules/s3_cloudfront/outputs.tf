# ============================================================================
# OUTPUTS DEL MÓDULO S3 + CLOUDFRONT
# ============================================================================
# - Devuelve la URL de CloudFront para servir imágenes de forma optimizada.
# - Devuelve la URL del bucket S3 para subida de imágenes.
# - Devuelve el nombre del bucket S3.
# ============================================================================

# URL de la distribución de CloudFront
output "cloudfront_url" {
  description = "URL de la distribución CloudFront"
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}


# Endpoint del bucket S3 (para subir imágenes desde la aplicación)
output "s3_bucket_url" {
  description = "URL del bucket S3 donde se almacenan las imágenes"
  value       = aws_s3_bucket.images.bucket_regional_domain_name
}

# Nombre del bucket S3
output "s3_bucket_name" {
  description = "Nombre del bucket S3 donde se almacenan las imágenes"
  value       = aws_s3_bucket.images.id
}
