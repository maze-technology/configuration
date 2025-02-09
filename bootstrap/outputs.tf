output "s3_bucket_name" {
  description = "The name of the S3 bucket used for OpenTofu state storage"
  value       = aws_s3_bucket.github_opentofu_state.bucket
}

output "kms_key_alias" {
  description = "The alias of the KMS key used for encrypting the state"
  value       = aws_kms_alias.github_opentofu_state_key_alias.name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking"
  value       = aws_dynamodb_table.github_opentofu_state_locks.name
}

output "maze_github_actions_role_arn" {
  description = "The ARN of the IAM role used by GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}
