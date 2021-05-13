resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix

  display_name                             = var.display_name
  policy                                   = var.policy
  delivery_policy                          = var.delivery_policy
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn           = var.http_failure_feedback_role_arn
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn         = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn            = var.sqs_failure_feedback_role_arn
  kms_master_key_id                        = var.kms_master_key_id

  tags = var.tags
}

resource "aws_iam_policy" "policy" {
  name        = "access-${lower(var.username)}-${lower(var.name)}-sns"
  description = "Full access to the resource SNS"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish",
        "sns:ListTopics",
        "sns:Unsubscribe",
        "sns:Subscribe",
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:ListSubscriptionsByTopic",
        "sns:ConfirmSubscription"
      ],
      "Resource": [
        "${aws_sns_topic.this[0].arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "${lower(var.username)}-${lower(var.name)}-attachment"
  users      = [var.username]
  policy_arn = "${aws_iam_policy.policy.arn}"
}
