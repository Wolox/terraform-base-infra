# VPC Variables
output "public_subnets" {
  value="${var.public_subnets}"
}

output "dbs_private_subnets" {
  value="${var.dbs_private_subnets}"
}

output "aws_azs" {
  value="${var.aws_azs}"
}
