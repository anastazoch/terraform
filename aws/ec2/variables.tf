variable "instanceType" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}
variable "region" {
  default = "eu-south-1"
}
variable "availabilityZone" {
     default = "eu-south-1a"
}
variable "secondaryAvailabilityZone" {
     default = "eu-south-1b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRBlock" {
    default = "10.10.0.0/16"
}
variable "subnetCIDRBlock" {
    default = "10.10.1.0/24"
}
variable "secondarySubnetCIDRBlock" {
    default = "10.10.2.0/24"
}
variable "privateIPs" {
    type = list
    default = ["10.10.1.5"]
}
variable "destinationCIDRBlocks" {
    type = list
    default = ["0.0.0.0/0"]
}
variable "ingressCIDRBlocks" {
    type = list
    default = ["0.0.0.0/0"]
}
variable "egressCIDRBlocks" {
    type = list
    default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
    default = true
}
variable "asGrpMinSize" {
    type = number
    default = 1
}
variable "asGrpMaxSize" {
    type = number
    default = 5
}
variable "asGrpDesiredCapacity" {
    type = number
    default = 3
}