locals {
  vpc_name                 = "test_vpc"
  internet_gateway_name    = "test_inet_gw"
  public_subnet_name       = "test_pub_sub"
  private_subnet_name      = "test_priv_sub"
  public_route_table_name  = "test_pub_rt"
  private_route_table_name = "test_priv_rt"
  elastic_ip_name          = "test_eip"
  nat_gateway_name         = "test_nat_gw"
  alb_security_group_name  = "test_alb_sec_grp"
  asg_security_group_name  = "test_asg"
  launch_template_name     = "test_lnch_tmpl"
  launch_template_ec2_name = "test_lnch_tmpl_ec2_inst"
  alb_name                 = "test_alb"
  target_group_name        = "test_tgt_grp"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eu-south-1"
}

variable "num_of_AZ" {
  description = "Number of Availability Zones"
  type        = number
  default     = 3
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "172.32.0.0/16"
}

variable "availability_zonesy" {
  type    = list(string)
  default = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "public_subnet_cidr" {
  description = "Public Subnet cidr block"
  type        = list(string)
  default     = ["172.32.0.0/24", "172.32.1.0/24", "172.132.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "Private Subnet cidr block"
  type        = list(string)
  default     = ["172.32.50.0/24", "172.32.51.0/24", "172.32.52.0/24"]
}

variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-000e50175c5f86214"
}

variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "eu-south-1"
  }

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}