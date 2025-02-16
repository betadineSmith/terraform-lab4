variable "vpc_id" {
  description = "ID de la VPC donde se crearán los Security Groups"
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes para los Security Groups"
  type        = map(string)
}