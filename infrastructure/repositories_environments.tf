resource "github_repository_environment" "production" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  environment = "production"
  repository  = github_repository.repo[each.value.name].name

  reviewers {
    teams = ["release-engineers"]
  }
}
