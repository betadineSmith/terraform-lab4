# ==============================================
# OUTPUT DEL CLUSTER
# ==============================================
output "ecs_cluster_id" {
  description = "ID del clúster ECS"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_arn" {
  description = "ARN del clúster ECS"
  value       = aws_ecs_cluster.this.arn
}
