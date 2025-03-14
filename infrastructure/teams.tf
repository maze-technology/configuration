resource "github_team" "opentofu-reviewers" {
  name        = "opentofu-reviewers"
  description = "Reviewers of OpenTofu code"
  privacy     = "closed"
}

resource "github_team" "java-reviewers" {
  name        = "java-reviewers"
  description = "Reviewers of Java code"
  privacy     = "closed"
}
