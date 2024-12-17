variable "aws_region" {
  default = {
    "region" : "ap-southeast-1"
    "az" : "ap-southeast-1a"
  }
}

variable "vpc_name" {
  type    = string
  default = "AWS_VPN"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "server_details" {
  default = {
    "ami" : "ami-06650ca7ed78ff6fa"
  "type" : "t2.micro" }
}