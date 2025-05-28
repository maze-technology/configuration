locals {
  docker_hub_repositories = concat([
    for repo in local.computed_repositories :
    repo.docker_hub_repository if lookup(repo, "docker_hub_repository", null) != null
    ],
  []) // INFO: Empty list to be configured in the future
}

resource "docker_hub_repository" "repositories" {
  for_each = {
    for repo in local.docker_hub_repositories :
    repo.name => repo
  }

  namespace   = var.docker_org_namespace
  name        = each.value.name
  description = each.value.description
  private     = false
}