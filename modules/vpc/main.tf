# local variable for filter the values 
locals {
  keys_to_remove = toset(["vpc", "route_table"])
  all_subnets = {
    for key, value in var.cidr_block :
    key => value
    if !(contains(local.keys_to_remove, key))
  }
  public_subnets = [
    for id in aws_subnet.subnets_create : id.id if can(regex("public_subnet_", lookup(id.tags, "Name", "")))
  ]
  private_subnets = [
    for id in aws_subnet.subnets_create : id.id if can(regex("private_subnet_", lookup(id.tags, "Name", "")))
  ]
}
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = lookup(var.cidr_block.vpc, "cidr_block", null)
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc"
  }
}
# subnets private and public
resource "aws_subnet" "subnets_create" {
  for_each          = local.all_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}
# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet_gateway"
  }
}
#elastic ip for nat gateway
resource "aws_eip" "elastic_ip_nat_gateway" {
  domain = "vpc"

  tags = {
    Name = "nat_gateway"
  }
}
# nat gateway
resource "aws_nat_gateway" "private_nat_gateway" {
  subnet_id     = local.public_subnets[0]
  allocation_id = aws_eip.elastic_ip_nat_gateway.id
}
# Public Route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_block.route_table["cidr_block"]
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public_Route_table"
  }
}
# Private Route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_block.route_table["cidr_block"]
    gateway_id = aws_nat_gateway.private_nat_gateway.id
  }
  tags = {
    Name = "private_route_table"
  }
}
# route table public subnets association
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(local.public_subnets)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = element(local.public_subnets, count.index)
}
# route table private subnets association
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(local.private_subnets)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = element(local.private_subnets, count.index)
}
