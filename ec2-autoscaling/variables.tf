locals {
  vpc                 = "test-vpc"
  internet_gateway    = "test-inet-gw"
  public_subnet       = "test-pub-sub"
  private_subnet      = "test-priv-sub"
  public_route_table  = "test-pub-rt"
  private_route_table = "test-priv-rt"
  elastic_ip          = "test-eip"
  nat_gateway         = "test-nat-gw"
  alb_security_group  = "test-alb-sec-grp"
  asg_security_group  = "test-asg"
  launch_template     = "test-lnch-tmpl"
  launch_template_ec2 = "test-lnch-tmpl-ec2-inst"
  alb                 = "test-alb"
  target_group        = "test-tgt-grp"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eu-south-1"
}

variable "availabilityZones" {
  type    = list(string)
  default = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "vpcCIDR" {
  description = "VPC cidr block"
  type        = string
  default     = "172.32.0.0/16"
}

variable "pubSubCIDR" {
  description = "Public CIDR blocks"
  type        = list(string)
  default     = ["172.32.0.0/24", "172.32.1.0/24", "172.32.2.0/24"]
}

variable "privSubCIDR" {
  description = "Private CIDR blocks"
  type        = list(string)
  default     = ["172.32.50.0/24", "172.32.51.0/24", "172.32.52.0/24"]
}

variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-0010fdacdadb38bb0"
}

variable "srvPort" {
  description = "The port the web server will be listening"
  type        = number
  default     = 8080
}

variable "elbPort" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
}

variable "instType" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "minSize" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

variable "maxSize" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 5
}

variable "desiredCapacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}