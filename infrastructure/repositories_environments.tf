resource "github_repository_environment" "release" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  environment         = "release"
  repository          = github_repository.repo[each.value.name].name

  reviewers {
    teams = [github_team.teams["release-engineers"].id]
  }

  prevent_self_review = true
}
