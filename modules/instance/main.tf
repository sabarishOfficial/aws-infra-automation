# story the values reusable format and code simplify
locals {
  server = var.ec2_instance
  public_subnets = [
    for public_subnets in var.subnets_id : public_subnets.id if can(regex("public_subnet_", lookup(public_subnets.tags, "Name", "")))
  ]
  private_subnets = [
    for private_subnets in var.subnets_id : private_subnets.id if can(regex("private_subnet_", lookup(private_subnets.tags, "Name", "")))
  ]
}
# ssh key generate
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}
# public key push into aws console
resource "aws_key_pair" "key_pair" {
  public_key = tls_private_key.ssh_key.public_key_openssh
  key_name   = var.key_name
}
# private keyfile store into local machine
resource "local_file" "private_key" {
  filename = "${path.module}/${var.key_name}.pem"
  content  = tls_private_key.ssh_key.private_key_pem
}
# server creating it create default 2 instance and one for amazon-linux and ubuntu
resource "aws_instance" "server" {
  for_each               = local.server
  ami                    = each.value["ami"]
  instance_type          = each.value["instance_type"]
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = var.security_groups
  subnet_id              = each.key == "dev" ? local.public_subnets[0] : local.public_subnets[1]

  tags = {
    Name = each.key
  }
}
# local variable for elastic ip inputs
locals {
  instance_id = [
    for server in aws_instance.server : server.id
  ]
  eip_id = [
    for eip in aws_eip.server_ip : eip.id
  ]
}
# elastic ip for instance
resource "aws_eip" "server_ip" {
  count    = length(local.instance_id)
  instance = element(local.instance_id, count.index)
  domain   = "vpc"

  tags = {
    Name = element([for tag in aws_instance.server : tag.tags.Name], count.index)
  }

}

resource "null_resource" "setup" {
  depends_on = [
    aws_instance.server,
    aws_eip.server_ip,
    aws_key_pair.key_pair
  ]
  provisioner "local-exec" {
    command = <<EOT
      chmod 400 ${path.module}/${var.key_name}.pem
      ansible-playbook -u ubuntu -i ${aws_eip.server_ip[0].public_ip}, --private-key ${path.module}/${var.key_name}.pem ${path.module}/ansible-lemp-installation/lemp-server.yaml
    EOT
  }

  triggers = {
    key = "${path.module}/ansible-lemp-installation/lemp-server/tasks/main.yml"
  }
}