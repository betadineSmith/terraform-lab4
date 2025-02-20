output "namespace_id" {
  description = "ARN del namespace de Service Discovery"
  value       = aws_service_discovery_private_dns_namespace.this.id
}
