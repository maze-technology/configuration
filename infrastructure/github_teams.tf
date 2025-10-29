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
      parent_team = "engineers"
    },
    "release-engineers" = {
      description = "Maze Release engineers"
      privacy     = "closed"
      parent_team = "engineers"
    },
  }
}

resource "github_team" "parents" {
  for_each    = { for k, v in local.teams_config : k => v if !contains(keys(v), "parent_team") }
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_team" "children" {
  for_each       = { for k, v in local.teams_config : k => v if contains(keys(v), "parent_team") }
  name           = each.key
  description    = each.value.description
  privacy        = each.value.privacy
  parent_team_id = github_team.parents[each.value.parent_team].id
}
