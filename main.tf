module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block
}
module "security" {
  source     = "./modules/security_groups"
  vpc_sg     = module.vpc.vpc_id
  offices_ip = var.offices_ip
  server     = var.server_sg
}
module "server" {
  source = "./modules/instance/"
  key_name = var.key_name
  ec2_instance = var.ec2_instance
  security_groups = [module.security.office_ips, module.security.server_security_group]
  subnets_id = module.vpc.subnets
}