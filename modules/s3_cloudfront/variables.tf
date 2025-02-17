# =========================================================================================
# VARIABLES DEL MÓDULO S3 + CLOUDFRONT
# =========================================================================================
# - Se define un bucket S3 privado para almacenar imágenes estáticas.
# - Se crea una distribución CloudFront para servir las imágenes de forma rápida y segura.
# - Se usa Origin Access Control (OAC) para restringir el acceso a S3.
# ==========================================================================================

# -----------------------------------
# VARIABLES PARA S3 (ALMACENAMIENTO)
# -----------------------------------

# Nombre del bucket S3 (debe ser único en AWS)
variable "s3_bucket_name" {
  description = "Nombre del bucket S3 donde se almacenarán las imágenes"
  type        = string
}

# Activar o desactivar el versionado del bucket (false por defecto)
variable "enable_s3_versioning" {
  description = "Habilita o deshabilita el versionado en el bucket S3"
  type        = bool
}

# Activar o desactivar el cifrado de objetos en el bucket
variable "enable_s3_encryption" {
  description = "Activa el cifrado de los objetos almacenados en el bucket S3"
  type        = bool
}

# Si está en "true", permitirá borrar el bucket con su contenido.
variable "force_destroy_s3" {
  description = "Permitir eliminación del bucket con contenido"
  type        = bool
}

# --------------------------------
# VARIABLES PARA CLOUDFRONT (CDN)
# --------------------------------

# Clase de precio para la distribución de CloudFront (define regiones accesibles)
variable "cloudfront_price_class" {
  description = "Clase de precios de CloudFront para limitar regiones"
  type        = string
}

# Métodos HTTP permitidos en CloudFront
variable "cloudfront_allowed_methods" {
  description = "Métodos HTTP permitidos en la caché de CloudFront"
  type        = list(string)
}

# --------------------------
# VARIABLES GLOBALES (TAGS)
# --------------------------

# Tags globales para los recursos creados
variable "tags" {
  description = "Etiquetas comunes para todos los recursos"
  type        = map(string)
}
