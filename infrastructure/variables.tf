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

variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "docker_org_namespace" {
  description = "Docker Hub organization namespace"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub password"
  type        = string
  sensitive   = true
}

variable "sonar_token" {
  description = "SonarCloud API token"
  type        = string
  sensitive   = true
}

variable "github_repositories" {
  description = "List of GitHub repository configurations. Leave empty to use defaults."
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
    docker_hub_repository = optional(object({
      name        = string
      description = string
    }))
  }))
  default = []
}
