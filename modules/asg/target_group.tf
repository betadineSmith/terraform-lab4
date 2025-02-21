# ==============================================
# TARGET GROUP PARA EL ALB
# ==============================================

resource "aws_lb_target_group" "asg_tg" {
  name        = "${var.asg_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.asg_name}-tg"
  })
}
