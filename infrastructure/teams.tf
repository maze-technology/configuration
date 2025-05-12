locals {
  teams_config = {
    "project-managers" = {
      description = "Maze Project managers"
      privacy     = "closed"
    },
    "release-engineers" = {
      description = "Maze Release engineers"
      privacy     = "closed"
    },
    "github-engineers" = {
      description = "Maze GitHub engineers"
      privacy     = "closed"
    },
    "smithy-engineers" = {
      description = "Maze Smithy engineers"
      privacy     = "closed"
    },
    "opentofu-engineers" = {
      description = "Maze OpenTofu engineers"
      privacy     = "closed"
    },
    "java-engineers" = {
      description = "Maze Java engineers"
      privacy     = "closed"
    }
  }
}

resource "github_team" "teams" {
  for_each    = local.teams_config
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}
