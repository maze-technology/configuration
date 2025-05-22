locals {
  repositories_with_actions_variables = [
    for repo in local.computed_repositories :
    {
      repo           = repo
      variable_name  = "DOCKER_USERNAME"
      variable_value = var.docker_username
    } if lookup(repo, "docker_hub_repository", null) != null
  ]

  repositories_with_actions_secrets = [
    for repo in local.computed_repositories :
    {
      repo         = repo
      secret_name  = "DOCKER_PASSWORD"
      secret_value = var.docker_password
    } if lookup(repo, "docker_hub_repository", null) != null
  ]
}

resource "github_actions_variable" "variables" {
  for_each = {
    for repo in local.repositories_with_actions_variables :
    repo.name => repo
  }

  repository    = each.value.repo.name
  variable_name = each.value.variable_name
  value         = each.value.variable_value
}


resource "github_actions_secret" "secrets" {
  for_each = {
    for repo in local.repositories_with_actions_secrets :
    repo.name => repo
  }

  repository      = each.value.repo.name
  secret_name     = each.value.secret_name
  plaintext_value = each.value.secret_value
}