# ==============================================================================
# REGLAS DE SEGURIDAD PARA EL SECURITY GROUP DEL ALB (Application Load Balancer)
# ==============================================================================

# PERMITIR HTTP (80) DESDE CUALQUIER LUGAR
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Permitir acceso desde cualquier IP
  security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR HTTPS (443) DESDE CUALQUIER LUGAR
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Permitir acceso desde cualquier IP
  security_group_id = aws_security_group.alb_sg.id
}

# PERMITIR TODO EL TRÁFICO DE SALIDA DESDE EL ALB
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Permitir todo tipo de tráfico
  cidr_blocks       = ["0.0.0.0/0"] # Habilitar tráfico de salida a cualquier destino
  security_group_id = aws_security_group.alb_sg.id
}
