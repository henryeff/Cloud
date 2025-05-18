resource "aws_eip" "eip-nat-public-a" {
  tags = {
    Name = "SRE EIP NAT Public A"
  }
}

resource "aws_eip" "eip-nat-public-b" {
  tags = {
    Name = "SRE EIP NAT Public B"
  }
}