variable "project" {

}

variable "region" {
  type = string
}

variable "credentials" {
  type = string
}

variable "bucket_location" {
  type = string
}

variable "zone" {
  type = string
}

variable "bucket_name" {
  type = string
}
variable "storage_class" {
  type    = string
  default = "STANDARD"
}
