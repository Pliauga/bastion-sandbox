# Baseline workload: a role that reads one reports bucket.
# This is the "before" state of the live-fire pull request. It is deliberately
# unremarkable -- a reviewer should be able to merge it without a second look.

resource "aws_iam_role" "report_reader" {
  name = "report_reader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    workload = "reporting"
  }
}

resource "aws_iam_role_policy" "report_reader_s3" {
  name = "report-reader-s3"
  role = aws_iam_role.report_reader.name

  policy = <<-JSON
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:GetObject"],
        "Resource": "arn:aws:s3:::acme-reports/monthly/*"
      },
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": "arn:aws:s3:::acme-reports"
      }
    ]
  }
  JSON
}
