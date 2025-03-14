resource "github_team" "opentofu-engineers" {
  name        = "opentofu-engineers"
  description = "OpenTofu engineers"
  privacy     = "closed"
}

resource "github_team" "java-engineers" {
  name        = "java-engineers"
  description = "Java engineers"
  privacy     = "closed"
}
