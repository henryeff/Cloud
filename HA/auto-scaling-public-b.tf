resource "aws_launch_template" "asg-launch-template-public-b" {
  name                   = "asg-launch-template-public-b"
  image_id               = var.instance["ami"]
  instance_type          = var.instance["type"]
  vpc_security_group_ids = [aws_security_group.sg-asg-public.id]
  user_data = base64encode(<<-EOF
      #!/bin/bash
      sudo yum install -y httpd
      TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
      INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
      AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
      PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4)
      echo "<h1>Instance ID: $${INSTANCE_ID}</h1>" > /var/www/html/index.html
      echo "<h2>Availability Zone: $${AZ}</h2>" >> /var/www/html/index.html
      echo "<h2>Public IP: $${PUBLIC_IP}</h2>" >> /var/www/html/index.html
      sudo systemctl enable httpd
      sudo systemctl start httpd
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "SRE Launch Template Public B"
    }
  }
}

resource "aws_autoscaling_group" "asg-public-b" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.public-subnet-b.id]
  launch_template {
    id      = aws_launch_template.asg-launch-template-public-b.id
    version = "$Latest"
  }
  target_group_arns         = [aws_lb_target_group.tg-public.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "SRE ASG Public B"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale-out-public-b" {
  name                   = "scale-out-public-b"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-public-b.name
}

resource "aws_autoscaling_policy" "scale-in-public-b" {
  name                   = "scale-in-public-b"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-public-b.name
}

resource "aws_cloudwatch_metric_alarm" "cpu-high-public-b" {
  alarm_name          = "cpu-high-public-b"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors CPU utilization for the public ASG in AZ A"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-public-b.name
  }
  alarm_actions = [aws_autoscaling_policy.scale-out-public-b.arn, aws_sns_topic.sns-auto-scaling-cpu.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu-low-public-b" {
  alarm_name          = "cpu-low-public-b"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This metric monitors CPU utilization for the public ASG in AZ A"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-public-b.name
  }
  alarm_actions = [aws_autoscaling_policy.scale-in-public-b.arn, aws_sns_topic.sns-auto-scaling-cpu.arn]
}
