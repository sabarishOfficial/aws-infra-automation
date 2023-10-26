# provider block variables
provider_block = {
  alias = "virginia"
  mu    = "ap-south-1"
  vg    = "us-east-1"
  access_key= ""
  secret_key = ""
}
# VPC
cidr_block = {
  vpc = {
    cidr_block = "10.0.0.0/16"
  },
  public_subnet_1 = {
    cidr_block = "10.0.1.0/24"
    az         = "ap-south-1a"
  },
  public_subnet_2 = {
    cidr_block = "10.0.2.0/24"
    az         = "ap-south-1b"
  },
  public_subnet_3 = {
    cidr_block = "10.0.3.0/24"
    az         = "ap-south-1c"
  },
  private_subnet_1 = {
    cidr_block = "10.0.4.0/24"
    az         = "ap-south-1a"
  },
  private_subnet_2 = {
    cidr_block = "10.0.5.0/24"
    az         = "ap-south-1b"
  },
  private_subnet_3 = {
    cidr_block = "10.0.6.0/24"
    az         = "ap-south-1c"
  },
  route_table = {
    cidr_block = "0.0.0.0/0"
  }
}

# security groups
offices_ip = {
  second_floor = {
    IP          = "181.83.23.53/32"
    port        = ""
    description = "all tcp allow in second_floor"
  }
}
# security groups for server
server_sg = {
  http = {
    port         = "80"
    IP           = "0.0.0.0/0"
    descriptions = "http web server"
  },
  https = {
    port         = "443"
    IP           = "0.0.0.0/0"
    descriptions = "https secure server connections"
  },
  security_groups = {
    port         = ""
    IP           = "" # this security groups reference another security group
    descriptions = "security group inter connect"
  }
}

# server variable values
ec2_instance = {
  dev = {
    ami           = "ami-0376ec8eacdf70aae"
    instance_type = "t2.micro"
  },
  jenkins = {
    ami           = "ami-0376ec8eacdf70aae"
    instance_type = "t2.micro"
  }
}

key_name = "sabarish"
