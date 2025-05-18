resource "aws_sns_topic" "sns-auto-scaling-cpu" {
  name = "sre-sns-auto-scaling-cpu"
}

resource "aws_sns_topic_subscription" "email-list" {
  topic_arn = aws_sns_topic.sns-auto-scaling-cpu.arn
  protocol  = "email"
  endpoint  = var.sns-email
}
  