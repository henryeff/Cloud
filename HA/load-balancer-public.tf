resource "aws_lb" "lb-public" {
  name               = "sre-lb-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-lb-public.id]
  subnets            = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]
  tags = {
    Name = "sre-lb-public"
  }
}

resource "aws_lb_target_group" "tg-public" {
  name     = "sre-tg-public"
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
    Name = "sre-tg-public"
  }
}

resource "aws_lb_listener" "listener-lb-public" {
  load_balancer_arn = aws_lb.lb-public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-public.arn
  }
  tags = {
    Name = "sre-listener-lb-public"
  }
}

output "lb-public" {
  value = {
    dns-name     = aws_lb.lb-public.dns_name
    arn          = aws_lb.lb-public.arn
    target-group = aws_lb_target_group.tg-public.arn
  }
}
