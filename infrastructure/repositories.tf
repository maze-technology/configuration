# Define repositories

resource "github_repository" "github-configuration" {
  name                    = "github-configuration"
  description             = "Repository managing the Github ones"
  visibility              = "public"
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = true
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = false
  vulnerability_alerts    = true
}

resource "github_repository" "java-microservice-template" {
  name                    = "java-microservice-template"
  description             = "Java microservice base template repository"
  visibility              = "public"
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = true
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = false
  vulnerability_alerts    = true
}
