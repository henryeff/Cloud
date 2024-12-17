provider "aws" {
    region = var.aws_region["region"]
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
        Terraform = true
        source = "https://www.github.com/henryeff/Cloud"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
    availability_zone = var.aws_region["az"]
}

resource "aws_internet_gateway" "aws_ig" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_route_table" {
    vpc_id=aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aws_ig.id
    }
}

resource "aws_route_table_association" "public" {
    route_table_id = aws_route_table.public_route_table.id
    subnet_id=aws_subnet.public_subnet.id
}

resource "aws_security_group" "vpn_security_group" {
    name = "vpn_security_group"
    description = "security group for vpn server"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "allow port 51820"
        from_port = 51820
        to_port = 51820
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow port 22 for ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}



resource "aws_instance" "vpn_server" {
    ami = var.server_details["ami"]
    instance_type = var.server_details["type"]
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    security_groups = [ aws_security_group.vpn_security_group.id ]
}