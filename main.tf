provider "aws" {
  region = "us-east-1"
}

variable "instance_id" {
  description = "The ID of the EC2 instance to monitor"
  type        = string
}

variable "cpu_utilization_period" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = string
}

variable "cpu_utilization_threshold" {
  description = "The value against which the specified statistic is compared"
  type        = string
}

variable "cpu_utilization_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = string
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "ec2-utilization-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cpu_utilization_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_utilization_period
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
  alarm_description   = "This metric checks if the CPU utilization is less than  10% for  3 consecutive periods of  5 minutes."
  alarm_actions       = [aws_lambda_function.stop_ec2.arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "stop_ec2" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "stop_ec2"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_alarms" {
  statement_id  = "AllowExecutionFromCloudWatchAlarms"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn    = aws_cloudwatch_metric_alarm.cpu_utilization.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:StopInstances"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}