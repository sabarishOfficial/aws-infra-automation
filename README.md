
# Terraform Best Practices

## Project overview: 

This project creates one VPC, three public and private subnets, three private and public route tables, and two security groups. It also uses this technology in its child modules, congurations management tool using ansible and we intergate terraform, ansiable 

## Technologies Used

-  Terraform: Infrastructure as Code (IaC) tool used for provisioning and managing cloud resources.
- Ansible: Configuration management tool used for automating software provisioning, configuration management, and application deployment.

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform
- Ansible

## Additional Details

For a deeper understanding of how Ansible creates and configures resources, please refer to the [ansible-lemp-installation](https://github.com/sabarishOfficial/ansible-lemp-installation) project. It provides comprehensive documentation and examples for Ansible usage.

## Infra

- VPC
- Security Groups
- EC2-Instance


## Project Structure:



```bash
.
├── README.md
├── ansible.cfg
├── main.tf
├── modules
│   ├── instance
│   │   ├── ansible-lemp-installation
│   │   │   ├── README.md
│   │   │   ├── inventroy
│   │   │   ├── lemp-server
│   │   │   │   ├── defaults
│   │   │   │   │   └── main.yml
│   │   │   │   ├── files
│   │   │   │   │   └── main.yml
│   │   │   │   ├── handlers
│   │   │   │   │   └── main.yml
│   │   │   │   ├── meta
│   │   │   │   │   └── main.yml
│   │   │   │   ├── tasks
│   │   │   │   │   └── main.yml
│   │   │   │   ├── templates
│   │   │   │   │   └── server.conf
│   │   │   │   ├── tests
│   │   │   │   │   └── test.yml
│   │   │   │   └── vars
│   │   │   │       └── main.yml
│   │   │   └── lemp-server.yaml
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── var.tf
│   ├── security_groups
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── var.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       └── var.tf
├── output.tf
├── provider.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
└── var.tf

15 directories, 29 files
```

## Terraform variable files


```bash
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
    IP          = "193.802.23.34/32" # I'll give you an example of how to reach the server using SSH if you have a static IP. 
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
    IP           = "" # One security group is mentioned in this one.
    descriptions = "security group internal connect"
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

key_name = "" # Key name 
```

## Note

Ensure that you adhere to the existing key names while adding IP and Infra, rather than altering the key.



## Running Steps

```bash
git clone https://github.com/Sabarish-Sudalaimuthu/aws-infra-automation.git

cd aws-infra-automation
```

## Project Folder Structure:

## terraform init 
```bash
sabarish@Sabarishs-MacBook-Air infra % terraform init

Initializing the backend...
Initializing modules...
- security in modules/security_groups
- server in modules/instance
- vpc in modules/vpc

Initializing provider plugins...
- Reusing previous version of hashicorp/local from the dependency lock file
- Reusing previous version of hashicorp/tls from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v5.19.0...
- Installed hashicorp/aws v5.19.0 (signed by HashiCorp)
- Installing hashicorp/local v2.4.0...
- Installed hashicorp/local v2.4.0 (signed by HashiCorp)
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## terraform validate syntax check
```bash
sabarish@Sabarishs-MacBook-Air infra % terraform validate
Success! The configuration is valid.
```
## terraform plan
```bash
sabarish@Sabarishs-MacBook-Air infra % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # module.security.aws_security_group.office_ip will be created
  + resource "aws_security_group" "office_ip" {
      + arn                    = (known after apply)
      + description            = "This for our office ip while list"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "181.83.23.53/32",
                ]
              + description      = "all tcp allow in second_floor"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "office_ip's"
        }
      + tags_all               = {
          + "Name" = "office_ip's"
        }
      + vpc_id                 = (known after apply)
    }

  # module.security.aws_security_group.servers will be created
  + resource "aws_security_group" "servers" {
      + arn                    = (known after apply)
      + description            = "This security groups for servers"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "http web server"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "https secure server connections"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "security group inter connect"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "server_security_group"
        }
      + tags_all               = {
          + "Name" = "server_security_group"
        }
      + vpc_id                 = (known after apply)
    }

  # module.server.aws_eip.server_ip[0] will be created
  + resource "aws_eip" "server_ip" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "dev"
        }
      + tags_all             = {
          + "Name" = "dev"
        }
      + vpc                  = (known after apply)
    }

  # module.server.aws_eip.server_ip[1] will be created
  + resource "aws_eip" "server_ip" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "jenkins"
        }
      + tags_all             = {
          + "Name" = "jenkins"
        }
      + vpc                  = (known after apply)
    }

  # module.server.aws_instance.server["dev"] will be created
  + resource "aws_instance" "server" {
      + ami                                  = "ami-0376ec8eacdf70aae"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "sabarish"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "dev"
        }
      + tags_all                             = {
          + "Name" = "dev"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # module.server.aws_instance.server["jenkins"] will be created
  + resource "aws_instance" "server" {
      + ami                                  = "ami-0376ec8eacdf70aae"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "sabarish"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "jenkins"
        }
      + tags_all                             = {
          + "Name" = "jenkins"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # module.server.aws_key_pair.key_pair will be created
  + resource "aws_key_pair" "key_pair" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "sabarish"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + key_type        = (known after apply)
      + public_key      = (known after apply)
      + tags_all        = (known after apply)
    }

  # module.server.local_file.private_key will be created
  + resource "local_file" "private_key" {
      + content              = (sensitive value)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "modules/instance/sabarish.pem"
      + id                   = (known after apply)
    }

  # module.server.tls_private_key.ssh_key will be created
  + resource "tls_private_key" "ssh_key" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 2048
    }

  # module.vpc.aws_eip.elastic_ip_nat_gateway will be created
  + resource "aws_eip" "elastic_ip_nat_gateway" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "nat_gateway"
        }
      + tags_all             = {
          + "Name" = "nat_gateway"
        }
      + vpc                  = (known after apply)
    }

  # module.vpc.aws_internet_gateway.internet_gateway will be created
  + resource "aws_internet_gateway" "internet_gateway" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "internet_gateway"
        }
      + tags_all = {
          + "Name" = "internet_gateway"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc.aws_nat_gateway.private_nat_gateway will be created
  + resource "aws_nat_gateway" "private_nat_gateway" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags_all                           = (known after apply)
    }

  # module.vpc.aws_route_table.private_route_table will be created
  + resource "aws_route_table" "private_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "private_route_table"
        }
      + tags_all         = {
          + "Name" = "private_route_table"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.public_route_table will be created
  + resource "aws_route_table" "public_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "Public_Route_table"
        }
      + tags_all         = {
          + "Name" = "Public_Route_table"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[0] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[1] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[2] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[0] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[1] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[2] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_1"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_1"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_2"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.5.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_2"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_3"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.6.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_3"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_3"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_1"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_1"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_2"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_2"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_3"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_3"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_3"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "vpc"
        }
      + tags_all                             = {
          + "Name" = "vpc"
        }
    }

Plan: 27 to add, 0 to change, 0 to destroy.
```
## terraform apply 
```bash
sabarish@Sabarishs-MacBook-Air infra % terraform apply         

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # module.security.aws_security_group.office_ip will be created
  + resource "aws_security_group" "office_ip" {
      + arn                    = (known after apply)
      + description            = "This for our office ip while list"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "181.83.23.53/32",
                ]
              + description      = "all tcp allow in second_floor"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "office_ip's"
        }
      + tags_all               = {
          + "Name" = "office_ip's"
        }
      + vpc_id                 = (known after apply)
    }

  # module.security.aws_security_group.servers will be created
  + resource "aws_security_group" "servers" {
      + arn                    = (known after apply)
      + description            = "This security groups for servers"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "http web server"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "https secure server connections"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = []
              + description      = "security group inter connect"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "server_security_group"
        }
      + tags_all               = {
          + "Name" = "server_security_group"
        }
      + vpc_id                 = (known after apply)
    }

  # module.server.aws_eip.server_ip[0] will be created
  + resource "aws_eip" "server_ip" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "dev"
        }
      + tags_all             = {
          + "Name" = "dev"
        }
      + vpc                  = (known after apply)
    }

  # module.server.aws_eip.server_ip[1] will be created
  + resource "aws_eip" "server_ip" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "jenkins"
        }
      + tags_all             = {
          + "Name" = "jenkins"
        }
      + vpc                  = (known after apply)
    }

  # module.server.aws_instance.server["dev"] will be created
  + resource "aws_instance" "server" {
      + ami                                  = "ami-0376ec8eacdf70aae"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "sabarish"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "dev"
        }
      + tags_all                             = {
          + "Name" = "dev"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # module.server.aws_instance.server["jenkins"] will be created
  + resource "aws_instance" "server" {
      + ami                                  = "ami-0376ec8eacdf70aae"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "sabarish"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "jenkins"
        }
      + tags_all                             = {
          + "Name" = "jenkins"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # module.server.aws_key_pair.key_pair will be created
  + resource "aws_key_pair" "key_pair" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "sabarish"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + key_type        = (known after apply)
      + public_key      = (known after apply)
      + tags_all        = (known after apply)
    }

  # module.server.local_file.private_key will be created
  + resource "local_file" "private_key" {
      + content              = (sensitive value)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "modules/instance/sabarish.pem"
      + id                   = (known after apply)
    }

  # module.server.tls_private_key.ssh_key will be created
  + resource "tls_private_key" "ssh_key" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 2048
    }

  # module.vpc.aws_eip.elastic_ip_nat_gateway will be created
  + resource "aws_eip" "elastic_ip_nat_gateway" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "nat_gateway"
        }
      + tags_all             = {
          + "Name" = "nat_gateway"
        }
      + vpc                  = (known after apply)
    }

  # module.vpc.aws_internet_gateway.internet_gateway will be created
  + resource "aws_internet_gateway" "internet_gateway" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "internet_gateway"
        }
      + tags_all = {
          + "Name" = "internet_gateway"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc.aws_nat_gateway.private_nat_gateway will be created
  + resource "aws_nat_gateway" "private_nat_gateway" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags_all                           = (known after apply)
    }

  # module.vpc.aws_route_table.private_route_table will be created
  + resource "aws_route_table" "private_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "private_route_table"
        }
      + tags_all         = {
          + "Name" = "private_route_table"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.public_route_table will be created
  + resource "aws_route_table" "public_route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "Public_Route_table"
        }
      + tags_all         = {
          + "Name" = "Public_Route_table"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[0] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[1] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[2] will be created
  + resource "aws_route_table_association" "private_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[0] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[1] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[2] will be created
  + resource "aws_route_table_association" "public_subnet_associations" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_1"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_1"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_2"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.5.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_2"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_3"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.6.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_3"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_3"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_1"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_1"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_2"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_2"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_3"] will be created
  + resource "aws_subnet" "subnets_create" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-south-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_3"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_3"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "vpc"
        }
      + tags_all                             = {
          + "Name" = "vpc"
        }
    }

Plan: 27 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.server.tls_private_key.ssh_key: Creating...
module.server.tls_private_key.ssh_key: Creation complete after 1s [id=291199b74778da0e765d1d31a46ea95e557048bb]
module.server.local_file.private_key: Creating...
module.server.local_file.private_key: Creation complete after 0s [id=44b439e3f48a06fb76f79412c47420b3a3daa6fe]
module.server.aws_key_pair.key_pair: Creating...
module.vpc.aws_eip.elastic_ip_nat_gateway: Creating...
module.vpc.aws_vpc.vpc: Creating...
module.server.aws_key_pair.key_pair: Creation complete after 0s [id=sabarish]
module.vpc.aws_eip.elastic_ip_nat_gateway: Creation complete after 0s [id=eipalloc-0ab4091cf11c5ab65]
module.vpc.aws_vpc.vpc: Still creating... [10s elapsed]
module.vpc.aws_vpc.vpc: Creation complete after 11s [id=vpc-00aa40fa96183caf2]
module.vpc.aws_subnet.subnets_create["private_subnet_1"]: Creating...
module.vpc.aws_subnet.subnets_create["public_subnet_2"]: Creating...
module.vpc.aws_subnet.subnets_create["public_subnet_1"]: Creating...
module.vpc.aws_internet_gateway.internet_gateway: Creating...
module.vpc.aws_subnet.subnets_create["public_subnet_3"]: Creating...
module.vpc.aws_subnet.subnets_create["private_subnet_2"]: Creating...
module.vpc.aws_subnet.subnets_create["private_subnet_3"]: Creating...
module.security.aws_security_group.office_ip: Creating...
module.vpc.aws_subnet.subnets_create["private_subnet_3"]: Creation complete after 1s [id=subnet-0ce27769cc1a078ed]
module.vpc.aws_subnet.subnets_create["public_subnet_1"]: Creation complete after 1s [id=subnet-0858691855ed77b19]
module.vpc.aws_subnet.subnets_create["private_subnet_1"]: Creation complete after 1s [id=subnet-0262d5d1e4b10c549]
module.vpc.aws_subnet.subnets_create["private_subnet_2"]: Creation complete after 1s [id=subnet-029b13d45756bd31b]
module.vpc.aws_subnet.subnets_create["public_subnet_3"]: Creation complete after 1s [id=subnet-01e13549e078dcc4e]
module.vpc.aws_subnet.subnets_create["public_subnet_2"]: Creation complete after 1s [id=subnet-07b83e52d4990edfa]
module.vpc.aws_internet_gateway.internet_gateway: Creation complete after 1s [id=igw-03a95bb51bc3ab15d]
module.vpc.aws_nat_gateway.private_nat_gateway: Creating...
module.vpc.aws_route_table.public_route_table: Creating...
module.vpc.aws_route_table.public_route_table: Creation complete after 1s [id=rtb-0dfb66449d17c4c39]
module.vpc.aws_route_table_association.public_subnet_associations[0]: Creating...
module.vpc.aws_route_table_association.public_subnet_associations[1]: Creating...
module.vpc.aws_route_table_association.public_subnet_associations[2]: Creating...
module.vpc.aws_route_table_association.public_subnet_associations[2]: Creation complete after 0s [id=rtbassoc-0fa4d0f4b287adf5e]
module.vpc.aws_route_table_association.public_subnet_associations[0]: Creation complete after 0s [id=rtbassoc-062bebd26baf4b28e]
module.security.aws_security_group.office_ip: Creation complete after 2s [id=sg-08369472fd1506772]
module.security.aws_security_group.servers: Creating...
module.vpc.aws_route_table_association.public_subnet_associations[1]: Creation complete after 0s [id=rtbassoc-0b4499f23e51cf91c]
module.security.aws_security_group.servers: Creation complete after 2s [id=sg-04c4c2319d3ab1941]
module.server.aws_instance.server["jenkins"]: Creating...
module.server.aws_instance.server["dev"]: Creating...
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [10s elapsed]
module.server.aws_instance.server["jenkins"]: Still creating... [10s elapsed]
module.server.aws_instance.server["dev"]: Still creating... [10s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [20s elapsed]
module.server.aws_instance.server["dev"]: Still creating... [20s elapsed]
module.server.aws_instance.server["jenkins"]: Still creating... [20s elapsed]
module.server.aws_instance.server["jenkins"]: Creation complete after 21s [id=i-05f2403f22c43c550]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [30s elapsed]
module.server.aws_instance.server["dev"]: Still creating... [30s elapsed]
module.server.aws_instance.server["dev"]: Creation complete after 31s [id=i-0bcd97762b62ab54e]
module.server.aws_eip.server_ip[0]: Creating...
module.server.aws_eip.server_ip[1]: Creating...
module.server.aws_eip.server_ip[0]: Creation complete after 2s [id=eipalloc-0881b75bced54e361]
module.server.aws_eip.server_ip[1]: Creation complete after 2s [id=eipalloc-0f2cbf67a27e26501]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [40s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [50s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [1m0s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [1m10s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [1m20s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still creating... [1m30s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Creation complete after 1m34s [id=nat-0abde69905664bcee]
module.vpc.aws_route_table.private_route_table: Creating...
module.vpc.aws_route_table.private_route_table: Creation complete after 1s [id=rtb-0e520f98380fffe58]
module.vpc.aws_route_table_association.private_subnet_associations[0]: Creating...
module.vpc.aws_route_table_association.private_subnet_associations[2]: Creating...
module.vpc.aws_route_table_association.private_subnet_associations[1]: Creating...
module.vpc.aws_route_table_association.private_subnet_associations[2]: Creation complete after 0s [id=rtbassoc-092c40df85e43ad4a]
module.vpc.aws_route_table_association.private_subnet_associations[0]: Creation complete after 0s [id=rtbassoc-0a542bfbc43c6f47c]
module.vpc.aws_route_table_association.private_subnet_associations[1]: Creation complete after 0s [id=rtbassoc-0555bf800fded6906]

Apply complete! Resources: 27 added, 0 changed, 0 destroyed.
```
## terraform destroy 
```bash
sabarish@Sabarishs-MacBook-Air infra % terraform destroy        
module.server.tls_private_key.ssh_key: Refreshing state... [id=291199b74778da0e765d1d31a46ea95e557048bb]
module.server.local_file.private_key: Refreshing state... [id=44b439e3f48a06fb76f79412c47420b3a3daa6fe]
module.server.aws_key_pair.key_pair: Refreshing state... [id=sabarish]
module.vpc.aws_eip.elastic_ip_nat_gateway: Refreshing state... [id=eipalloc-0ab4091cf11c5ab65]
module.vpc.aws_vpc.vpc: Refreshing state... [id=vpc-00aa40fa96183caf2]
module.vpc.aws_internet_gateway.internet_gateway: Refreshing state... [id=igw-03a95bb51bc3ab15d]
module.vpc.aws_subnet.subnets_create["private_subnet_2"]: Refreshing state... [id=subnet-029b13d45756bd31b]
module.vpc.aws_subnet.subnets_create["private_subnet_1"]: Refreshing state... [id=subnet-0262d5d1e4b10c549]
module.vpc.aws_subnet.subnets_create["public_subnet_3"]: Refreshing state... [id=subnet-01e13549e078dcc4e]
module.vpc.aws_subnet.subnets_create["public_subnet_2"]: Refreshing state... [id=subnet-07b83e52d4990edfa]
module.vpc.aws_subnet.subnets_create["private_subnet_3"]: Refreshing state... [id=subnet-0ce27769cc1a078ed]
module.vpc.aws_subnet.subnets_create["public_subnet_1"]: Refreshing state... [id=subnet-0858691855ed77b19]
module.security.aws_security_group.office_ip: Refreshing state... [id=sg-08369472fd1506772]
module.vpc.aws_route_table.public_route_table: Refreshing state... [id=rtb-0dfb66449d17c4c39]
module.security.aws_security_group.servers: Refreshing state... [id=sg-04c4c2319d3ab1941]
module.vpc.aws_route_table_association.public_subnet_associations[1]: Refreshing state... [id=rtbassoc-0b4499f23e51cf91c]
module.vpc.aws_route_table_association.public_subnet_associations[2]: Refreshing state... [id=rtbassoc-0fa4d0f4b287adf5e]
module.vpc.aws_route_table_association.public_subnet_associations[0]: Refreshing state... [id=rtbassoc-062bebd26baf4b28e]
module.vpc.aws_nat_gateway.private_nat_gateway: Refreshing state... [id=nat-0abde69905664bcee]
module.vpc.aws_route_table.private_route_table: Refreshing state... [id=rtb-0e520f98380fffe58]
module.server.aws_instance.server["dev"]: Refreshing state... [id=i-0bcd97762b62ab54e]
module.server.aws_instance.server["jenkins"]: Refreshing state... [id=i-05f2403f22c43c550]
module.vpc.aws_route_table_association.private_subnet_associations[0]: Refreshing state... [id=rtbassoc-0a542bfbc43c6f47c]
module.vpc.aws_route_table_association.private_subnet_associations[1]: Refreshing state... [id=rtbassoc-0555bf800fded6906]
module.vpc.aws_route_table_association.private_subnet_associations[2]: Refreshing state... [id=rtbassoc-092c40df85e43ad4a]
module.server.aws_eip.server_ip[0]: Refreshing state... [id=eipalloc-0881b75bced54e361]
module.server.aws_eip.server_ip[1]: Refreshing state... [id=eipalloc-0f2cbf67a27e26501]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

Terraform will perform the following actions:

  # module.security.aws_security_group.office_ip will be destroyed
  - resource "aws_security_group" "office_ip" {
      - arn                    = "arn:aws:ec2:ap-south-1:483008991703:security-group/sg-08369472fd1506772" -> null
      - description            = "This for our office ip while list" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 0
              - ipv6_cidr_blocks = [
                  - "::/0",
                ]
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
            },
        ] -> null
      - id                     = "sg-08369472fd1506772" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "181.83.23.53/32",
                ]
              - description      = "all tcp allow in second_floor"
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 65535
            },
        ] -> null
      - name                   = "terraform-20231026120505211400000001" -> null
      - name_prefix            = "terraform-" -> null
      - owner_id               = "483008991703" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Name" = "office_ip's"
        } -> null
      - tags_all               = {
          - "Name" = "office_ip's"
        } -> null
      - vpc_id                 = "vpc-00aa40fa96183caf2" -> null
    }

  # module.security.aws_security_group.servers will be destroyed
  - resource "aws_security_group" "servers" {
      - arn                    = "arn:aws:ec2:ap-south-1:483008991703:security-group/sg-04c4c2319d3ab1941" -> null
      - description            = "This security groups for servers" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 0
              - ipv6_cidr_blocks = [
                  - "::/0",
                ]
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
            },
        ] -> null
      - id                     = "sg-04c4c2319d3ab1941" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "http web server"
              - from_port        = 80
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 80
            },
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "https secure server connections"
              - from_port        = 443
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 443
            },
          - {
              - cidr_blocks      = []
              - description      = "security group inter connect"
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = [
                  - "sg-08369472fd1506772",
                ]
              - self             = false
              - to_port          = 65535
            },
        ] -> null
      - name                   = "terraform-20231026120507109400000003" -> null
      - name_prefix            = "terraform-" -> null
      - owner_id               = "483008991703" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Name" = "server_security_group"
        } -> null
      - tags_all               = {
          - "Name" = "server_security_group"
        } -> null
      - vpc_id                 = "vpc-00aa40fa96183caf2" -> null
    }

  # module.server.aws_eip.server_ip[0] will be destroyed
  - resource "aws_eip" "server_ip" {
      - allocation_id        = "eipalloc-0881b75bced54e361" -> null
      - association_id       = "eipassoc-024a8fce5628824ea" -> null
      - domain               = "vpc" -> null
      - id                   = "eipalloc-0881b75bced54e361" -> null
      - instance             = "i-0bcd97762b62ab54e" -> null
      - network_border_group = "ap-south-1" -> null
      - network_interface    = "eni-0b8f86c5225d88824" -> null
      - private_dns          = "ip-10-0-1-132.ap-south-1.compute.internal" -> null
      - private_ip           = "10.0.1.132" -> null
      - public_dns           = "ec2-3-6-118-170.ap-south-1.compute.amazonaws.com" -> null
      - public_ip            = "3.6.118.170" -> null
      - public_ipv4_pool     = "amazon" -> null
      - tags                 = {
          - "Name" = "dev"
        } -> null
      - tags_all             = {
          - "Name" = "dev"
        } -> null
      - vpc                  = true -> null
    }

  # module.server.aws_eip.server_ip[1] will be destroyed
  - resource "aws_eip" "server_ip" {
      - allocation_id        = "eipalloc-0f2cbf67a27e26501" -> null
      - association_id       = "eipassoc-0a1178eb19b6a625f" -> null
      - domain               = "vpc" -> null
      - id                   = "eipalloc-0f2cbf67a27e26501" -> null
      - instance             = "i-05f2403f22c43c550" -> null
      - network_border_group = "ap-south-1" -> null
      - network_interface    = "eni-0c1ebda4ba2000e57" -> null
      - private_dns          = "ip-10-0-2-90.ap-south-1.compute.internal" -> null
      - private_ip           = "10.0.2.90" -> null
      - public_dns           = "ec2-13-200-109-230.ap-south-1.compute.amazonaws.com" -> null
      - public_ip            = "13.200.109.230" -> null
      - public_ipv4_pool     = "amazon" -> null
      - tags                 = {
          - "Name" = "jenkins"
        } -> null
      - tags_all             = {
          - "Name" = "jenkins"
        } -> null
      - vpc                  = true -> null
    }

  # module.server.aws_instance.server["dev"] will be destroyed
  - resource "aws_instance" "server" {
      - ami                                  = "ami-0376ec8eacdf70aae" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:483008991703:instance/i-0bcd97762b62ab54e" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0bcd97762b62ab54e" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "sabarish" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0b8f86c5225d88824" -> null
      - private_dns                          = "ip-10-0-1-132.ap-south-1.compute.internal" -> null
      - private_ip                           = "10.0.1.132" -> null
      - public_dns                           = "ec2-3-6-118-170.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "3.6.118.170" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0858691855ed77b19" -> null
      - tags                                 = {
          - "Name" = "dev"
        } -> null
      - tags_all                             = {
          - "Name" = "dev"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-04c4c2319d3ab1941",
          - "sg-08369472fd1506772",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0c55261032c26c590" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
        }
    }

  # module.server.aws_instance.server["jenkins"] will be destroyed
  - resource "aws_instance" "server" {
      - ami                                  = "ami-0376ec8eacdf70aae" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:483008991703:instance/i-05f2403f22c43c550" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1b" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-05f2403f22c43c550" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "sabarish" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0c1ebda4ba2000e57" -> null
      - private_dns                          = "ip-10-0-2-90.ap-south-1.compute.internal" -> null
      - private_ip                           = "10.0.2.90" -> null
      - public_dns                           = "ec2-13-200-109-230.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "13.200.109.230" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-07b83e52d4990edfa" -> null
      - tags                                 = {
          - "Name" = "jenkins"
        } -> null
      - tags_all                             = {
          - "Name" = "jenkins"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-04c4c2319d3ab1941",
          - "sg-08369472fd1506772",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0059310c51e00d67b" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
        }
    }

  # module.server.aws_key_pair.key_pair will be destroyed
  - resource "aws_key_pair" "key_pair" {
      - arn         = "arn:aws:ec2:ap-south-1:483008991703:key-pair/sabarish" -> null
      - fingerprint = "ad:cc:46:69:1d:63:ce:22:61:ec:a0:ad:61:da:06:72" -> null
      - id          = "sabarish" -> null
      - key_name    = "sabarish" -> null
      - key_pair_id = "key-01c21adb37736c129" -> null
      - key_type    = "rsa" -> null
      - public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5JHP4zKqzhkkJKht3+MkJDq1nRUUsTTWUxjj0lJxbdsbmVr97PR5eailvkwkrxvDnnO/zioCZRJkAoTrNI7PJlNym0myDC9EhDVCu6+nbWxIEH6FPlEcdzwKVznJils0EcRePzQKBXqkNNsWKzji0BZpMP7ytIVrm0ezqvTG3+3svs4L139UghDwcDPNqKeFNehMPQVw/eohvwUirHEk7zF2L4sbc4JilFg1H8ULJ35HACcYpHkvQMgWeFtitiqYeihgDRuVP6dhV6D8NardPP38KSG5obhO63xJvNl+ZCoa9igBTXRTbAATaGjdy4XIZsBWZwDyVj4QZUQAlkpxn" -> null
      - tags        = {} -> null
      - tags_all    = {} -> null
    }

  # module.server.local_file.private_key will be destroyed
  - resource "local_file" "private_key" {
      - content              = (sensitive value) -> null
      - content_base64sha256 = "/rSdwJS2XV+7tDo7dYRoWOz8t1AyGd4AY8ZmwLSiz/o=" -> null
      - content_base64sha512 = "diJ2N3CV0vDcJZ8pM4jKvFs9tYlq65tOJQkaBT4OQHoAhGXhhvgAFEjgdaD0xNx1InFLKWZVH0+iyfMdM3XUtw==" -> null
      - content_md5          = "bc392706b97f3f595fc3b08fa22b2e4c" -> null
      - content_sha1         = "44b439e3f48a06fb76f79412c47420b3a3daa6fe" -> null
      - content_sha256       = "feb49dc094b65d5fbbb43a3b75846858ecfcb7503219de0063c666c0b4a2cffa" -> null
      - content_sha512       = "762276377095d2f0dc259f293388cabc5b3db5896aeb9b4e25091a053e0e407a008465e186f8001448e075a0f4c4dc7522714b2966551f4fa2c9f31d3375d4b7" -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0777" -> null
      - filename             = "modules/instance/sabarish.pem" -> null
      - id                   = "44b439e3f48a06fb76f79412c47420b3a3daa6fe" -> null
    }

  # module.server.tls_private_key.ssh_key will be destroyed
  - resource "tls_private_key" "ssh_key" {
      - algorithm                     = "RSA" -> null
      - ecdsa_curve                   = "P224" -> null
      - id                            = "291199b74778da0e765d1d31a46ea95e557048bb" -> null
      - private_key_openssh           = (sensitive value) -> null
      - private_key_pem               = (sensitive value) -> null
      - private_key_pem_pkcs8         = (sensitive value) -> null
      - public_key_fingerprint_md5    = "55:74:a8:a7:38:3f:e8:05:c8:d6:34:34:22:f2:d0:ad" -> null
      - public_key_fingerprint_sha256 = "SHA256:2XJlahOeiqnJygB2r6NtqluMxFNoUnrS5wY+82QlTPs" -> null
      - public_key_openssh            = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5JHP4zKqzhkkJKht3+MkJDq1nRUUsTTWUxjj0lJxbdsbmVr97PR5eailvkwkrxvDnnO/zioCZRJkAoTrNI7PJlNym0myDC9EhDVCu6+nbWxIEH6FPlEcdzwKVznJils0EcRePzQKBXqkNNsWKzji0BZpMP7ytIVrm0ezqvTG3+3svs4L139UghDwcDPNqKeFNehMPQVw/eohvwUirHEk7zF2L4sbc4JilFg1H8ULJ35HACcYpHkvQMgWeFtitiqYeihgDRuVP6dhV6D8NardPP38KSG5obhO63xJvNl+ZCoa9igBTXRTbAATaGjdy4XIZsBWZwDyVj4QZUQAlkpxn
        EOT -> null
      - public_key_pem                = <<-EOT
            -----BEGIN PUBLIC KEY-----
            MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuSRz+Myqs4ZJCSobd/jJ
            CQ6tZ0VFLE01lMY49JScW3bG5la/ez0eXmopb5MJK8bw55zv84qAmUSZAKE6zSOz
            yZTcptJsgwvRIQ1Qruvp21sSBB+hT5RHHc8Clc5yYpbNBHEXj80CgV6pDTbFis44
            tAWaTD+8rSFa5tHs6r0xt/t7L7OC9d/VIIQ8HAzzainhTXoTD0FcP3qIb8FIqxxJ
            O8xdi+LG3OCYpRYNR/FCyd+RwAnGKR5L0DIFnhbYrYqmHooYA0blT+nYVeg/DWq3
            Tz9/CkhuaG4Tut8SbzZfmQqGvYoAU10U2wAE2ho3cuFyGbAVmcA8lY+EGVEAJZKc
            ZwIDAQAB
            -----END PUBLIC KEY-----
        EOT -> null
      - rsa_bits                      = 2048 -> null
    }

  # module.vpc.aws_eip.elastic_ip_nat_gateway will be destroyed
  - resource "aws_eip" "elastic_ip_nat_gateway" {
      - allocation_id        = "eipalloc-0ab4091cf11c5ab65" -> null
      - association_id       = "eipassoc-0e38c5b80578374d3" -> null
      - domain               = "vpc" -> null
      - id                   = "eipalloc-0ab4091cf11c5ab65" -> null
      - network_border_group = "ap-south-1" -> null
      - network_interface    = "eni-061716714c465d4df" -> null
      - private_dns          = "ip-10-0-1-72.ap-south-1.compute.internal" -> null
      - private_ip           = "10.0.1.72" -> null
      - public_dns           = "ec2-13-235-29-170.ap-south-1.compute.amazonaws.com" -> null
      - public_ip            = "13.235.29.170" -> null
      - public_ipv4_pool     = "amazon" -> null
      - tags                 = {
          - "Name" = "nat_gateway"
        } -> null
      - tags_all             = {
          - "Name" = "nat_gateway"
        } -> null
      - vpc                  = true -> null
    }

  # module.vpc.aws_internet_gateway.internet_gateway will be destroyed
  - resource "aws_internet_gateway" "internet_gateway" {
      - arn      = "arn:aws:ec2:ap-south-1:483008991703:internet-gateway/igw-03a95bb51bc3ab15d" -> null
      - id       = "igw-03a95bb51bc3ab15d" -> null
      - owner_id = "483008991703" -> null
      - tags     = {
          - "Name" = "internet_gateway"
        } -> null
      - tags_all = {
          - "Name" = "internet_gateway"
        } -> null
      - vpc_id   = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_nat_gateway.private_nat_gateway will be destroyed
  - resource "aws_nat_gateway" "private_nat_gateway" {
      - allocation_id                      = "eipalloc-0ab4091cf11c5ab65" -> null
      - association_id                     = "eipassoc-0e38c5b80578374d3" -> null
      - connectivity_type                  = "public" -> null
      - id                                 = "nat-0abde69905664bcee" -> null
      - network_interface_id               = "eni-061716714c465d4df" -> null
      - private_ip                         = "10.0.1.72" -> null
      - public_ip                          = "13.235.29.170" -> null
      - secondary_allocation_ids           = [] -> null
      - secondary_private_ip_address_count = 0 -> null
      - secondary_private_ip_addresses     = [] -> null
      - subnet_id                          = "subnet-0858691855ed77b19" -> null
      - tags                               = {} -> null
      - tags_all                           = {} -> null
    }

  # module.vpc.aws_route_table.private_route_table will be destroyed
  - resource "aws_route_table" "private_route_table" {
      - arn              = "arn:aws:ec2:ap-south-1:483008991703:route-table/rtb-0e520f98380fffe58" -> null
      - id               = "rtb-0e520f98380fffe58" -> null
      - owner_id         = "483008991703" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - carrier_gateway_id         = ""
              - cidr_block                 = "0.0.0.0/0"
              - core_network_arn           = ""
              - destination_prefix_list_id = ""
              - egress_only_gateway_id     = ""
              - gateway_id                 = ""
              - ipv6_cidr_block            = ""
              - local_gateway_id           = ""
              - nat_gateway_id             = "nat-0abde69905664bcee"
              - network_interface_id       = ""
              - transit_gateway_id         = ""
              - vpc_endpoint_id            = ""
              - vpc_peering_connection_id  = ""
            },
        ] -> null
      - tags             = {
          - "Name" = "private_route_table"
        } -> null
      - tags_all         = {
          - "Name" = "private_route_table"
        } -> null
      - vpc_id           = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_route_table.public_route_table will be destroyed
  - resource "aws_route_table" "public_route_table" {
      - arn              = "arn:aws:ec2:ap-south-1:483008991703:route-table/rtb-0dfb66449d17c4c39" -> null
      - id               = "rtb-0dfb66449d17c4c39" -> null
      - owner_id         = "483008991703" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - carrier_gateway_id         = ""
              - cidr_block                 = "0.0.0.0/0"
              - core_network_arn           = ""
              - destination_prefix_list_id = ""
              - egress_only_gateway_id     = ""
              - gateway_id                 = "igw-03a95bb51bc3ab15d"
              - ipv6_cidr_block            = ""
              - local_gateway_id           = ""
              - nat_gateway_id             = ""
              - network_interface_id       = ""
              - transit_gateway_id         = ""
              - vpc_endpoint_id            = ""
              - vpc_peering_connection_id  = ""
            },
        ] -> null
      - tags             = {
          - "Name" = "Public_Route_table"
        } -> null
      - tags_all         = {
          - "Name" = "Public_Route_table"
        } -> null
      - vpc_id           = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[0] will be destroyed
  - resource "aws_route_table_association" "private_subnet_associations" {
      - id             = "rtbassoc-0a542bfbc43c6f47c" -> null
      - route_table_id = "rtb-0e520f98380fffe58" -> null
      - subnet_id      = "subnet-0262d5d1e4b10c549" -> null
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[1] will be destroyed
  - resource "aws_route_table_association" "private_subnet_associations" {
      - id             = "rtbassoc-0555bf800fded6906" -> null
      - route_table_id = "rtb-0e520f98380fffe58" -> null
      - subnet_id      = "subnet-029b13d45756bd31b" -> null
    }

  # module.vpc.aws_route_table_association.private_subnet_associations[2] will be destroyed
  - resource "aws_route_table_association" "private_subnet_associations" {
      - id             = "rtbassoc-092c40df85e43ad4a" -> null
      - route_table_id = "rtb-0e520f98380fffe58" -> null
      - subnet_id      = "subnet-0ce27769cc1a078ed" -> null
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[0] will be destroyed
  - resource "aws_route_table_association" "public_subnet_associations" {
      - id             = "rtbassoc-062bebd26baf4b28e" -> null
      - route_table_id = "rtb-0dfb66449d17c4c39" -> null
      - subnet_id      = "subnet-0858691855ed77b19" -> null
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[1] will be destroyed
  - resource "aws_route_table_association" "public_subnet_associations" {
      - id             = "rtbassoc-0b4499f23e51cf91c" -> null
      - route_table_id = "rtb-0dfb66449d17c4c39" -> null
      - subnet_id      = "subnet-07b83e52d4990edfa" -> null
    }

  # module.vpc.aws_route_table_association.public_subnet_associations[2] will be destroyed
  - resource "aws_route_table_association" "public_subnet_associations" {
      - id             = "rtbassoc-0fa4d0f4b287adf5e" -> null
      - route_table_id = "rtb-0dfb66449d17c4c39" -> null
      - subnet_id      = "subnet-01e13549e078dcc4e" -> null
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_1"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-0262d5d1e4b10c549" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1a" -> null
      - availability_zone_id                           = "aps1-az1" -> null
      - cidr_block                                     = "10.0.4.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0262d5d1e4b10c549" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "private_subnet_1"
        } -> null
      - tags_all                                       = {
          - "Name" = "private_subnet_1"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_2"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-029b13d45756bd31b" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1b" -> null
      - availability_zone_id                           = "aps1-az3" -> null
      - cidr_block                                     = "10.0.5.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-029b13d45756bd31b" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "private_subnet_2"
        } -> null
      - tags_all                                       = {
          - "Name" = "private_subnet_2"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_subnet.subnets_create["private_subnet_3"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-0ce27769cc1a078ed" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1c" -> null
      - availability_zone_id                           = "aps1-az2" -> null
      - cidr_block                                     = "10.0.6.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0ce27769cc1a078ed" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "private_subnet_3"
        } -> null
      - tags_all                                       = {
          - "Name" = "private_subnet_3"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_1"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-0858691855ed77b19" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1a" -> null
      - availability_zone_id                           = "aps1-az1" -> null
      - cidr_block                                     = "10.0.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0858691855ed77b19" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "public_subnet_1"
        } -> null
      - tags_all                                       = {
          - "Name" = "public_subnet_1"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_2"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-07b83e52d4990edfa" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1b" -> null
      - availability_zone_id                           = "aps1-az3" -> null
      - cidr_block                                     = "10.0.2.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-07b83e52d4990edfa" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "public_subnet_2"
        } -> null
      - tags_all                                       = {
          - "Name" = "public_subnet_2"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_subnet.subnets_create["public_subnet_3"] will be destroyed
  - resource "aws_subnet" "subnets_create" {
      - arn                                            = "arn:aws:ec2:ap-south-1:483008991703:subnet/subnet-01e13549e078dcc4e" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "ap-south-1c" -> null
      - availability_zone_id                           = "aps1-az2" -> null
      - cidr_block                                     = "10.0.3.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-01e13549e078dcc4e" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "483008991703" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "public_subnet_3"
        } -> null
      - tags_all                                       = {
          - "Name" = "public_subnet_3"
        } -> null
      - vpc_id                                         = "vpc-00aa40fa96183caf2" -> null
    }

  # module.vpc.aws_vpc.vpc will be destroyed
  - resource "aws_vpc" "vpc" {
      - arn                                  = "arn:aws:ec2:ap-south-1:483008991703:vpc/vpc-00aa40fa96183caf2" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-0d3557fda07d4b91d" -> null
      - default_route_table_id               = "rtb-04c79d9017107dfad" -> null
      - default_security_group_id            = "sg-0f298ede63ed7b375" -> null
      - dhcp_options_id                      = "dopt-04a3306c5cfdc931f" -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-00aa40fa96183caf2" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-04c79d9017107dfad" -> null
      - owner_id                             = "483008991703" -> null
      - tags                                 = {
          - "Name" = "vpc"
        } -> null
      - tags_all                             = {
          - "Name" = "vpc"
        } -> null
    }

Plan: 0 to add, 0 to change, 27 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.server.local_file.private_key: Destroying... [id=44b439e3f48a06fb76f79412c47420b3a3daa6fe]
module.server.local_file.private_key: Destruction complete after 0s
module.vpc.aws_route_table_association.public_subnet_associations[2]: Destroying... [id=rtbassoc-0fa4d0f4b287adf5e]
module.vpc.aws_route_table_association.private_subnet_associations[2]: Destroying... [id=rtbassoc-092c40df85e43ad4a]
module.vpc.aws_route_table_association.public_subnet_associations[0]: Destroying... [id=rtbassoc-062bebd26baf4b28e]
module.vpc.aws_route_table_association.public_subnet_associations[1]: Destroying... [id=rtbassoc-0b4499f23e51cf91c]
module.vpc.aws_route_table_association.private_subnet_associations[1]: Destroying... [id=rtbassoc-0555bf800fded6906]
module.vpc.aws_route_table_association.private_subnet_associations[0]: Destroying... [id=rtbassoc-0a542bfbc43c6f47c]
module.server.aws_eip.server_ip[0]: Destroying... [id=eipalloc-0881b75bced54e361]
module.server.aws_eip.server_ip[1]: Destroying... [id=eipalloc-0f2cbf67a27e26501]
module.vpc.aws_route_table_association.public_subnet_associations[0]: Destruction complete after 1s
module.vpc.aws_route_table_association.public_subnet_associations[1]: Destruction complete after 1s
module.vpc.aws_route_table_association.private_subnet_associations[0]: Destruction complete after 1s
module.vpc.aws_route_table_association.private_subnet_associations[2]: Destruction complete after 1s
module.vpc.aws_route_table_association.public_subnet_associations[2]: Destruction complete after 1s
module.vpc.aws_route_table_association.private_subnet_associations[1]: Destruction complete after 1s
module.vpc.aws_route_table.public_route_table: Destroying... [id=rtb-0dfb66449d17c4c39]
module.vpc.aws_route_table.private_route_table: Destroying... [id=rtb-0e520f98380fffe58]
module.vpc.aws_route_table.public_route_table: Destruction complete after 0s
module.vpc.aws_internet_gateway.internet_gateway: Destroying... [id=igw-03a95bb51bc3ab15d]
module.vpc.aws_route_table.private_route_table: Destruction complete after 0s
module.vpc.aws_nat_gateway.private_nat_gateway: Destroying... [id=nat-0abde69905664bcee]
module.server.aws_eip.server_ip[0]: Destruction complete after 2s
module.server.aws_eip.server_ip[1]: Destruction complete after 2s
module.server.aws_instance.server["jenkins"]: Destroying... [id=i-05f2403f22c43c550]
module.server.aws_instance.server["dev"]: Destroying... [id=i-0bcd97762b62ab54e]
module.vpc.aws_internet_gateway.internet_gateway: Still destroying... [id=igw-03a95bb51bc3ab15d, 10s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still destroying... [id=nat-0abde69905664bcee, 10s elapsed]
module.server.aws_instance.server["jenkins"]: Still destroying... [id=i-05f2403f22c43c550, 10s elapsed]
module.server.aws_instance.server["dev"]: Still destroying... [id=i-0bcd97762b62ab54e, 10s elapsed]
module.vpc.aws_internet_gateway.internet_gateway: Still destroying... [id=igw-03a95bb51bc3ab15d, 20s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still destroying... [id=nat-0abde69905664bcee, 20s elapsed]
module.server.aws_instance.server["jenkins"]: Still destroying... [id=i-05f2403f22c43c550, 20s elapsed]
module.server.aws_instance.server["dev"]: Still destroying... [id=i-0bcd97762b62ab54e, 20s elapsed]
module.vpc.aws_internet_gateway.internet_gateway: Still destroying... [id=igw-03a95bb51bc3ab15d, 30s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Still destroying... [id=nat-0abde69905664bcee, 30s elapsed]
module.server.aws_instance.server["jenkins"]: Destruction complete after 30s
module.server.aws_instance.server["dev"]: Destruction complete after 30s
module.server.aws_key_pair.key_pair: Destroying... [id=sabarish]
module.security.aws_security_group.servers: Destroying... [id=sg-04c4c2319d3ab1941]
module.server.aws_key_pair.key_pair: Destruction complete after 0s
module.server.tls_private_key.ssh_key: Destroying... [id=291199b74778da0e765d1d31a46ea95e557048bb]
module.server.tls_private_key.ssh_key: Destruction complete after 0s
module.security.aws_security_group.servers: Destruction complete after 0s
module.security.aws_security_group.office_ip: Destroying... [id=sg-08369472fd1506772]
module.security.aws_security_group.office_ip: Destruction complete after 1s
module.vpc.aws_internet_gateway.internet_gateway: Destruction complete after 37s
module.vpc.aws_nat_gateway.private_nat_gateway: Still destroying... [id=nat-0abde69905664bcee, 40s elapsed]
module.vpc.aws_nat_gateway.private_nat_gateway: Destruction complete after 41s
module.vpc.aws_subnet.subnets_create["private_subnet_3"]: Destroying... [id=subnet-0ce27769cc1a078ed]
module.vpc.aws_subnet.subnets_create["public_subnet_1"]: Destroying... [id=subnet-0858691855ed77b19]
module.vpc.aws_subnet.subnets_create["private_subnet_2"]: Destroying... [id=subnet-029b13d45756bd31b]
module.vpc.aws_subnet.subnets_create["private_subnet_1"]: Destroying... [id=subnet-0262d5d1e4b10c549]
module.vpc.aws_subnet.subnets_create["public_subnet_2"]: Destroying... [id=subnet-07b83e52d4990edfa]
module.vpc.aws_subnet.subnets_create["public_subnet_3"]: Destroying... [id=subnet-01e13549e078dcc4e]
module.vpc.aws_eip.elastic_ip_nat_gateway: Destroying... [id=eipalloc-0ab4091cf11c5ab65]
module.vpc.aws_subnet.subnets_create["private_subnet_3"]: Destruction complete after 0s
module.vpc.aws_subnet.subnets_create["private_subnet_1"]: Destruction complete after 0s
module.vpc.aws_subnet.subnets_create["public_subnet_2"]: Destruction complete after 0s
module.vpc.aws_subnet.subnets_create["public_subnet_1"]: Destruction complete after 0s
module.vpc.aws_subnet.subnets_create["private_subnet_2"]: Destruction complete after 0s
module.vpc.aws_subnet.subnets_create["public_subnet_3"]: Destruction complete after 1s
module.vpc.aws_vpc.vpc: Destroying... [id=vpc-00aa40fa96183caf2]
module.vpc.aws_eip.elastic_ip_nat_gateway: Destruction complete after 1s
module.vpc.aws_vpc.vpc: Destruction complete after 0s

Destroy complete! Resources: 27 destroyed.
```
