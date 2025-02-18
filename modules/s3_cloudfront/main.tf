# ======================================================================================
# MÓDULO S3 + CLOUDFRONT
# ======================================================================================
# Este módulo crea:
# - Un bucket S3 privado para almacenar imágenes estáticas.
# - Una distribución de CloudFront para servir las imágenes de forma optimizada.
# - Configuración de Origin Access Control (OAC) para restringir acceso directo.
# - Configuración opcional para permitir la destrucción del bucket con `force_destroy`.
# =======================================================================================

# -------------------------------------------------------------
# CREACIÓN DEL BUCKET S3
# force_destroy true, permite destruir el bucket con contenido
# -------------------------------------------------------------
resource "aws_s3_bucket" "images" {
  bucket        = var.s3_bucket_name
  force_destroy = var.force_destroy_s3

  tags = merge(var.tags, {
    Name = var.s3_bucket_name
  })
}

#-------------------------------------------
# Habilitar versión si está activado
#-------------------------------------------
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.images.id

  versioning_configuration {
    status = var.enable_s3_versioning ? "Enabled" : "Suspended"
  }
}

#-------------------------------------------
# Habilitar encriptación si está activado
#-------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count  = var.enable_s3_encryption ? 1 : 0
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------------------------------------------------------
# DATA SOURCE PARA OBTENER LA POLÍTICA DE CACHÉ PREDETERMINADA DE AWS
# ----------------------------------------------------------------------------
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

# ----------------------------------------------------------------------------
# CONFIGURACIÓN DE ORIGIN ACCESS CONTROL (OAC) PARA CLOUDFRONT
# ----------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "CloudFront-OAC-${var.s3_bucket_name}"
  description                       = "OAC para acceso seguro al bucket S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ----------------------------------------------------------------------------
# PERMISOS DEL BUCKET S3 PARA RESTRINGIR ACCESO DIRECTO
# ----------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.images.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.images.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront.arn
          }
        }
      }
    ]
  })
}

##################################################################################
#  OJO !!!! Este recurso se crea por fuera de Terraform 
##################################################################################
# ============================================================================
# OBTENER EL CERTIFICADO SSL DESDE ACM EN us-east-1
# ============================================================================

# Provider secundario: AWS en Virginia (us-east-1) para CloudFront y ACM
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_acm_certificate" "cdn_cert" {
  provider    = aws.virginia # Se obtiene el certificado desde us-east-1
  domain      = "*.jmbmcloud.com"
  most_recent = true
}

# ----------------------------------------------------------------------------
# CREACIÓN DE LA DISTRIBUCIÓN DE CLOUDFRONT
# ----------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "cloudfront" {
  enabled             = true
  price_class         = var.cloudfront_price_class
  default_root_object = "index.html"

  # Se añade el alias para el dominio personalizado
  aliases = ["cdn.jmbmcloud.com"]

  # Configuración del origen: el bucket S3
  origin {
    domain_name              = aws_s3_bucket.images.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3-${aws_s3_bucket.images.id}"
  }

  # Configuración de caché y acceso
  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.images.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = var.cloudfront_allowed_methods
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  # Configuración de certificado SSL por defecto
  viewer_certificate {
    # Se usa el certificado personalizado
    acm_certificate_arn      = data.aws_acm_certificate.cdn_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
    # Se mantiene el certificado predeterminado de CloudFront
    cloudfront_default_certificate = true
  }

  # Sin restricciones geográficas
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(var.tags, {
    Name = "CloudFront-${var.s3_bucket_name}"
  })
}
