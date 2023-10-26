# office ip security groups
output "office_ips" {
  value = aws_security_group.office_ip.id
}
# server security group
output "server_security_group" {
  value = aws_security_group.servers.id
}