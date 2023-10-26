# This office server ip address and details
resource "aws_security_group" "office_ip" {
  vpc_id = var.vpc_sg
  description = "This for our office ip while list"

  dynamic "ingress" {
    for_each = var.offices_ip
    content {
      from_port = ingress.value.port == "" ? 0 : null
      to_port = ingress.value.port == "" ? 65535 : null
      description = ingress.value.description
      protocol = "TCP"
      cidr_blocks = [ingress.value.IP]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "office_ip's"
  }

}
# This server security groups
resource "aws_security_group" "servers" {
  vpc_id = var.vpc_sg
  description = "This security groups for servers"

  dynamic "ingress" {
    for_each = var.server
    content {
      from_port = ingress.value.port != "" ? ingress.value.port : 0
      to_port = ingress.value.port != "" ? ingress.value.port : 65535
      protocol = "TCP"
      description = ingress.value.descriptions
      cidr_blocks = ingress.value.IP != "" ? [ingress.value.IP] : null
      security_groups = ingress.value.IP == "" ? [aws_security_group.office_ip.id] : null
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "server_security_group"
  }
}