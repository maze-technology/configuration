locals {
  repo_push_team_pairs = flatten([
    for repo in local.computed_repositories : [
      for team in repo.push_teams : {
        repo_name = repo.name
        team_name = team
      }
    ]
  ])

  teams_by_name = merge(
    { for k, t in github_team.parents : t.name => t.id },
    { for k, t in github_team.children : t.name => t.id }
  )
}

resource "github_team_repository" "push_teams" {
  for_each = {
    for pair in local.repo_push_team_pairs :
    "${pair.repo_name}-${pair.team_name}" => pair
  }

  team_id    = local.teams_by_name[each.value.team_name]
  repository = github_repository.repo[each.value.repo_name].name
  permission = "push"
}
