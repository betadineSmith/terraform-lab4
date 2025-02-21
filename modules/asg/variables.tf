# ==============================================
# VARIABLES DEL MÓDULO ASG
# ==============================================

variable "asg_name" {
  description = "Nombre del Auto Scaling Group"
  type        = string
}

variable "ami_id" {
  description = "ID de la AMI para el Launch Template"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Número mínimo de instancias en el ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Número deseado de instancias en el ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Número máximo de instancias en el ASG"
  type        = number
  default     = 4
}

variable "vpc_id" {
  description = "ID de la VPC donde se encuentra el ASG"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets donde se desplegarán las instancias del ASG"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de Security Groups para las instancias del ASG"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ARN del Listener HTTPS (443) del ALB"
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
  default     = {}
}