resource "aws_security_group" "sg-rds" {
  name        = "sre-sg-rds"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "SRE Security Group RDS"
  }

  ingress {
    description     = "Allow traffic from private subnet"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-asg-private.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}