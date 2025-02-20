variable "namespace" {
  description = "Nombre del namespace en Route 53 para Service Discovery"
  type        = string
  default     = "lab4.local"
}

variable "vpc_id" {
  description = "ID de la VPC donde se creará el namespace privado"
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
  default     = {}
}
