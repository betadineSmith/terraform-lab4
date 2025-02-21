# ==============================================
# LAUNCH TEMPLATE PARA EL ASG
# ==============================================

resource "aws_launch_template" "asg_lt" {
  name_prefix            = "${var.asg_name}-lt"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids

iam_instance_profile {
    name = "general-EC2-InsProfile"  # Instance Profile asignado
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.asg_name}-instance"
    })
  }
}
