locals {
  docker_hub_repositories = concat([
    for repo in locals.computed_repositories :
    repo.docker_hub_repository if lookup(repo, "docker_hub_repository", null) != null
    ],
  []) // INFO: Empty list to be configured in the future
}

resource "docker_repository" "repositories" {
  for_each = {
    for repo in local.docker_hub_repositories :
    repo.name => repo
  }

  name        = each.value.name
  description = each.value.description
  private     = false
}