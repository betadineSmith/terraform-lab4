
locals {
  tags = { for tag in jsondecode(file("${path.root}/tags.json")) : tag.Key => tag.Value }
}

module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = local.tags
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id  
  tags   = local.tags             
}