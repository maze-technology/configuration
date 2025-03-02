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
    name          = string
    description   = string
    visibility    = string
    is_template   = bool
    dynamic_pages = bool
  }))
  default = []
}

locals {
  computed_repositories = concat(var.repositories, [
    {
      name          = ".github"
      description   = "Github repository"
      visibility    = "public"
      is_template   = false
      dynamic_pages = false
    },
    {
      name          = "${var.github_owner}.github.io"
      description   = "Website repository"
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
  ])

  repositories_files = concat(
    fileset("${path.module}/repositories/files", "**"),
    ["${path.root}/.editorconfig", "${path.root}/LICENSE"]
  )

  repository_file_combinations = flatten([
    for repo in local.computed_repositories : [
      for file in local.repositories_files : {
        key       = "${repo.name}/${file}"
        repo_name = repo.name
        file_path = file
      }
    ]
  ])
}
