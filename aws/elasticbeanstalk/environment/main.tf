variable "environment" {}
variable "vpc_id" {}
variable "ec2_key_name" {}
variable "application" {}
variable "security_group" {}
variable "rds_connection_url" {}

variable "subnets" {
  type = "list"
}

variable "solution_stack_name" {
  default = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
}

variable "environment_type" {
  default = "SingleInstance"
}

variable "instance_type" {
  default = "t3.small"
}

variable "stream_logs" {
  default = "false"
}


# variable "load_balancer_type" {
#   default = "classic"
# }

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.environment}"
  application         = "${var.application}"
  solution_stack_name = "${var.solution_stack_name}"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.subnets)}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "${var.environment_type}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.subnets)}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${var.security_group}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ec2_key_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ec2-role.name}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.environment_type == "SingleInstance" ? "1" : "2"}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "${var.rds_connection_url}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "${var.stream_logs}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }
}

output "cname" {
  value = "${aws_elastic_beanstalk_environment.env.cname}"
}
