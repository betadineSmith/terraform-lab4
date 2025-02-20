# ==============================================
# VARIABLES GENERALES PARA ECS FARGATE
# ==============================================
variable "ecs_cluster_name" {
  description = "Nombre del clúster ECS"
  type        = string
  default     = "lab4-ECS-Fargate"
}

variable "ecs_execution_role_arn" {
  description = "ARN del rol de ejecución de ECS"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN del rol de tarea de ECS"
  type        = string
}

variable "ecs_subnets" {
  description = "Lista de subnets privadas donde ECS desplegará tareas"
  type        = list(string)
}

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
  default     = {}
}

variable "service_discovery_namespace_id" {
  description = "ID del namespace de Service Discovery"
  type        = string
}

# ==============================================
# VARIABLES PARA MEMCACHED EN ECS FARGATE
# ==============================================
variable "services" {
  description = "Lista de servicios ECS a desplegar"
  type = map(object({
    cpu               = number
    memory            = number
    image             = string
    min_tasks         = number
    security_group_id = string
  }))
}
