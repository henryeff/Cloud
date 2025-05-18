resource "aws_lb" "lb-private" {
  name               = "sre-lb-private"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-lb-private.id]
  subnets            = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id]
  tags = {
    Name = "sre-lb-private"
  }
}

resource "aws_lb_target_group" "tg-private" {
  name     = "sre-tg-private"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "sre-tg-private"
  }
}

resource "aws_lb_listener" "listener-lb-private" {
  load_balancer_arn = aws_lb.lb-private.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-private.arn
  }
  tags = {
    Name = "sre-listener-lb-private"
  }
}

output "lb-private" {
  value = {
    dns-name     = aws_lb.lb-private.dns_name
    arn          = aws_lb.lb-private.arn
    target-group = aws_lb_target_group.tg-private.arn
  }
}
