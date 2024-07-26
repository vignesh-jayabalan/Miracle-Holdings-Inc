terraform {

  required_providers {
    aws = {
      version = ">= 5.39.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_sns_topic" "module_sns" {
  name = "${var.application_name}-${var.workspace_name}-topic"
}

resource "aws_sqs_queue" "module_sns_queue" {
  name = "${var.application_name}-${var.workspace_name}-queue"
}

resource "aws_sns_topic_subscription" "module_sns_sqs_target" {
  topic_arn = aws_sns_topic.module_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.module_sns_queue.arn
}
