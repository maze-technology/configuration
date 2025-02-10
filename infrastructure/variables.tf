variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "github_token" {
  type      = string
  sensitive = true
}
