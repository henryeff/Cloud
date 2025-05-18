variable "aws_region" {
  default = {
    "region" : "ap-southeast-1",
    "az" : ["ap-southeast-1a", "ap-southeast-1b"]
  }
}

variable "vpc" {
  default = {
    "cidr_block" : "10.0.0.0/16",
    "name" : "SRE-VPC",
    "source" : "https://www.github.com/henryeff/Cloud/HA"
  }
}

variable "instance" {
  default = {
    "ami" : "ami-0afc7fe9be84307e4",
    "type" : "t2.micro",
  }
}

variable "sns-email" {
  default = "henryeff@live.com"
}