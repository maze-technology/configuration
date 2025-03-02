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
  type = list(object({
    name          = string
    description   = string
    visibility    = string
    is_template   = bool
    dynamic_pages = bool
  }))
  default = [
    {
      name          = ".github"
      description   = "Github repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
    },
    {
      name          = "docs"
      description   = "Documentation repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = true
    },
    {
      name          = "commons"
      description   = "Commons library repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
    },
    {
      name          = "java-service-template"
      description   = "Java service base template repository"
      visibility    = "public"
      is_template   = true
      dynamic_pages = false
    }
  ]
}
