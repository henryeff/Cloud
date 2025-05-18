resource "aws_nat_gateway" "nat-public-a" {
  allocation_id = aws_eip.eip-nat-public-a.id
  subnet_id     = aws_subnet.public-subnet-a.id
  tags = {
    Name = "SRE NAT Gateway Public A"
  }
}
resource "aws_nat_gateway" "nat-public-b" {
  allocation_id = aws_eip.eip-nat-public-b.id
  subnet_id     = aws_subnet.public-subnet-b.id
  tags = {
    Name = "SRE NAT Gateway Public B"
  }
}
