# Crear la VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "lab4-vpc"
  })
}

# Crear Subnets Públicas
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "lab4-public-subnet-${count.index + 1}"
  })
}

# Crear Subnets Privadas
resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "lab4-private-subnet-${count.index + 1}"
  })
}

# Crear Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "lab4-igw"
  })
}

# Crear NAT Gateway en cada Subnet Pública
resource "aws_eip" "nat" {
  count = length(var.public_subnets)

  tags = merge(var.tags, {
    Name = "lab4-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    Name = "lab4-nat-gateway-${count.index + 1}"
  })
}

# Crear una tabla de rutas por cada Subnet Pública
resource "aws_route_table" "public" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "lab4-public-route-table-${count.index + 1}"
  })
}

# Crear una ruta `0.0.0.0/0` en cada tabla de rutas, apuntando al IGW
resource "aws_route" "public_internet_access" {
  count                  = length(var.public_subnets)
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Asociar cada Subnet Pública con su propia Tabla de Rutas
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}


# Crear Tablas de Rutas Privadas (1 por NAT Gateway)
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "lab4-private-route-table-${count.index + 1}"
  })
}

# Crear una ruta `0.0.0.0/0` en cada tabla de rutas, apuntando al NAT correspondiente
resource "aws_route" "private_nat_access" {
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

# Asociar cada Subnet Privada con su propia Tabla de Rutas
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
