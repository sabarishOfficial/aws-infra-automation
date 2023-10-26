#output "values" {
#  value = module.server.local
#}
#output "instance" {
#  value = module.server.local-in
#}
##output "testing" {
##  value = module.server.testing
##}

#output "vpc" {
#  value = lookup(var.cidr_block.vpc, "cidr_block", null)
#}
#output "vpc" {
#  value = keys(var.cidr_block)[2]
#}
#output "values" {
#  value = module.vpc.vpc
#}
#output "subnets" {
#  value = module.vpc.subnets
#}
# output "public" {
#   value = module.server.public_subnets
# }