provider "aws" {
  region = var.aws_region["region"]
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc["cidr_block"]
  tags = {
    Name      = var.vpc["name"]
    Terraform = true
    source    = var.vpc["source"]
  }
}

