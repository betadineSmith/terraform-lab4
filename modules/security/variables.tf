# ============================================================
# VARIABLES DEL MÓDULO SECURITY
# ============================================================
# Este módulo solo requiere dos variables de entrada:
#
# - vpc_id: Se usa para asociar los Security Groups a la VPC.
# - tags: Se aplican a todos los Security Groups creados.
# ============================================================

# ID de la VPC
variable "vpc_id" {
  description = "ID de la VPC donde se crearán los Security Groups"
  type        = string
}

# Etiquetas comunes
variable "tags" {
  description = "Etiquetas comunes para los Security Groups"
  type        = map(string)
}