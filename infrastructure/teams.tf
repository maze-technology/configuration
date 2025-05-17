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
    "idl-engineers" = {
      description = "Maze IDL (Interface Definition Language) engineers"
      privacy     = "closed"
    },
    "infrastructure-engineers" = {
      description = "Maze Infrastructure engineers"
      privacy     = "closed"
    },
    "java-engineers" = {
      description = "Maze Java engineers"
      privacy     = "closed"
    },
    "python-engineers" = {
      description = "Maze Python engineers"
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
