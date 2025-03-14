resource "github_team" "teams" {
  for_each    = local.teams_config
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}
