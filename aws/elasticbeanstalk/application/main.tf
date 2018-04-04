variable "application" {}

resource "aws_elastic_beanstalk_application" "app" {
  name = "${var.application}"
}
