variable "region" {
  default = "eu-south-1"
}
variable "availability_zone" {
  default = "eu-south-1a"
}
variable "vcp_cidr" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "instance_type" {
  default = "t3.nano"
}
variable "private_instance_count" {
  default = 3
}
variable "public_instance_count" {
  default = 3
}
