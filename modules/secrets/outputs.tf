output "secret_name" {
  description = "Nombre del secreto en AWS Secrets Manager"
  value       = aws_secretsmanager_secret.drupal_secret.name
}