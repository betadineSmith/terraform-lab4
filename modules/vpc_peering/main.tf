# ========================================
# CREACIÓN DEL VPC PEERING
# ========================================
resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_id      # ID de la VPC principal
  peer_vpc_id = var.peer_vpc_id # ID de la VPC secundaria (Backup)
  auto_accept = var.auto_accept # Se acepta automáticamente el peering si ambas VPCs están en la misma cuenta

  tags = merge(var.tags, { Name = "vpc-peering-${var.vpc_id}-${var.peer_vpc_id}" })
}

# =================================================
# CONFIGURACIÓN DE RUTAS EN LA VPC PRINCIPAL
# =================================================
resource "aws_route" "peering_route_main" {
  count = length(var.route_table_ids_main) # Se iteran las tablas de rutas de la VPC principal  

  route_table_id            = var.route_table_ids_main[count.index] # ID de la tabla de rutas
  destination_cidr_block    = var.peer_vpc_cidr                     # CIDR de la VPC de backup para enrutar tráfico
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id    # Se asocia la conexión de peering
}

# =================================================
# CONFIGURACIÓN DE RUTAS EN LA VPC DE BACKUP
# =================================================
resource "aws_route" "peering_route_peer" {
  count = length(var.route_table_ids_peer) # Se iteran las tablas de rutas de la VPC de backup

  route_table_id            = var.route_table_ids_peer[count.index] # ID de la tabla de rutas
  destination_cidr_block    = var.vpc_cidr                          # CIDR de la VPC principal para enrutar tráfico
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id    # Se asocia la conexión de peering
}
