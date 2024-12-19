provider "aws" {
  region = var.aws_region["region"]
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name      = var.vpc_name
    Terraform = true
    source    = "https://www.github.com/henryeff/Cloud"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = var.aws_region["az"]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "aws_ig" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_ig.id
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_security_group" "vpn_security_group" {
  name        = "vpn_security_group"
  description = "security group for vpn server"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "allow port 51820"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow port 22 for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "AWSVPNKey.pem"
}

resource "aws_key_pair" "generated" {
  key_name   = "AWSVPN"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "aws_instance" "vpn_server" {
  ami                         = var.server_details["ami"]
  instance_type               = var.server_details["type"]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.vpn_security_group.id]
  key_name                    = aws_key_pair.generated.key_name
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
  provisioner "local-exec" {
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt upgrade -y",
      "sudo apt install wireguard -y",
      "sudo sysctl -w net.ipv4.ip_forward=1",
      "echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf",
      "sudo sysctl -p",
      "wg genkey | sudo tee /etc/wireguard/server_private_key | wg pubkey | sudo tee /etc/wireguard/server_public_key",
      "wg genkey | sudo tee /etc/wireguard/phone_private_key | wg pubkey | sudo tee /etc/wireguard/phone_public_key",
      "sudo apt install qrencode -y",
      <<EOT
sudo bash -c 'cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(sudo cat /etc/wireguard/server_private_key)
Address = 10.0.1.1/24
ListenPort = 51820
PostUp = iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE; iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o enX0 -j MASQUERADE; iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT
DNS = 8.8.8.8

[Peer]
PublicKey = $(sudo cat /etc/wireguard/phone_public_key)
AllowedIPs = 10.0.1.2/32
EOF'
EOT
      ,
      <<EOT
bash -c 'cat > phone.conf <<EOF
[Interface]
PrivateKey = $(sudo cat /etc/wireguard/phone_private_key)
Address = 10.0.1.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(sudo cat /etc/wireguard/server_public_key)
Endpoint = ${aws_instance.vpn_server.public_ip}:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 21
EOF'
EOT
      ,
      "sudo systemctl start wg-quick@wg0",
      "sudo systemctl enable wg-quick@wg0"
    ]
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
    Name   = "VPN Server"
    Source = "https://github.com/henryeff/Cloud/tree/main/VPN"
  }
}

resource "null_resource" "phone_conf" {
  depends_on = [aws_instance.vpn_server]

  provisioner "local-exec" {
    command = <<EOT
scp -i ${local_file.private_key_pem.filename} -o StrictHostKeyChecking=no ubuntu@${aws_instance.vpn_server.public_ip}:/home/ubuntu/phone.conf ./phone.conf
EOT
  }
}

output "vpn_ip" {
  value = aws_instance.vpn_server.public_ip
}