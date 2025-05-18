resource "aws_security_group" "sg-asg-private" {
  name        = "sre-sg-asg-private"
  description = "Security group for private auto-scaling group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow HTTP traffic from load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-lb-private.id]
  }

  ingress {
    description = "!!!!!!!Allow SSH traffic FROM ANYWHERE PLEASE DELETE!!!!!!!!!!!"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sre-sg-asg-private"
  }
}