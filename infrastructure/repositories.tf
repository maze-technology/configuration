resource "github_repository" "repo" {
  for_each = {
    for repo in local.computed_repositories :
    repo.name => repo
  }

  name                   = each.value.name
  description            = each.value.description
  visibility             = each.value.visibility
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  has_downloads          = false
  archive_on_destroy     = true
  is_template            = each.value.is_template
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  allow_auto_merge       = false
  delete_branch_on_merge = true
  auto_init              = true # INFO: Mandatory for adding a license file later
  vulnerability_alerts   = true

  dynamic "pages" {
    for_each = each.value.dynamic_pages ? [1] : []

    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }
}
