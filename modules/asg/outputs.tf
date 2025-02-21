# ==============================================
# OUTPUTS DEL MÓDULO ASG
# ==============================================

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

output "asg_arn" {
  description = "ARN del Auto Scaling Group"
  value       = aws_autoscaling_group.asg.arn
}

output "launch_template_id" {
  description = "ID del Launch Template"
  value       = aws_launch_template.asg_lt.id
}

output "target_group_arn" {
  description = "ARN del Target Group"
  value       = aws_lb_target_group.asg_tg.arn
}
