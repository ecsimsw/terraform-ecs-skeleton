# SNS

resource "aws_sns_topic" "sns_topic_base" {
  name = "topic-base"
}

# SQS

resource "aws_sqs_queue" "sqs_base" {
  name = "sqs-base"
  fifo_queue = false
  visibility_timeout_seconds = 15
  message_retention_seconds  = 600
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
}

resource "aws_sns_topic_subscription" "topic_sub_base" {
  topic_arn = aws_sns_topic.sns_topic_base.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_base.arn
}

resource "aws_sqs_queue_policy" "sqs_policy_base" {
  queue_url = aws_sqs_queue.sqs_base.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.sqs_base.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_topic_base.arn
          }
        }
      }
    ]
  })
}
