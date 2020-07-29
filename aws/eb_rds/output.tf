output "public_subnets" {
  value = "${var.public_subnets}"
}

output "dbs_private_subnets" {
  value = "${var.dbs_private_subnets}"
}

output "aws_azs" {
  value = "${var.aws_azs}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "servers_sg_id" {
  value = "${module.vpc.servers_sg_id}"
}

output "eb_instance_profile" {
  value = "${module.server.eb-ec2-role}"
}
