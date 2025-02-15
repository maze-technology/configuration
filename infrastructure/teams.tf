resource "github_team" "dependabot-reviewers" {
  name           = "dependabot-reviewers"
  description    = "Reviewers of dependabot version bumps"
  privacy        = "secret"
}
