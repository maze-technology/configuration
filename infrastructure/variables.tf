variable "github_owner" {
  description = "GitHub organization name"
  type        = string
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = number
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = number
}

variable "github_app_private_key_path" {
  description = "Path to the GitHub App private key"
  type        = string
}

variable "repositories" {
  description = "List of repository configurations. Leave empty to use defaults."
  type = list(object({
    name                            = string
    description                     = string
    visibility                      = string
    is_template                     = bool
    dynamic_pages                   = bool
    push_teams                      = list(string)
    branches                        = list(string)
    protected_branches              = list(string)
    default_branch                  = optional(string)
    required_status_checks_contexts = list(string)
    template = optional(object({
      owner      = string
      repository = string
    }))
  }))
  default = []
}
