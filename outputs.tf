output "access_key_id" {
  description = "The access key ID for the IAM user. This is used for programmatic access to AWS."
  value       = aws_iam_access_key.service_account_key.id
}

output "secret_access_key" {
  description = "The secret access key for the IAM user. This value is sensitive and should be handled securely."
  value       = aws_iam_access_key.service_account_key.secret
  sensitive   = true
}

output "user_name" {
  description = "The name of the created IAM user."
  value       = aws_iam_user.service_account.name
}

output "user_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM user. This is a unique identifier for the user."
  value       = aws_iam_user.service_account.arn
}

output "user_id" {
  description = "The unique ID of the IAM user. This can be used for programmatic identification and tracking."
  value       = aws_iam_user.service_account.unique_id
}

output "attached_policies" {
  description = "A list of the policy ARNs attached to the IAM user."
  value       = [for k, v in aws_iam_user_policy_attachment.default_policy_attachment : v.policy_arn]
}