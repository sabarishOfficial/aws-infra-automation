output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnets" {
  value = [
    for subnets in aws_subnet.subnets_create : subnets
  ]
}