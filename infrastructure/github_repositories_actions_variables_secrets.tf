locals {
  repositories_with_actions_variables = concat([
    for repo in local.computed_repositories :
    {
      repo           = repo
      variable_name  = "DOCKER_USERNAME"
      variable_value = var.docker_username
    } if lookup(repo, "docker_hub_repository", null) != null
    ], [
    for repo in local.computed_repositories :
    {
      repo           = repo
      variable_name  = "DOCKER_REPOSITORY"
      variable_value = docker_hub_repository.repositories[repo.docker_hub_repository.name].id
    } if lookup(repo, "docker_hub_repository", null) != null
  ])

  repositories_with_actions_secrets = concat([
    for repo in local.computed_repositories :
    {
      repo         = repo
      secret_name  = "DOCKER_PASSWORD"
      secret_value = var.docker_password
    } if lookup(repo, "docker_hub_repository", null) != null
    ])
}

resource "github_actions_variable" "variables" {
  for_each = {
    for element in local.repositories_with_actions_variables :
    "${element.repo.name}-${element.variable_name}" => element
  }

  repository    = each.value.repo.name
  variable_name = each.value.variable_name
  value         = each.value.variable_value

  depends_on = [github_repository.repo]
}


resource "github_actions_secret" "secrets" {
  for_each = {
    for element in local.repositories_with_actions_secrets :
    "${element.repo.name}-${element.secret_name}" => element
  }

  repository      = each.value.repo.name
  secret_name     = each.value.secret_name
  plaintext_value = each.value.secret_value

  depends_on = [github_repository.repo]
}