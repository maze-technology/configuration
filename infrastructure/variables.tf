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
    branch_protection_pattern       = string
    required_status_checks_contexts = list(string)
  }))
  default = []
}

locals {
  teams_config = {
    "opentofu-engineers" = {
      description = "Maze OpenTofu engineers on Github"
      privacy     = "closed"
    },
    "java-engineers" = {
      description = "Maze Java engineers on GitHub"
      privacy     = "closed"
    }
  }

  computed_repositories = concat(var.repositories, [
    {
      name                            = ".github"
      description                     = "Github repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = false
      push_teams                      = ["opentofu-engineers"]
      branch_protection_pattern       = "main"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name                            = "${var.github_owner}.github.io"
      description                     = "Website repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = true
      push_teams                      = []
      branch_protection_pattern       = "main"
      required_status_checks_contexts = [] // TODO: Add required status checks
    },
    {
      name                            = "commons"
      description                     = "Commons library repository"
      visibility                      = "public"
      is_template                     = false
      dynamic_pages                   = false
      push_teams                      = ["java-engineers"]
      branch_protection_pattern       = "main"
      required_status_checks_contexts = ["build"]
    },
    {
      name                            = "java-service-template"
      description                     = "Java service base template repository"
      visibility                      = "public"
      is_template                     = true
      dynamic_pages                   = false
      push_teams                      = ["java-engineers"]
      branch_protection_pattern       = "main"
      required_status_checks_contexts = ["build"]
    }
  ])

  repo_push_team_pairs = flatten([
    for repo in local.computed_repositories : [
      for team in repo.push_teams : {
        repo_name = repo.name
        team_name = team
      }
    ]
  ])

  repository_files = fileset("${path.module}/repositories/files", "**")

  other_files = [
    {
      source_file_path = "../.editorconfig"
      destination_path = ".editorconfig"
    },
    {
      source_file_path = "../.prettierrc.json"
      destination_path = ".prettierrc.json"
    }
  ]

  all_repositories_files = concat(
    flatten([
      for repo in local.computed_repositories : [
        for file in local.repository_files : {
          key              = "${repo.name}/${file}"
          repo_name        = repo.name
          source_file_path = "${path.module}/repositories/files/${file}"
          destination_path = file
        }
      ]
    ]),
    flatten([
      for repo in local.computed_repositories : [
        for other_file in local.other_files : {
          key              = "${repo.name}/${other_file.destination_path}"
          repo_name        = repo.name
          source_file_path = other_file.source_file_path
          destination_path = other_file.destination_path
        }
      ]
    ])
  )
}
