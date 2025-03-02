# Define repositories

resource "github_repository" "github" {
  name                    = ".github"
  description             = "Github repository"
  visibility              = "public"
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = false
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = false
  vulnerability_alerts    = true
}

resource "github_repository" "docs" {
  name                    = "docs"
  description             = "Documentation repository"
  visibility              = "public"
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = false
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = true
  vulnerability_alerts    = true

  pages {
    source {
      branch = "main"
      path   = "/"
    }
  }
}

resource "github_repository" "commons" {
  name                    = "commons"
  description             = "Commons library repository"
  visibility              = "public"
  has_issues              = true
  has_wiki                = false
  has_projects            = false
  has_downloads           = false
  archive_on_destroy      = true
  is_template             = false
  allow_merge_commit      = false
  allow_squash_merge      = true
  allow_rebase_merge      = false
  allow_auto_merge        = false
  delete_branch_on_merge  = true
  auto_init               = false
  vulnerability_alerts    = true
}

resource "github_repository" "java-service-template" {
  name                    = "java-service-template"
  description             = "Java service base template repository"
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
