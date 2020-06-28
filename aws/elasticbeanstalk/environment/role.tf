# EC2 instances
resource "aws_iam_role" "ec2-role" {
  name = "${var.application}-${var.environment}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-role" {
  name = "${var.application}-${var.environment}-eb-ec2-role"
  role = "${aws_iam_role.ec2-role.name}"
}

resource "aws_iam_role_policy_attachment" "web" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "multicontainer" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "worker" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "describe_environment" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "${aws_iam_policy.describe_environment.arn}"
}

resource "aws_iam_policy" "describe_environment" {
  name        = "describe-environmen-${var.application}-${var.environment}"
  description = "Allows EC2 instance to describe the Elastic Beanstalk environment"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "elasticbeanstalk:DescribeEnvironments",
            "Resource": "${aws_elastic_beanstalk_environment.env.arn}"
        }
    ]
}
EOF
}

# EB Service
resource "aws_iam_role" "eb-service-role" {
  name = "${var.application}-${var.environment}-eb-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eb_health" {
  role       = "${aws_iam_role.eb-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

output "eb-ec2-role" {
  value = "${aws_iam_role.ec2-role.name}"
}
