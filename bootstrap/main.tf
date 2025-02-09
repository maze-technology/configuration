resource "aws_kms_key" "github_opentofu_state_key" {
  description             = "KMS key for Github OpenTofu state"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "github_opentofu_state_key_alias" {
  name          = "alias/${local.formatted_default_tags_values}_github-opentofu-state-key"
  target_key_id = aws_kms_key.github_opentofu_state_key.id
}

resource "aws_s3_bucket" "github_opentofu_state" {
  bucket = "${local.formatted_default_tags_values}-github-opentofu-state"
}

resource "aws_s3_bucket_versioning" "github_opentofu_state_versioning" {
  bucket = aws_s3_bucket.github_opentofu_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "github_opentofu_state_lifecycle" {
  bucket = aws_s3_bucket.github_opentofu_state.id

  rule {
    id     = "limit-version-history"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 365 # Retain non-current versions for 1 year
    }

    # Optionally limit the number of non-current versions retained
    noncurrent_version_transition {
      noncurrent_days = 30 # Move non-current versions to a cheaper storage tier after 30 days
      storage_class   = "GLACIER_IR"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "github_opentofu_state_encryption" {
  bucket = aws_s3_bucket.github_opentofu_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.github_opentofu_state_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "github_opentofu_state_locks" {
  name         = "${local.formatted_default_tags_values}_github-opentofu-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_role" "github_actions_role" {
  name = "${local.formatted_default_tags_values}_GitHubActionsRole"

  assume_role_policy = templatefile("iam/github-actions-trust-policy.json", {
    AWS_ACCOUNT_ID  = var.aws_account_id
    GITHUB_USERNAME = var.github_username
    GITHUB_REPO     = var.github_repo
  })
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name   = "${local.formatted_default_tags_values}_GitHubRestrictedPolicy"
  role   = aws_iam_role.github_actions_role.id
  policy = templatefile("iam/github-actions-policy.json", {
    S3_BUCKET_ARN           = aws_s3_bucket.github_opentofu_state.arn
    DYNAMODB_TABLE_ARN      = aws_dynamodb_table.github_opentofu_state_locks.arn
    KMS_KEY_ALIAS_ARN       = aws_kms_alias.github_opentofu_state_key_alias.arn
    GITHUB_ACTIONS_ROLE_ARN = aws_iam_role.github_actions_role.arn
  })
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}
