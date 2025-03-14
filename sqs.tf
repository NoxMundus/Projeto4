resource "aws_sqs_queue" "terraform_queue" {
  name                      = "${var.fila_sqs}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })
  tags = {
    Environment = "${var.project_name}"
  }
}

resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "${var.fila_sqs}-deadletter-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Environment = "${var.project_name}"
  }
}
