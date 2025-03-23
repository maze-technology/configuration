locals {
  teams_config = {
    "release-engineers" = {
      description = "Maze release engineers"
      privacy     = "closed"
    },
    "github-ci-engineers" = {
      description = "Maze GitHub CI engineers"
      privacy     = "closed"
    },
    "protobuf-engineers" = {
      description = "Maze Protobuf engineers"
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
