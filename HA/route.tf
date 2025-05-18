resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "SRE route table public"
  }
}

resource "aws_route_table" "route-private-a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-public-a.id
  }
  tags = {
    Name = "SRE route table private a"
  }
}
resource "aws_route_table" "route-private-b" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-public-b.id
  }
  tags = {
    Name = "SRE route table private b"
  }
}

resource "aws_route_table_association" "public-route" {
  for_each = {
    subnet-a = aws_subnet.public-subnet-a.id
    subnet-b = aws_subnet.public-subnet-b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.route-public.id
}

resource "aws_route_table_association" "private-route-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.route-private-a.id
}

resource "aws_route_table_association" "private-route-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.route-private-b.id
}