# ==============================================
# AUTO SCALING GROUP (ASG)
# ==============================================

resource "aws_autoscaling_group" "asg" {
  name                = var.asg_name
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.asg_tg.arn]

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
