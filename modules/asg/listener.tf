# ========================================================
# ASOCIAR EL TARGET GROUP AL LISTENER DEL ALB (443)
# ========================================================

resource "aws_lb_listener_rule" "asg_listener_rule" {
  listener_arn = var.alb_listener_arn # Listener HTTPS en 443
  priority     = 100                  # Se puede ajustar si hay más reglas

  condition {
    path_pattern {
      values = ["/*"] # Aplica la regla a todo el tráfico
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn # Se asocia al TG del ASG
  }

  tags = merge(var.tags, {
    Name = "${var.asg_name}-listener-rule"
  })
}
