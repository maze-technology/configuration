locals {
  teams_config = {
    "project-managers" = {
      description = "Maze Project managers"
      privacy     = "closed"
    },
    "engineers" = {
      description = "Maze Engineers"
      privacy     = "closed"
    },
    "infrastructure-engineers" = {
      description = "Maze Infrastructure engineers"
      privacy     = "closed"
      parent_team_id = github_team.teams["engineers"].id
    },
    "release-engineers" = {
      description = "Maze Release engineers"
      privacy     = "closed"
      parent_team_id = github_team.teams["engineers"].id
    },
  }
}

resource "github_team" "teams" {
  for_each    = local.teams_config
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
  parent_team_id = each.value.parent_team_id
}
