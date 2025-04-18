locals {
  repo_push_team_pairs = flatten([
    for repo in local.computed_repositories : [
      for team in repo.push_teams : {
        repo_name = repo.name
        team_name = team
      }
    ]
  ])
}

resource "github_team_repository" "push_teams" {
  for_each = {
    for pair in local.repo_push_team_pairs :
    "${pair.repo_name}-${pair.team_name}" => pair
  }

  team_id    = github_team.teams[each.value.team_name].id
  repository = github_repository.repo[each.value.repo_name].name
  permission = "push"
}
