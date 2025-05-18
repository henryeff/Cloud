resource "aws_security_group" "sg-lb-private" {
  name        = "sre-sg-lb-private"
  description = "Security group for private load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow HTTP traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-asg-public.id]
  }

  ingress {
    description     = "Allow HTTPS traffic"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-asg-public.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sre-sg-lb-private"
  }
}
