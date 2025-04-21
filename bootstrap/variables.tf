variable "default_tags" {
  type = map(string)
}

variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}
